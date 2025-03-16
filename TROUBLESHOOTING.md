# Troubleshooting Guide

This guide helps you solve common issues with the RCB Profile Picture Generator.

## Installation Issues

### PyTorch Installation Errors

If you see errors related to PyTorch installation like:

```
Getting requirements to build wheel ... error
error: subprocess-exited-with-error
```

Try these solutions:

1. **Use CPU-only PyTorch**: We've updated the requirements.txt to use CPU-only versions of PyTorch, which should be more compatible.

2. **Install PyTorch manually**:
   ```
   pip install torch==1.10.1+cpu torchvision==0.11.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
   ```

3. **Use a different Python version**: Try using Python 3.8 or 3.9 which are more compatible with the dependencies.

## Backend Issues

### Backend Not Starting

If the backend server doesn't start:

1. **Check for errors in the console output**

2. **Run the backend manually**:
   ```
   ./start_backend.sh
   ```

3. **Check if the model was downloaded correctly**:
   ```
   ls -la backend/saved_models/
   ```
   If the model file is missing or corrupted, delete it and run:
   ```
   cd backend && python download_model.py
   ```

4. **Check if the backend is responding**:
   ```
   ./check_backend.sh
   ```

### "before_first_request" Error

If you see an error about `@app.before_first_request`, it means you're using a newer Flask version that doesn't support this decorator. We've updated the code to use `@app.before_request` instead.

## Frontend Issues

### "Generate" Button Not Clickable

If the "Generate" button is not clickable:

1. **Check if the backend is running** using `./check_backend.sh`

2. **Check browser console for errors** (F12 in most browsers)

3. **Make sure you've uploaded an image and selected a background**

### Proxy Errors

If you see proxy errors like:

```
Proxy error: Could not proxy request /api/backgrounds from localhost:3000 to http://localhost:5000
```

It means the frontend is running but can't connect to the backend. Make sure:

1. The backend server is running on port 5000
2. There are no firewall issues blocking the connection
3. Try running the backend and frontend in separate terminal windows using the provided scripts

## Running the Application

For the most reliable operation:

1. Start the backend in one terminal:
   ```
   ./start_backend.sh
   ```

2. Start the frontend in another terminal:
   ```
   ./start_frontend.sh
   ```

This way, you can see any errors from either component more clearly. 