# RCB Profile Picture Generator

A web application that allows users to upload their pictures and replace the background with RCB-themed backgrounds.

## Features

- Upload your photo
- Automatically remove the background using U2-Net
- Replace with RCB-themed backgrounds
- Download the generated profile picture

## Tech Stack

- **Frontend**: React with Chakra UI
- **Backend**: Flask
- **Background Removal**: U2-Net

## Setup Instructions

### Quick Start

The easiest way to run the application is using the provided script:

```
./run.sh
```

This will set up everything and start both the backend and frontend servers.

### Manual Setup

If you encounter issues with the quick start, you can run the components separately:

#### Backend Setup

1. Create a virtual environment:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

3. Download the U2-Net model:
   ```
   cd backend
   python download_model.py
   cd ..
   ```

4. Start the backend server:
   ```
   ./start_backend.sh
   ```
   Or manually:
   ```
   cd backend
   python app.py
   ```

#### Frontend Setup

1. Navigate to the frontend directory:
   ```
   cd frontend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Start the development server:
   ```
   npm start
   ```
   Or use the script:
   ```
   ./start_frontend.sh
   ```

## Troubleshooting

If you encounter any issues, please refer to the [Troubleshooting Guide](TROUBLESHOOTING.md) for solutions to common problems.

You can also check if the backend is running correctly with:
```
./check_backend.sh
```

## Deployment

The application is designed to be cost-effective for deployment:
- The frontend can be deployed on static hosting services like Netlify or Vercel
- The backend can be deployed on a small instance on services like Heroku, Railway, or a small VM

## License

MIT 