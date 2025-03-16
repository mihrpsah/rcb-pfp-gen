# Deploying to Render

This guide provides updated instructions for deploying the RCB Profile Picture Generator to Render.

## Using the Blueprint (render.yaml)

### Step 1: Push Your Code to GitHub

Make sure your code with the updated `render.yaml` file is pushed to GitHub.

### Step 2: Deploy Using Blueprint

1. Log in to your [Render Dashboard](https://dashboard.render.com/)
2. Click the "New +" button
3. Select "Blueprint" from the dropdown menu
4. Connect your GitHub repository
5. Render will detect the `render.yaml` file and show you the services to be created
6. Click "Apply Blueprint" to start the deployment

## Manual Deployment (If Blueprint Doesn't Work)

If you encounter issues with the Blueprint deployment, you can deploy the services manually:

### Step 1: Deploy the Backend

1. In your Render Dashboard, click "New +" and select "Web Service"
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `rcb-pfp-generator-backend`
   - **Root Directory**: `backend` (if your backend is in a subdirectory)
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt && python download_model.py`
   - **Start Command**: `gunicorn app:app`
4. Add the following environment variables:
   - `DEBUG`: `False`
   - `UPLOAD_FOLDER`: `uploads`
   - `BG_FOLDER`: `bg`
   - `MODEL_DIR`: `saved_models`
5. Click "Create Web Service"

### Step 2: Deploy the Frontend

1. In your Render Dashboard, click "New +" and select "Static Site"
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `rcb-pfp-generator-frontend`
   - **Root Directory**: `frontend` (if your frontend is in a subdirectory)
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `build`
4. Add the following environment variable:
   - `REACT_APP_API_URL`: The URL of your backend service (e.g., `https://rcb-pfp-generator-backend.onrender.com`)
5. Click "Create Static Site"

## Handling Background Images

Since the free tier of Render doesn't support persistent disk storage, you'll need to handle background images differently:

### Option 1: Include Background Images in Your Repository

1. Add your background images to the `bg` directory in your repository
2. Push the changes to GitHub
3. Redeploy your backend service

### Option 2: Upload Images After Deployment

1. After deploying your backend, go to the "Shell" tab in your backend service
2. Create the background images directory: `mkdir -p bg`
3. Use the shell to upload images or download them from a URL:
   ```bash
   cd bg
   curl -O https://example.com/path/to/image1.jpg
   curl -O https://example.com/path/to/image2.jpg
   ```

## Troubleshooting the U2-Net Model Download

If the model download fails during deployment:

1. Go to the "Shell" tab in your backend service
2. Run the manual download script:
   ```bash
   cd backend  # If not already in the backend directory
   ./manual_model_download.sh
   ```
3. If that fails, download the model manually and upload it:
   ```bash
   mkdir -p saved_models
   cd saved_models
   curl -L https://github.com/xuebinqin/U-2-Net/releases/download/v1.0/u2net.pth -o u2net.pth
   ```

## Verifying Your Deployment

1. Visit your frontend URL (e.g., `https://rcb-pfp-generator-frontend.onrender.com`)
2. Upload an image and select a background
3. Generate a profile picture
4. If you encounter issues, check the logs in your Render dashboard 