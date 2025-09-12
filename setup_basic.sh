#!/bin/bash
# ESP-IDF Project Basic Setup Script
# This script automates the creation of a new ESP-IDF project with the tools repository
# Usage: ./setup_basic.sh [project_name] [espidf_version]

set -e  # Exit on any error

# Default values
DEFAULT_ESPIDF_VERSION="release/v5.5"
DEFAULT_PROJECT_NAME="my-esp-idf-project"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    echo "ESP-IDF Project Basic Setup Script"
    echo ""
    echo "Usage: ./setup_basic.sh [project_name] [espidf_version]"
    echo ""
    echo "ARGUMENTS:"
    echo "  project_name    - Name for the new ESP-IDF project (default: $DEFAULT_PROJECT_NAME)"
    echo "                   - Use '../' to setup in existing ESP32 directory (parent directory)"
    echo "  espidf_version  - ESP-IDF version to install (default: $DEFAULT_ESPIDF_VERSION)"
    echo ""
    echo "EXAMPLES:"
    echo "  ./setup_basic.sh                                   # Use defaults"
    echo "  ./setup_basic.sh my-project                        # Custom project name"
    echo "  ./setup_basic.sh my-project release/v5.4           # Custom name and ESP-IDF version"
    echo "  ./setup_basic.sh my-project v5.5                   # Custom name and ESP-IDF version"
    echo "  ./setup_basic.sh ../                               # Setup in existing ESP32 directory"
    echo "  ./setup_basic.sh ../ release/v5.4                  # Setup in existing directory with specific version"
    echo ""
    echo "WHAT THIS SCRIPT DOES:"
    echo "  1. Creates a new ESP-IDF project directory (or uses existing with '../')"
    echo "  2. Initializes git repository (or uses existing)"
    echo "  3. Adds hf-espidf-project-tools as submodule (or updates existing)"
    echo "  4. Installs specified ESP-IDF version"
    echo "  5. Creates basic project structure (main/, CMakeLists.txt, etc.)"
    echo "  6. Generates app_config.yml with basic main.cpp app"
    echo "  7. Creates basic main.cpp template"
    echo "  8. Sets up CMakeLists.txt files"
    echo "  9. Skips existing files to avoid overwriting user content"
    echo ""
    echo "REQUIREMENTS:"
    echo "  • Git installed and configured"
    echo "  • Internet connection for downloads"
    echo "  • Write permissions in current directory"
    echo ""
    echo "SUPPORTED ESP-IDF VERSIONS:"
    echo "  • release/v5.5 (default, recommended)"
    echo "  • release/v5.4"
    echo "  • release/v5.3"
    echo "  • v5.5, v5.4, v5.3 (short form)"
    echo ""
    echo "For detailed information, see: docs/getting-started/installation/"
}

# Show help if requested (check this first)
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

# Parse arguments
PROJECT_NAME="${1:-$DEFAULT_PROJECT_NAME}"
ESPIDF_VERSION="${2:-$DEFAULT_ESPIDF_VERSION}"

# Normalize ESP-IDF version (convert short form to full form)
if [[ "$ESPIDF_VERSION" =~ ^v[0-9]+\.[0-9]+$ ]]; then
    ESPIDF_VERSION="release/$ESPIDF_VERSION"
fi

print_status "Starting ESP-IDF project setup..."
print_status "Project name: $PROJECT_NAME"
print_status "ESP-IDF version: $ESPIDF_VERSION"

# Handle special case where user wants to setup in existing directory (../)
if [ "$PROJECT_NAME" = "../" ] || [ "$PROJECT_NAME" = ".." ]; then
    print_status "Setting up in existing ESP32 directory (parent directory)"
    PROJECT_NAME=".."
    TARGET_DIR="$(cd .. && pwd)"
    print_status "Target directory: $TARGET_DIR"
    
    # Check if we're already in an ESP32 project directory
    if [ -f "CMakeLists.txt" ] || [ -d "main" ] || [ -f "app_config.yml" ]; then
        print_warning "Current directory appears to already be an ESP32 project"
        print_status "Continuing with setup in current directory..."
        TARGET_DIR="$(pwd)"
    else
        print_status "Moving to parent directory for setup..."
        cd ..
        TARGET_DIR="$(pwd)"
    fi
else
    # Check if project directory already exists
    if [ -d "$PROJECT_NAME" ]; then
        print_error "Project directory '$PROJECT_NAME' already exists!"
        print_status "Please choose a different name or remove the existing directory."
        print_status "Alternatively, use '../' to setup in an existing ESP32 directory."
        exit 1
    fi

    # Create project directory
    print_status "Creating project directory: $PROJECT_NAME"
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    TARGET_DIR="$(pwd)"
fi

# Initialize git repository (only if not already initialized)
if [ ! -d ".git" ]; then
    print_status "Initializing git repository..."
    git init
else
    print_status "Git repository already exists, skipping initialization..."
fi

# Add hf-espidf-project-tools as submodule (only if not already added)
if [ ! -d "scripts" ] || [ ! -f "scripts/.git" ]; then
    print_status "Adding hf-espidf-project-tools as submodule..."
    git submodule add https://github.com/n3b3x/hf-espidf-project-tools.git scripts
else
    print_status "hf-espidf-project-tools submodule already exists, skipping..."
    print_status "Updating submodule to latest version..."
    git submodule update --init --recursive scripts
fi

# Install ESP-IDF version
print_status "Installing ESP-IDF version: $ESPIDF_VERSION"

# Set setup mode for colored output
export SETUP_MODE="local"

# Source the common setup functions from the scripts directory
source ./scripts/setup_common.sh

# Install specific ESP-IDF version
if ! install_esp_idf_version "$ESPIDF_VERSION"; then
    print_error "Failed to install ESP-IDF version: $ESPIDF_VERSION"
    print_status "Available versions:"
    list_esp_idf_versions
    exit 1
fi

# Create main directory
print_status "Creating main directory structure..."
mkdir -p main

# Create basic main.cpp (only if it doesn't exist)
if [ ! -f "main/main.cpp" ]; then
    print_status "Creating basic main.cpp template..."
    cat > main/main.cpp << 'EOF'
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"

static const char *TAG = "main";

extern "C" void app_main(void)
{
    ESP_LOGI(TAG, "Hello from ESP-IDF!");
    ESP_LOGI(TAG, "This is a basic ESP-IDF project template");
    ESP_LOGI(TAG, "You can now build and flash this project using:");
    ESP_LOGI(TAG, "  ./scripts/build_app.sh main_app Release");
    ESP_LOGI(TAG, "  ./scripts/flash_app.sh flash main_app Release");
    
    // Your application code goes here
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(1000));
        ESP_LOGI(TAG, "Running...");
    }
}
EOF
else
    print_status "main.cpp already exists, skipping creation..."
fi

# Create project root CMakeLists.txt (only if it doesn't exist)
if [ ! -f "CMakeLists.txt" ]; then
    print_status "Creating project CMakeLists.txt..."
    cat > CMakeLists.txt << 'EOF'
# =============================================================================
# ESP-IDF Project - Project Root CMakeLists.txt
# =============================================================================
# This CMakeLists.txt serves as the main project configuration.
# It defines shared variables, validates build parameters,
# and integrates with the ESP-IDF build system.
#
# Key Features:
# - Shared variable system for consistent defaults across components
# - Build parameter validation with helpful error messages
# - Integration with build_app.sh script for app type management
# - ESP-IDF project configuration and naming
# =============================================================================

cmake_minimum_required(VERSION 3.16)

# =============================================================================
# Shared Default Variables
# =============================================================================
# Define default values for requirements phase (used by components)
set(DEFAULT_APP_TYPE "main_app" CACHE STRING "Default app type for requirements phase")
set(DEFAULT_BUILD_TYPE "Release" CACHE STRING "Default build type for requirements phase")
set(DEFAULT_SOURCE_FILE "main.cpp" CACHE STRING "Default source file for requirements phase")

# =============================================================================
# Build Parameter Validation
# =============================================================================
# Validate that required variables are provided by build_app.sh
if(NOT DEFINED APP_TYPE)
    message(FATAL_ERROR 
        "APP_TYPE not defined. Please use build_app.sh to build this project.\n"
        "Example: ./scripts/build_app.sh ${DEFAULT_APP_TYPE} ${DEFAULT_BUILD_TYPE}\n"
        "Use './scripts/build_app.sh list' to see available app types."
    )
endif()

if(NOT DEFINED BUILD_TYPE)
    message(FATAL_ERROR 
        "BUILD_TYPE not defined. Please use build_app.sh to build this project.\n"
        "Example: ./scripts/build_app.sh ${DEFAULT_APP_TYPE} ${DEFAULT_BUILD_TYPE}\n"
        "Use './scripts/build_app.sh list' to see available app types."
    )
endif()

# =============================================================================
# Build Configuration and Status Messages
# =============================================================================
message(STATUS "Building app type: ${APP_TYPE}")
message(STATUS "Build type: ${BUILD_TYPE}")

# =============================================================================
# Global Variable Configuration
# =============================================================================
# Set these as global variables for all components to access
set(APP_TYPE "${APP_TYPE}" CACHE STRING "App type to build" FORCE)
set(BUILD_TYPE "${BUILD_TYPE}" CACHE STRING "Build type (Debug/Release)" FORCE)

# =============================================================================
# ESP-IDF Integration
# =============================================================================
# Include ESP-IDF build system
include($ENV{IDF_PATH}/tools/cmake/project.cmake)

# =============================================================================
# Project Configuration
# =============================================================================
# Set project name based on app type for unique identification
project(esp32_${APP_TYPE}_app)
EOF
else
    print_status "CMakeLists.txt already exists, skipping creation..."
fi

# Create main component CMakeLists.txt (only if it doesn't exist)
if [ ! -f "main/CMakeLists.txt" ]; then
    print_status "Creating main component CMakeLists.txt..."
    cat > main/CMakeLists.txt << 'EOF'
# =============================================================================
# ESP-IDF Project - Main Component CMakeLists.txt
# =============================================================================
# This CMakeLists.txt is designed to work with the build_app.sh script
# which handles app type validation and source file discovery.
# 
# The component supports ESP-IDF's two-phase build process:
# 1. Requirements phase: Uses defaults to allow component discovery
# 2. Build phase: Enforces proper usage with helpful error messages
# =============================================================================

# =============================================================================
# Variable Validation and Defaults
# =============================================================================
# Set defaults for requirements phase, validate during build phase
if(NOT DEFINED APP_TYPE)
    # During requirements phase, use a default to allow component discovery
    if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
        # This is the requirements phase - use default
        set(APP_TYPE "${DEFAULT_APP_TYPE}")
        message(STATUS "APP_TYPE not defined during requirements phase, using default: ${APP_TYPE}")
    else()
        # This is the actual build phase - fail with helpful error
        message(FATAL_ERROR 
            "APP_TYPE not defined. Please use build_app.sh to build this project.\n"
            "Example: ./scripts/build_app.sh ${DEFAULT_APP_TYPE} Release\n"
            "Use './scripts/build_app.sh list' to see available app types."
        )
    endif()
endif()

if(NOT DEFINED APP_SOURCE_FILE)
    # During requirements phase, use a default to allow component discovery
    if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
        # This is the requirements phase - use default
        set(APP_SOURCE_FILE "${DEFAULT_SOURCE_FILE}")
        message(STATUS "APP_SOURCE_FILE not defined during requirements phase, using default: ${APP_SOURCE_FILE}")
    else()
        # This is the actual build phase - fail with helpful error
        message(FATAL_ERROR 
            "APP_SOURCE_FILE not defined. Please use build_app.sh to build this project.\n"
            "Example: ./scripts/build_app.sh ${DEFAULT_APP_TYPE} ${DEFAULT_BUILD_TYPE}\n"
            "Use './scripts/build_app.sh list' to see available app types."
        )
    endif()
endif()

# =============================================================================
# Build Configuration and Status Messages
# =============================================================================
message(STATUS "Building app type: ${APP_TYPE}")
message(STATUS "Using source file: ${APP_SOURCE_FILE}")

# =============================================================================
# Component Dependencies
# =============================================================================
# Define required ESP-IDF components for the main application
set(MAIN_REQUIRES
    driver              # ESP-IDF driver framework (GPIO, I2C, SPI, UART)
    esp_timer           # ESP-IDF timer functionality
    freertos            # FreeRTOS for threading and synchronization
    log                 # ESP-IDF logging system
)

# =============================================================================
# Component Registration
# =============================================================================
# Register the main component with ESP-IDF build system
idf_component_register(
    SRCS "${APP_SOURCE_FILE}"              # Source file (determined by build_app.sh)
    REQUIRES ${MAIN_REQUIRES}              # Component dependencies defined above
)

# =============================================================================
# Compiler Configuration
# =============================================================================
# Set C++ standard to C++20 (required for std::span and modern C++ features)
target_compile_features(${COMPONENT_LIB} PRIVATE cxx_std_20)

# =============================================================================
# Build Type Specific Compiler Flags
# =============================================================================
# Set compiler flags based on build type (Debug vs Release)
if(BUILD_TYPE STREQUAL "Debug")
    target_compile_options(${COMPONENT_LIB} PRIVATE
        -Wall
        -Wextra
        -Wpedantic
        -O0
        -g3
        -DDEBUG
    )
else()
    target_compile_options(${COMPONENT_LIB} PRIVATE
        -Wall
        -Wextra
        -Wpedantic
        -O2
        -g
        -DNDEBUG
    )
endif()

# =============================================================================
# Example Type Compile Definitions
# =============================================================================
# Add compile definitions for each example type to enable conditional compilation
target_compile_definitions(${COMPONENT_LIB} PRIVATE
    "APP_TYPE_${APP_TYPE}=1"               # Enable specific app type features
)
EOF
else
    print_status "main/CMakeLists.txt already exists, skipping creation..."
fi

# Create app_config.yml (only if it doesn't exist)
if [ ! -f "app_config.yml" ]; then
    print_status "Creating app_config.yml..."
    cat > app_config.yml << EOF
---
# ESP-IDF Project - Apps Configuration
# This file centralizes all app definitions, their source files, and metadata
# Used by build scripts, flash scripts, CI workflows, and CMake
# 
# HIERARCHICAL CONFIGURATION:
# - Global settings in 'metadata' section apply to all apps by default
# - Individual apps can override 'idf_versions' and 'build_types' if needed
# - Apps without overrides use global settings automatically

version: "1.0"
metadata:
  project: "$PROJECT_NAME"
  default_app: "main_app"
  target: "esp32c6"
  idf_versions: ["$ESPIDF_VERSION"]
  build_types: [["Debug", "Release"]]

apps:
  main_app:
    description: "Basic main application template"
    source_file: "main.cpp"
    category: "basic"
    idf_versions: ["$ESPIDF_VERSION"]
    build_types: ["Debug", "Release"]
    ci_enabled: true
    featured: true

build_config:
  build_types:
    Debug:
      description: "Debug symbols, verbose logging, assertions enabled"
      cmake_build_type: "Debug"
      optimization: "-O0"
      debug_level: "-g3"
      defines: ["DEBUG"]
    Release:
      description: "Release build optimized for performance and size"
      cmake_build_type: "Release"
      optimization: "-O2"
      debug_level: "-g0"
      defines: ["NDEBUG"]
  
  build_directory_pattern: "build-app-{app_type}-type-{build_type}-target-{target}-idf-{idf_version}"
  project_name_pattern: "esp32_{app_type}_app"

ci_config:
  timeout_minutes: 30
  fail_fast: false
  exclude_combinations: []
  special_apps: []
---
EOF
else
    print_status "app_config.yml already exists, skipping creation..."
fi

# Create .gitignore (only if it doesn't exist)
if [ ! -f ".gitignore" ]; then
    print_status "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Build directories
build*/
build-*/

# ESP-IDF generated files
sdkconfig
sdkconfig.old

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log

# Python
__pycache__/
*.pyc
*.pyo

# Temporary files
*.tmp
*.temp
EOF
else
    print_status ".gitignore already exists, skipping creation..."
fi

# Create README.md for the project (only if it doesn't exist)
if [ ! -f "README.md" ]; then
    print_status "Creating project README.md..."
    cat > README.md << EOF
# $PROJECT_NAME

A basic ESP-IDF project created with hf-espidf-project-tools.

## Quick Start

1. **Build the project:**
   \`\`\`bash
   ./scripts/build_app.sh main_app Release
   \`\`\`

2. **Flash to ESP32:**
   \`\`\`bash
   ./scripts/flash_app.sh flash main_app Release
   \`\`\`

3. **Monitor output:**
   \`\`\`bash
   ./scripts/flash_app.sh monitor
   \`\`\`

## Available Commands

- **List all apps:** \`./scripts/build_app.sh list\`
- **Build specific app:** \`./scripts/build_app.sh <app_type> <build_type>\`
- **Flash app:** \`./scripts/flash_app.sh flash <app_type> <build_type>\`
- **Monitor:** \`./scripts/flash_app.sh monitor\`

## Project Structure

\`\`\`
$PROJECT_NAME/
├── main/
│   ├── main.cpp              # Main application source
│   └── CMakeLists.txt        # Main component build configuration
├── scripts/                  # Development tools (submodule)
├── app_config.yml           # App configuration
├── CMakeLists.txt           # Project root build configuration
└── README.md                # This file
\`\`\`

## ESP-IDF Version

This project uses ESP-IDF version: **$ESPIDF_VERSION**

## Documentation

For detailed documentation, see: [hf-espidf-project-tools](https://github.com/n3b3x/hf-espidf-project-tools)
EOF
else
    print_status "README.md already exists, skipping creation..."
fi

# Make scripts executable (if scripts directory exists)
if [ -d "scripts" ]; then
    print_status "Making scripts executable..."
    chmod +x scripts/*.sh
else
    print_warning "Scripts directory not found, skipping script permissions..."
fi

# Initial commit (only if there are changes to commit)
print_status "Checking for changes to commit..."
if git diff --quiet && git diff --cached --quiet; then
    print_status "No changes to commit (all files already exist and are up to date)"
else
    print_status "Creating git commit with new/changed files..."
    git add .
    git commit -m "ESP-IDF project setup with hf-espidf-project-tools

- Added hf-espidf-project-tools as submodule
- Created basic main.cpp template
- Set up CMakeLists.txt files
- Generated app_config.yml with main_app
- ESP-IDF version: $ESPIDF_VERSION"
fi

print_success "Project setup completed successfully!"
echo ""
print_status "Next steps:"
if [ "$PROJECT_NAME" = ".." ]; then
    print_status "1. You are already in the project directory"
    print_status "2. ./scripts/build_app.sh main_app Release"
    print_status "3. ./scripts/flash_app.sh flash main_app Release"
else
    print_status "1. cd $PROJECT_NAME"
    print_status "2. ./scripts/build_app.sh main_app Release"
    print_status "3. ./scripts/flash_app.sh flash main_app Release"
fi
echo ""
print_status "Project directory: $(pwd)"
print_status "ESP-IDF version: $ESPIDF_VERSION"
print_status "Default app: main_app"
echo ""
print_success "Happy coding! 🚀"
