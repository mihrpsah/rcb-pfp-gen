# RCB Profile Picture Generator

A web application that allows users to upload their photos and generate profile pictures with custom backgrounds for the RCB community.

## Features

- Upload and crop user photos
- Select from a variety of RCB-themed backgrounds
- Automatic background removal using U2-Net AI model
- Combine user photos with selected backgrounds
- Download generated profile pictures

## Project Structure

```
rcb-pfp-gen/
├── frontend/           # React frontend application
├── backend/            # Flask API server
├── bg/                 # Background images
├── docker-compose.yml  # Docker configuration
└── DEPLOYMENT.md       # Detailed deployment guide
```

## Prerequisites

- Node.js 14+ for frontend
- Python 3.9+ for backend
- Docker and Docker Compose (optional, for containerized deployment)

## Quick Start

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/rcb-pfp-gen.git
   cd rcb-pfp-gen
   ```

2. Set up the frontend:
   ```bash
   cd frontend
   npm install
   npm start
   ```

3. Set up the backend:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   python download_model.py  # Download the U2-Net model
   python app.py
   ```

4. Add background images to the `bg` directory.

5. Access the application at http://localhost:3000

### Docker Deployment

For containerized deployment:

```bash
./docker-deploy.sh
```

Access the application at http://localhost

## Deployment

### Preparing for Deployment

We've included several tools to help you deploy the application:

1. **Deployment Check**: Run `./deployment-check.sh` to verify all necessary files are present.

2. **Deployment Preparation**: Run `./prepare-deployment.sh` to prepare both frontend and backend for deployment.

3. **Deployment Checklist**: Use `DEPLOYMENT_CHECKLIST.md` to ensure all steps are completed.

4. **Detailed Guide**: For comprehensive instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

### Deployment Options

1. **Separate Deployment (Recommended)**:
   - Deploy the frontend to a static hosting service (Netlify, Vercel, GitHub Pages)
   - Deploy the backend to a Python-compatible cloud platform (Heroku, Railway, Render)

2. **Docker Deployment**:
   - Deploy both frontend and backend using Docker with the provided configuration

3. **Render Deployment (Easiest)**:
   - One-click deployment to Render using the provided `render.yaml` file
   - Or use the Render-specific deployment script: `cd backend && ./render-deploy.sh`
   - Follow the instructions provided by the script

## Technology Stack

### Frontend
- React.js
- Axios for API requests
- React Cropper for image cropping

### Backend
- Flask for the API server
- U2-Net for background removal
- Pillow for image processing

## License

[MIT License](LICENSE)

## Acknowledgements

- [U2-Net](https://github.com/xuebinqin/U-2-Net) for the background removal model
- RCB community for inspiration and support 