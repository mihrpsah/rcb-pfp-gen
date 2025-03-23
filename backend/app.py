import os
import io
import base64
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import numpy as np
from PIL import Image
import torch
from torchvision import transforms
from model import U2NET
import json
from dotenv import load_dotenv
from flask_cors import CORS
import datetime


# Load environment variables
load_dotenv()

# Handle different Pillow versions
try:
    LANCZOS = Image.LANCZOS
except AttributeError:
    LANCZOS = Image.Resampling.LANCZOS

app = Flask(__name__)
CORS(app, origins=["https://rcb.anirudhasah.com", "http://localhost:4321"])

# Configuration
UPLOAD_FOLDER = os.environ.get('UPLOAD_FOLDER', 'uploads')
GENERATED_FOLDER = os.environ.get('GENERATED_FOLDER', 'generated_images')
BG_FOLDER = '../astro/src/assets/teams'
MODEL_DIR = os.environ.get('MODEL_DIR', 'saved_models')
MODEL_PATH = os.path.join(MODEL_DIR, 'u2net.pth')

# Create directories if they don't exist
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(MODEL_DIR, exist_ok=True)
os.makedirs(GENERATED_FOLDER, exist_ok=True)

# Initialize model
model = None

# Load the U2NET model
def load_model():
    global model
    if model is not None:
        return model

    print("Loading U2-Net model...")
    model = U2NET(3, 1)
    if torch.cuda.is_available():
        model.load_state_dict(torch.load(MODEL_PATH))
        model.cuda()
    else:
        model.load_state_dict(torch.load(MODEL_PATH, map_location='cpu', weights_only = False))
    model.eval()
    print("Model loaded successfully!")
    return model

# Replace @app.before_first_request with a function that gets called on first API request
@app.before_request
def initialize():
    global model
    if model is None:
        model = load_model()

# Preprocessing for the model
def preprocess_image(image):
    # Resize
    image = image.resize((320, 320), LANCZOS)
    # Convert to tensor
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])
    image_tensor = transform(image).unsqueeze(0)
    return image_tensor

# Normalize the prediction
def normalize_prediction(prediction):
    ma = torch.max(prediction)
    mi = torch.min(prediction)
    return (prediction - mi) / (ma - mi)

# Root route for health check
@app.route('/')
def index():
    return jsonify({
        'status': 'ok',
        'message': 'RCB Profile Picture Generator API is running'
    })

# Process the image
@app.route('/api/process', methods=['POST'])
def process_image():
    if 'image' not in request.files or 'background' not in request.form or 'team' not in request.form:
        return jsonify({'error': 'Missing image, background or team'}), 400

    # Get the uploaded image
    file = request.files['image']
    background_name = request.form['background']
    bg_folder = os.path.join(BG_FOLDER, request.form['team'])

    # Get resize percentage with default value of 70%
    resize_percentage = float(request.form.get('resize_percentage', 0.75))

    # Limit resize percentage to reasonable values (between 0.1 and 1.0)
    resize_percentage = max(0.1, min(1.0, resize_percentage))

    # Load background first to get its dimensions
    background_path = os.path.join(bg_folder, background_name)
    background = Image.open(background_path).convert('RGB')

    # Read the user image
    image = Image.open(file.stream).convert('RGB')

    # Prepare the image for segmentation
    # We'll work with the original image size for segmentation
    original_size = image.size

    # Preprocess for the model
    image_tensor = preprocess_image(image)

    # Get prediction
    if torch.cuda.is_available():
        image_tensor = image_tensor.cuda()

    with torch.no_grad():
        prediction = model(image_tensor)[0]

    # Process the mask
    prediction = normalize_prediction(prediction)
    prediction = prediction.squeeze().cpu().numpy()

    # Resize mask to original image size and apply threshold for better segmentation
    mask = Image.fromarray((prediction * 255).astype(np.uint8))
    mask = mask.resize(original_size, LANCZOS)

    # Convert to numpy array and apply threshold
    mask_np = np.array(mask) / 255.0
    # Apply threshold to make the mask more binary (better separation)
    mask_np = np.where(mask_np > 0.2, 1.0, 0.0)

    # Create foreground with alpha channel
    foreground_rgba = np.zeros((original_size[1], original_size[0], 4), dtype=np.uint8)
    foreground_rgba[:, :, 0:3] = np.array(image)
    # Fix: Ensure mask_np is in the right shape for alpha channel assignment
    foreground_rgba[:, :, 3] = (mask_np * 255).astype(np.uint8)

    # Convert to PIL image
    foreground_img = Image.fromarray(foreground_rgba, 'RGBA')

    # Find the actual height of the non-transparent part
    alpha_channel = foreground_rgba[:, :, 3]
    non_transparent_rows = np.where(alpha_channel.max(axis=1) > 0)[0]

    if len(non_transparent_rows) > 0:
        min_row = non_transparent_rows.min()
        max_row = non_transparent_rows.max()
        actual_height = max_row - min_row + 1

        # Find the actual width too
        non_transparent_cols = np.where(alpha_channel.max(axis=0) > 0)[0]
        min_col = non_transparent_cols.min()
        max_col = non_transparent_cols.max()
        actual_width = max_col - min_col + 1

        # Calculate the target height based on background height and resize percentage
        target_height = int(background.height * resize_percentage)

        # Calculate new width to maintain aspect ratio
        scale_factor = target_height / actual_height
        target_width = int(actual_width * scale_factor)

        # Crop the foreground to include only the non-transparent part
        foreground_cropped = foreground_img.crop((min_col, min_row, max_col + 1, max_row + 1))

        # Resize the cropped foreground
        foreground_resized = foreground_cropped.resize((target_width, target_height), LANCZOS)

        # Create a new foreground image with background dimensions
        final_foreground = Image.new('RGBA', (background.width, background.height), (0, 0, 0, 0))

        # Calculate horizontal position to center
        x_position = (background.width - target_width) // 2

        y_position = background.height - target_height

        # Paste the resized foreground onto the new image
        final_foreground.paste(foreground_resized, (x_position, y_position))

        # Convert background to RGBA
        background_rgba = background.convert('RGBA')

        # Composite final image
        result = Image.alpha_composite(background_rgba, final_foreground)
    else:
        # If no foreground was detected, just return the background
        result = background.convert('RGBA')

    # Convert to RGB for final output
    result = result.convert('RGB')

    # Generate unique filename with timestamp
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"generated_image_{timestamp}.png"
    filepath = os.path.join(GENERATED_FOLDER, filename)

    # Save the image
    result.save(filepath)

    # Convert to base64 for response
    buffered = io.BytesIO()
    result.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode('utf-8')

    return jsonify({
        'result': f"data:image/png;base64,{img_str}",
        'saved_path': filepath
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=os.environ.get('DEBUG', 'True').lower() == 'true',
            host='0.0.0.0',
            port=port)
