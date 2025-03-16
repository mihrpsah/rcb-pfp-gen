import os
import gdown
import torch
import sys

MODEL_DIR = 'saved_models'
MODEL_PATH = os.path.join(MODEL_DIR, 'u2net.pth')

# Create directory if it doesn't exist
os.makedirs(MODEL_DIR, exist_ok=True)

def download_model():
    if os.path.exists(MODEL_PATH):
        print(f"Model already exists at {MODEL_PATH}")
        return
    
    print("Downloading U2-Net model...")
    # U2-Net model Google Drive ID
    url = 'https://drive.google.com/uc?id=1ao1ovG1Qtx4b7EoskHXmi2E9rp5CHLcZ'
    
    try:
        gdown.download(url, MODEL_PATH, quiet=False)
        print(f"Model downloaded successfully to {MODEL_PATH}")
        
        # Verify the model can be loaded
        try:
            if sys.version_info >= (3, 8):
                # For Python 3.8+
                model_state = torch.load(MODEL_PATH, map_location='cpu')
                print("Model verified successfully!")
            else:
                # For older Python versions
                model = torch.load(MODEL_PATH, map_location='cpu')
                print("Model verified successfully!")
        except Exception as e:
            print(f"Error verifying model: {e}")
            if os.path.exists(MODEL_PATH):
                os.remove(MODEL_PATH)
            print("Removed corrupted model file. Please try downloading again.")
    except Exception as e:
        print(f"Error downloading model: {e}")

if __name__ == "__main__":
    download_model() 