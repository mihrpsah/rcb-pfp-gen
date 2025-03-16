# Deployment Guide for RCB Profile Picture Generator

This guide will help you deploy the RCB Profile Picture Generator to production.

## Overview

The application consists of two parts:
1. **Frontend**: React application
2. **Backend**: Flask API server

For optimal deployment, we recommend deploying these components separately:
- Frontend on a static hosting service
- Backend on a cloud platform that supports Python

## Frontend Deployment

### Step 1: Build the Frontend

```bash
cd frontend
./build.sh
```

This will create a `build` directory with optimized static files.

### Step 2: Deploy to a Static Hosting Service

#### Option 1: Netlify

1. Create an account on [Netlify](https://www.netlify.com/)
2. Install Netlify CLI: `npm install -g netlify-cli`
3. Deploy: `netlify deploy --prod --dir=build`

#### Option 2: Vercel

1. Create an account on [Vercel](https://vercel.com/)
2. Install Vercel CLI: `npm install -g vercel`
3. Deploy: `vercel --prod`

#### Option 3: GitHub Pages

1. Create a GitHub repository
2. Push your code to the repository
3. Enable GitHub Pages in the repository settings
4. Set the source to the `gh-pages` branch
5. Install gh-pages: `npm install --save-dev gh-pages`
6. Add to package.json: `"deploy": "gh-pages -d build"`
7. Deploy: `npm run deploy`

### Step 3: Configure Environment Variables

After deploying, set the `REACT_APP_API_URL` environment variable to point to your backend URL.

## Backend Deployment

### Step 1: Prepare the Backend

```bash
cd backend
./deploy.sh
```

This will download the U2-Net model and create a production .env file.

### Step 2: Deploy to a Cloud Platform

#### Option 1: Heroku

1. Create an account on [Heroku](https://www.heroku.com/)
2. Install Heroku CLI: `npm install -g heroku`
3. Create a new app: `heroku create rcb-pfp-generator-api`
4. Add Python buildpack: `heroku buildpacks:set heroku/python`
5. Deploy: `git subtree push --prefix backend heroku main`

#### Option 2: Railway

1. Create an account on [Railway](https://railway.app/)
2. Install Railway CLI: `npm install -g @railway/cli`
3. Login: `railway login`
4. Create a new project: `railway init`
5. Deploy: `railway up`

#### Option 3: Render

1. Create an account on [Render](https://render.com/)
2. Create a new Web Service
3. Connect your GitHub repository
4. Set the build command: `pip install -r requirements.txt`
5. Set the start command: `gunicorn app:app`

### Detailed Render Deployment Guide

Render is a great option for deploying your Flask backend. Here's a detailed guide:

1. **Create a Render Account**
   - Go to [render.com](https://render.com/)
   - Sign up using your email, GitHub, or Google account

2. **Create a New Web Service**
   - Click on the "New +" button and select "Web Service"
   - Connect your Git repository
   - Select the repository containing your RCB Profile Picture Generator

3. **Configure the Web Service**
   - **Name**: `rcb-pfp-generator-backend` (or any name you prefer)
   - **Environment**: `Python 3`
   - **Region**: Choose the region closest to your users
   - **Branch**: `main` (or your default branch)
   - **Root Directory**: If your backend is in a subdirectory, specify it (e.g., `backend`)
   - **Build Command**: 
     ```
     pip install -r requirements.txt && python download_model.py
     ```
   - **Start Command**: 
     ```
     gunicorn app:app
     ```

4. **Configure Environment Variables**
   - Add the following environment variables:
     - `DEBUG`: `False`
     - `PORT`: Leave this blank (Render will set it automatically)
     - `UPLOAD_FOLDER`: `uploads`
     - `BG_FOLDER`: `bg`
     - `MODEL_DIR`: `saved_models`

5. **Configure Advanced Settings**
   - Click on "Advanced" to expand additional settings
   - Under "Health Check Path", enter `/` (this will use our root endpoint for health checks)
   - Set the "Instance Type" to "Free" for testing, or choose a paid plan for production use

6. **Handle the U2-Net Model**
   - Our updated `download_model.py` script will attempt to download the model from multiple sources
   - If all automatic downloads fail during deployment, you can:
     - SSH into your Render instance using the Shell tab
     - Manually download the model using:
       ```bash
       cd saved_models
       curl -L https://github.com/xuebinqin/U-2-Net/releases/download/v1.0/u2net.pth -o u2net.pth
       ```

7. **Upload Background Images**
   - In the Render dashboard, go to your web service
   - Click on the "Shell" tab
   - Create the background directory if it doesn't exist:
     ```bash
     mkdir -p bg
     ```
   - You can upload images using the Render shell, but it's easier to use the Render Disk feature:
     - Go to "Disks" in the Render dashboard
     - Create a new disk and attach it to your service
     - Mount it at `/app/bg`
     - Upload your background images to this disk

8. **Verify the Deployment**
   - Once deployment is complete, Render will provide a URL for your service
   - Visit this URL in your browser to verify the API is running
   - Test the `/api/backgrounds` endpoint to verify background images are accessible

9. **Update Frontend Configuration**
   - Update your frontend's `.env.production` file with the Render URL:
     ```
     REACT_APP_API_URL=https://your-render-service-url.onrender.com
     ```

10. **Troubleshooting**
    - If you encounter memory issues, consider upgrading to a paid Render plan
    - For cold start issues (free tier), implement a periodic ping to keep the service active
    - For file storage, use Render Disks or a cloud storage service like AWS S3

### Step 3: Configure the Background Images

Make sure to upload your background images to the `bg` directory on your server.

## Connecting Frontend and Backend

After deploying both components, update the frontend's environment variable to point to your backend URL:

```
REACT_APP_API_URL=https://your-backend-url.com
```

## Testing the Deployment

1. Visit your frontend URL
2. Upload an image
3. Select a background
4. Click "Generate Profile Picture"
5. Verify that the image is processed correctly

## Troubleshooting

### Common Issues

1. **CORS Errors**: Make sure your backend has CORS enabled for your frontend domain
2. **Missing Model**: Verify that the U2-Net model was downloaded correctly
3. **Missing Background Images**: Check that your background images are in the correct directory
4. **Environment Variables**: Ensure all environment variables are set correctly

### Logs

Check the logs of your deployed applications for any errors:

- Heroku: `heroku logs --tail`
- Railway: `railway logs`
- Render: Check the logs in the Render dashboard

## Scaling Considerations

- The U2-Net model requires significant memory. Consider using a server with at least 1GB of RAM.
- For high traffic, consider implementing caching for the background images.
- The image processing is CPU-intensive. Consider using a server with multiple CPUs for better performance.

## Cost Optimization

- Use a free tier for initial deployment and testing
- Consider serverless options for low-traffic applications
- Optimize the model size or use a smaller model for faster processing
- Implement caching to reduce computational load 

## Docker Deployment

For users who prefer containerized deployment, we've included Docker support for both frontend and backend.

### Prerequisites

- Docker installed on your server
- Docker Compose installed on your server

### Step 1: Prepare Your Environment

Ensure you have background images in the `bg` directory at the root of the project.

### Step 2: Deploy with Docker

Run the deployment script:

```bash
./docker-deploy.sh
```

This script will:
1. Check for Docker and Docker Compose installation
2. Create necessary directories
3. Build and start the containers for both frontend and backend

### Step 3: Access Your Application

- Frontend: http://your-server-ip
- Backend API: http://your-server-ip:5000

### Managing Your Docker Deployment

- **Stop the application**: `docker-compose down`
- **View logs**: `docker-compose logs -f`
- **Restart services**: `docker-compose restart`
- **Update after code changes**: `docker-compose up -d --build`

### Docker Deployment to Cloud Providers

You can deploy your Docker containers to various cloud providers:

#### AWS Elastic Container Service (ECS)

1. Create an ECR repository for your images
2. Push your images to ECR
3. Create an ECS cluster
4. Define a task definition using your images
5. Create a service to run your task

#### Google Cloud Run

1. Push your images to Google Container Registry
2. Deploy to Cloud Run with appropriate memory settings

#### Digital Ocean App Platform

1. Connect your repository
2. Configure as a Docker App
3. Deploy using the provided docker-compose.yml

### Docker Deployment Considerations

- Ensure your server has enough resources to run the U2-Net model
- Consider using Docker volumes for persistent storage of uploads and models
- For production, use a reverse proxy like Nginx or Traefik in front of your containers
- Set up proper monitoring and logging for your containers 