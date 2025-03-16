#!/bin/bash

echo "RCB Profile Picture Generator - Deployment Check"
echo "==============================================="
echo

# Check frontend files
echo "Checking frontend files..."
if [ -d "frontend" ]; then
    echo "✅ Frontend directory exists"
    
    # Check package.json
    if [ -f "frontend/package.json" ]; then
        echo "✅ package.json exists"
    else
        echo "❌ package.json is missing"
    fi
    
    # Check build script
    if [ -f "frontend/build.sh" ]; then
        echo "✅ build.sh exists"
        if [ -x "frontend/build.sh" ]; then
            echo "✅ build.sh is executable"
        else
            echo "❌ build.sh is not executable. Run: chmod +x frontend/build.sh"
        fi
    else
        echo "❌ build.sh is missing"
    fi
    
    # Check Dockerfile
    if [ -f "frontend/Dockerfile" ]; then
        echo "✅ Dockerfile exists"
    else
        echo "❌ Dockerfile is missing"
    fi
    
    # Check nginx.conf
    if [ -f "frontend/nginx.conf" ]; then
        echo "✅ nginx.conf exists"
    else
        echo "❌ nginx.conf is missing"
    fi
else
    echo "❌ Frontend directory is missing"
fi

echo

# Check backend files
echo "Checking backend files..."
if [ -d "backend" ]; then
    echo "✅ Backend directory exists"
    
    # Check app.py
    if [ -f "backend/app.py" ]; then
        echo "✅ app.py exists"
    else
        echo "❌ app.py is missing"
    fi
    
    # Check requirements.txt
    if [ -f "backend/requirements.txt" ]; then
        echo "✅ requirements.txt exists"
    else
        echo "❌ requirements.txt is missing"
    fi
    
    # Check download_model.py
    if [ -f "backend/download_model.py" ]; then
        echo "✅ download_model.py exists"
    else
        echo "❌ download_model.py is missing"
    fi
    
    # Check deploy.sh
    if [ -f "backend/deploy.sh" ]; then
        echo "✅ deploy.sh exists"
        if [ -x "backend/deploy.sh" ]; then
            echo "✅ deploy.sh is executable"
        else
            echo "❌ deploy.sh is not executable. Run: chmod +x backend/deploy.sh"
        fi
    else
        echo "❌ deploy.sh is missing"
    fi
    
    # Check Procfile
    if [ -f "backend/Procfile" ]; then
        echo "✅ Procfile exists"
    else
        echo "❌ Procfile is missing"
    fi
    
    # Check runtime.txt
    if [ -f "backend/runtime.txt" ]; then
        echo "✅ runtime.txt exists"
    else
        echo "❌ runtime.txt is missing"
    fi
    
    # Check Dockerfile
    if [ -f "backend/Dockerfile" ]; then
        echo "✅ Dockerfile exists"
    else
        echo "❌ Dockerfile is missing"
    fi
    
    # Check .env
    if [ -f "backend/.env" ]; then
        echo "✅ .env exists"
    else
        echo "❌ .env is missing"
    fi
else
    echo "❌ Backend directory is missing"
fi

echo

# Check Docker files
echo "Checking Docker files..."
if [ -f "docker-compose.yml" ]; then
    echo "✅ docker-compose.yml exists"
else
    echo "❌ docker-compose.yml is missing"
fi

if [ -f "docker-deploy.sh" ]; then
    echo "✅ docker-deploy.sh exists"
    if [ -x "docker-deploy.sh" ]; then
        echo "✅ docker-deploy.sh is executable"
    else
        echo "❌ docker-deploy.sh is not executable. Run: chmod +x docker-deploy.sh"
    fi
else
    echo "❌ docker-deploy.sh is missing"
fi

echo

# Check background images
echo "Checking background images..."
if [ -d "bg" ]; then
    echo "✅ bg directory exists"
    bg_count=$(ls -1 bg/*.{jpg,jpeg,png} 2>/dev/null | wc -l)
    if [ "$bg_count" -gt 0 ]; then
        echo "✅ Found $bg_count background images"
    else
        echo "❌ No background images found in bg directory"
    fi
else
    echo "❌ bg directory is missing"
fi

echo

# Check documentation
echo "Checking documentation..."
if [ -f "README.md" ]; then
    echo "✅ README.md exists"
else
    echo "❌ README.md is missing"
fi

if [ -f "DEPLOYMENT.md" ]; then
    echo "✅ DEPLOYMENT.md exists"
else
    echo "❌ DEPLOYMENT.md is missing"
fi

echo
echo "Deployment check complete!"
echo "Fix any issues marked with ❌ before deploying." 