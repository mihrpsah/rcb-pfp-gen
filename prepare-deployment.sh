#!/bin/bash

echo "RCB Profile Picture Generator - Deployment Preparation"
echo "===================================================="
echo

# Run deployment check
echo "Step 1: Running deployment check..."
./deployment-check.sh

# Check if there are any issues
read -p "Did the deployment check show any issues? (y/n): " has_issues
if [ "$has_issues" = "y" ]; then
    echo "Please fix the issues before continuing."
    exit 1
fi

echo
echo "Step 2: Preparing the backend..."
cd backend
./deploy.sh
cd ..

echo
echo "Step 3: Building the frontend..."
cd frontend
./build.sh
cd ..

echo
echo "Step 4: Checking environment variables..."
if grep -q "your-backend-url.com" frontend/.env.production; then
    echo "⚠️  Warning: The backend URL in frontend/.env.production is still set to the default value."
    echo "    Please update it with your actual backend URL before deploying."
fi

echo
echo "Step 5: Deployment options..."
echo "You can now deploy the application using one of the following methods:"
echo
echo "1. Separate deployment (recommended):"
echo "   - Frontend: Deploy the 'frontend/build' directory to a static hosting service"
echo "   - Backend: Deploy the 'backend' directory to a Python-compatible cloud platform"
echo
echo "2. Docker deployment:"
echo "   - Run './docker-deploy.sh' to deploy both frontend and backend using Docker"
echo
echo "For detailed instructions, please refer to DEPLOYMENT.md"

echo
echo "Deployment preparation complete!"
echo "Use the DEPLOYMENT_CHECKLIST.md to ensure all steps are completed before going live." 