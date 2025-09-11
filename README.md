---
layout: default
title: "README"
description: "Development Scripts for HardFOC ESP-IDF Projects - Multi-application build system with intelligent configuration management for ESP-IDF development"
nav_order: 1
permalink: /
---

# 🔧 HardFOC ESP-IDF Project Tools

![Scripts](https://img.shields.io/badge/Scripts-Development%20Tools-blue?style=for-the-badge&logo=bash)
![ESP-IDF](https://img.shields.io/badge/ESP--IDF-Multi%20App%20Builds-green?style=for-the-badge&logo=espressif)
![Configuration](https://img.shields.io/badge/Config-YAML%20Based-purple?style=for-the-badge&logo=yaml)

**🎯 Development Scripts for Multi-Application ESP-IDF Projects**

*Scripts providing multi-application build management, intelligent configuration, and development workflow automation*

---

**🌐 [Live Documentation Site](https://n3b3x.github.io/hf-espidf-project-tools/)**  
*Published documentation with enhanced navigation and search*

---

## 📚 **Table of Contents**

- [🎯 **Overview**](#-overview)
- [🔄 **Usage Modes**](#-usage-modes)
- [📥 **Getting Started**](#-getting-started)
- [🚀 **Usage Examples**](#-usage-examples)
- [🔧 **Core Scripts**](#-core-scripts)
- [⚙️ **Setup Scripts**](#-setup-scripts)
- [🔄 **Utility Scripts**](#-utility-scripts)
- [📊 **Configuration Scripts**](#-configuration-scripts)
- [🔄 **CI/CD Workflows & Quality Assurance**](#cicd-workflows--quality-assurance)
- [🔍 **Troubleshooting**](#-troubleshooting)
- [🤝 **Contributing**](#-contributing)

---

## 🎯 **Overview**

This repository contains **development scripts** for ESP-IDF projects with multiple applications.
The scripts provide intelligent configuration management, multi-application build support,
and development workflow automation while maintaining complete portability.

### 🏆 **Key Features**

- **🚀 Multi-Application Builds** - Build multiple applications from a single ESP-IDF project
- **🔧 Intelligent Configuration** - YAML-based configuration management with `app_config.yml`
- **📊 Dynamic Configuration Loading** - Hierarchical overrides and smart defaults
- **🔄 Development Workflow** - Streamlined build, flash, and development processes
- **🛡️ Enhanced Validation System** - Smart combination validation and error prevention
- **🧠 Smart Defaults** - Automatic ESP-IDF version selection based on app and build type
- **📁 Structured Output** - Parseable build directories and artifact management
- **🔍 Comprehensive Logging** - Detailed build logs and error reporting
- **🆕 Environment Separation** - Clear separation between local development and CI environments
- **🌐 CI Integration** - Works with separate CI tools repository for automated builds

## 🔄 **Usage Modes**

The scripts support two flexible deployment modes:

### **Mode 1: Project-Integrated** 📁
**Best for**: Individual ESP-IDF projects
- Scripts are part of your project directory (`scripts/` or `hf-espidf-project-tools/`)
- Automatic configuration discovery
- Simple commands: `./scripts/build_app.sh app_name build_type`

### **Mode 2: Portable Tools** 🚀  
**Best for**: Shared tools, CI systems, multiple projects
- Scripts located anywhere (e.g., `/opt/esp32-tools/`)
- Use `--project-path` flag or `PROJECT_PATH` environment variable
- Commands: `./build_app.sh --project-path /path/to/project app_name build_type`

### **Configuration Discovery**
Both modes automatically find `app_config.yml`:
- **Project-Integrated**: Parent directory of scripts
- **Portable**: `--project-path` or `PROJECT_PATH` environment variable

## 📥 **Getting Started**

### **Method 1: Automated Project Setup (Recommended)** 🚀

Create a complete ESP-IDF project with all tools pre-configured:

```bash
## Clone the tools repository
git clone https://github.com/n3b3x/hf-espidf-project-tools.git
cd hf-espidf-project-tools

## Create a new ESP-IDF project
./setup_basic.sh my-awesome-project

## Navigate to your new project
cd my-awesome-project

## Build and flash
./scripts/build_app.sh main_app Release
./scripts/flash_app.sh flash main_app Release
```

**What you get:**
- ✅ Complete ESP-IDF project structure
- ✅ ESP-IDF installed and configured
- ✅ `app_config.yml` with basic app
- ✅ CMakeLists.txt files set up
- ✅ Basic `main.cpp` template
- ✅ All development scripts ready to use

### **Method 2: Add to Existing Project** 🔧

If you already have an ESP-IDF project:

```bash
## Navigate to your ESP-IDF project
cd ~/my-esp-idf-project

## Clone the repository as scripts directory
git clone https://github.com/n3b3x/hf-espidf-project-tools.git scripts

## Usage (from ESP-IDF project root)
./scripts/build_app.sh gpio_test Release
./scripts/flash_app.sh flash_monitor adc_test
```

### **Method 3: Git Submodule** 🔗

Keep the scripts as a separate repository while integrating them:

```bash
## Navigate to your ESP-IDF project
cd ~/my-esp-idf-project

## Add as submodule
git submodule add https://github.com/n3b3x/hf-espidf-project-tools.git scripts

## Initialize and update the submodule
git submodule update --init --recursive

## Usage (from ESP-IDF project root)
./scripts/build_app.sh gpio_test Release
```

---

## 🚀 **Usage Examples**

### **Project-Integrated Usage** 📁

When scripts are part of your ESP-IDF project:

```bash
## ESP-IDF project structure
my-esp-idf-project/
├── CMakeLists.txt
├── app_config.yml
├── main/
├── components/
└── scripts/                # Development scripts
    ├── build_app.sh
    ├── flash_app.sh
    └── config_loader.sh

## Usage (from ESP-IDF project root)
./scripts/build_app.sh gpio_test Release
./scripts/flash_app.sh flash_monitor adc_test
./scripts/manage_idf.sh list

## Python scripts
python3 scripts/get_app_info.py list
python3 scripts/generate_matrix.py
```

### **Portable Tools Usage** 🚀

When scripts are shared tools or in CI systems:

```bash
## Shared tools structure
/opt/esp-idf-tools/
├── build_app.sh
├── flash_app.sh
└── config_loader.sh

## Usage with --project-path flag
/opt/esp-idf-tools/build_app.sh --project-path ~/my-esp-idf-project gpio_test Release
/opt/esp-idf-tools/flash_app.sh --project-path ~/my-esp-idf-project flash_monitor adc_test

## Usage with environment variable
export PROJECT_PATH=~/my-esp-idf-project
/opt/esp-idf-tools/build_app.sh gpio_test Release
/opt/esp-idf-tools/flash_app.sh flash_monitor adc_test

## Python scripts
python3 /opt/esp-idf-tools/get_app_info.py list --project-path ~/my-esp-idf-project
python3 /opt/esp-idf-tools/generate_matrix.py --project-path ~/my-esp-idf-project
```

### **Real-World Scenarios**

```bash
## Scenario 1: Multiple ESP-IDF projects with shared tools
/opt/esp-idf-tools/build_app.sh --project-path ~/projects/robot-controller gpio_test Release
/opt/esp-idf-tools/build_app.sh --project-path ~/projects/sensor-node adc_test Debug

## Scenario 2: CI/CD with portable scripts
./ci-scripts/build_app.sh --project-path $GITHUB_WORKSPACE/esp-idf-project gpio_test Release

## Scenario 3: Development with project-integrated scripts
cd ~/my-esp-idf-project
./scripts/build_app.sh gpio_test Release
./scripts/flash_app.sh flash_monitor gpio_test

## Scenario 4: Mixed usage (some projects integrated, some portable)
cd ~/project-with-tools
./scripts/build_app.sh gpio_test Release

cd ~/project-without-tools
/opt/esp-idf-tools/build_app.sh --project-path . gpio_test Release
```

---

## 🔧 **Core Scripts**

### **`build_app.sh` - Main Build Script**

The primary build script that orchestrates the entire build process.

#### **Functionality**
- **ESP-IDF Management** - Auto-detection, installation, and environment setup
- **Configuration Loading** - Loads app configuration and build parameters
- **Enhanced Validation** - Validates build combinations before proceeding
- **Smart Defaults** - Automatic ESP-IDF version selection when not specified
- **Build Execution** - Runs ESP-IDF build with project-specific settings
- **Output Management** - Creates structured build directories and exports paths
- **Error Handling** - Comprehensive error checking and reporting

#### **Usage**

**Project-Integrated:**
```bash
./scripts/build_app.sh [OPTIONS] <app_name> <build_type> [idf_version]
```

**Portable Tools:**
```bash
./build_app.sh [OPTIONS] --project-path <path> <app_name> <build_type> [idf_version]
## OR
export PROJECT_PATH=<path>
./build_app.sh [OPTIONS] <app_name> <build_type> [idf_version]
```

**Options:**
- `-c, --clean` - Clean build (remove existing build directory)
- `-v, --verbose` - Verbose output
- `--project-path <path>` - Path to project directory (portable mode only)
- `-h, --help` - Show this help message

**Arguments:**
- `app_name` - Application name from app_config.yml
- `build_type` - Build type (Debug, Release)
- `idf_version` - ESP-IDF version (optional, uses default if not specified)

**Examples:**

**Project-Integrated:**
```bash
./scripts/build_app.sh gpio_test Release
./scripts/build_app.sh adc_test Debug release/v5.4
./scripts/build_app.sh --clean wifi_test Release
```

**Portable Tools:**
```bash
./build_app.sh --project-path ~/my-esp32-project gpio_test Release
./build_app.sh --project-path ~/my-esp32-project adc_test Debug release/v5.4
export PROJECT_PATH=~/my-esp32-project
./build_app.sh --clean wifi_test Release
```

**Enhanced Commands:**
```bash
## Show app information
./scripts/build_app.sh info <app_name>                    # Project-Integrated
./build_app.sh --project-path <path> info <app_name>      # Portable

## Show all valid combinations
./scripts/build_app.sh combinations                       # Project-Integrated
./build_app.sh --project-path <path> combinations         # Portable

## Validate combination
./scripts/build_app.sh validate <app> <type> [idf]        # Project-Integrated
./build_app.sh --project-path <path> validate <app> <type> [idf]  # Portable
```

### **`flash_app.sh` - Flashing and Monitoring**

Handles device flashing, monitoring, and related operations.

#### **Functionality**
- **Device Flashing** - Flash firmware to ESP32 devices
- **Serial Monitoring** - Monitor device output and logs
- **Port Detection** - Auto-detect and validate serial ports
- **Error Handling** - Comprehensive error checking and recovery

#### **Usage**

**Project-Integrated:**
```bash
./scripts/flash_app.sh <action> [app_name] [build_type]
```

**Portable Tools:**
```bash
./flash_app.sh --project-path <path> <action> [app_name] [build_type]
## OR
export PROJECT_PATH=<path>
./flash_app.sh <action> [app_name] [build_type]
```

**Actions:**
- `flash` - Flash firmware only
- `monitor` - Monitor serial output only
- `flash_monitor` - Flash and then monitor
- `flash_erase` - Erase flash and flash firmware

**Examples:**

**Project-Integrated:**
```bash
./scripts/flash_app.sh flash_monitor gpio_test Release
./scripts/flash_app.sh monitor
./scripts/flash_app.sh flash_erase adc_test Debug
```

**Portable Tools:**
```bash
./flash_app.sh --project-path ~/my-esp32-project flash_monitor gpio_test Release
./flash_app.sh --project-path ~/my-esp32-project monitor
export PROJECT_PATH=~/my-esp32-project
./flash_app.sh flash_erase adc_test Debug
```

---

## ⚙️ **Setup Scripts**

### **`setup_common.sh` - Shared Setup Functions**

Contains common functions used by all setup scripts.

#### **Key Functions**
```bash
## ESP-IDF Management
install_esp_idf()           # Install ESP-IDF version
setup_esp_idf_env()         # Setup ESP-IDF environment
get_esp_idf_path()          # Get ESP-IDF installation path

## Development Tools
install_dev_tools()          # Install development tools
install_clang_tools()        # Install Clang toolchain
verify_tools()               # Verify tool installation

## System Utilities
check_system_requirements()  # Check system compatibility
setup_environment()          # Setup common environment
```

### **`setup_repo.sh` - Local Development Setup**

Sets up the local development environment.

#### **Functionality**
- **Development Tools** - Install Clang, formatting tools, and analysis tools
- **ESP-IDF Setup** - Configure ESP-IDF environment for local development
- **Environment Variables** - Set development-specific environment variables
- **Tool Verification** - Verify all tools are properly installed
- **Complete Development Environment** - Full toolchain and user guidance

#### **Usage**
```bash
## Setup local development environment
source scripts/setup_repo.sh

## This will:
## 1. Install development tools (clang, clang-format, clang-tidy)
## 2. Setup ESP-IDF environment
## 3. Configure build tools
## 4. Export necessary environment variables
## 5. Provide complete development environment
```

#### **Installed Tools**
- **Clang Toolchain** - C/C++ compiler and tools
- **Clang-Format** - Code formatting tool
- **Clang-Tidy** - Static analysis tool
- **ESP-IDF Tools** - ESP32 development tools
- **Build Tools** - CMake, Ninja, and related tools

---

## 🔄 **Utility Scripts**

### **`config_loader.sh` - Configuration Utilities**

Provides functions for loading and parsing configuration files.

#### **Key Functions**
```bash
## Configuration Loading
load_config()                # Load app_config.yml
get_build_types()            # Get available build types
get_idf_versions()           # Get available IDF versions
get_target()                 # Get target MCU
get_idf_version()            # Get IDF version

## Build Directory Management
get_build_directory()        # Generate build directory name
parse_build_directory()      # Parse build directory components
get_build_component()        # Extract specific component
is_valid_build_directory()   # Validate directory format
list_build_directories()     # List all build directories

## Application Management
get_app_types()              # Get available application types
get_app_description()        # Get application description
is_valid_app_type()          # Validate application type
is_valid_build_type()        # Validate build type
get_project_name()           # Get project name

## Enhanced Validation Functions
is_valid_combination()       # Validate app + build type + IDF version combination
get_version_index()          # Get version index for nested array access
get_app_idf_versions()       # Get app-specific IDF versions
get_app_build_types()        # Get app-specific build types
show_valid_combinations()    # Show valid combinations for specific app
get_idf_version_smart()      # Smart IDF version selection with build type matching
```

---

## 📊 **Configuration Scripts**

### **`generate_matrix.py` - CI Matrix Generator**

Python script that generates CI/CD build matrices from centralized configuration.

#### **Functionality**
- **Configuration Loading** - Load and parse `app_config.yml` from multiple possible locations
- **Matrix Generation** - Generate GitHub Actions matrix configuration with hierarchical overrides
- **Configuration Validation** - Validate configuration structure and content before processing
- **Flexible Output** - Multiple output formats (JSON, YAML) and destinations (stdout, file)
- **App Filtering** - Filter matrix output for specific applications
- **Verbose Processing** - Detailed processing information and statistics

#### **Command Line Options**
```bash
--help, -h                  # Show comprehensive help message
--output <file>             # Output to file instead of stdout
--format <format>           # Output format: json, yaml (default: json)
--filter <app>              # Filter output for specific app only
--verbose                   # Show detailed processing information
--validate                  # Validate configuration before generating matrix
```

#### **Usage Examples**

**Project-Integrated:**
```bash
## Basic usage (output to stdout)
python3 scripts/generate_matrix.py

## YAML format output
python3 scripts/generate_matrix.py --format yaml

## Filter for specific app
python3 scripts/generate_matrix.py --filter gpio_test

## Validate configuration
python3 scripts/generate_matrix.py --validate
```

**Portable Tools:**
```bash
## Basic usage with project path
python3 generate_matrix.py --project-path ~/my-esp32-project

## YAML format output
python3 generate_matrix.py --project-path ~/my-esp32-project --format yaml

## Filter for specific app
python3 generate_matrix.py --project-path ~/my-esp32-project --filter gpio_test

## Validate configuration
python3 generate_matrix.py --project-path ~/my-esp32-project --validate
```

### **`app_config.yml` - Configuration File**

YAML configuration file that defines all build parameters.

#### **Structure**
```yaml
## Global metadata
metadata:
  idf_versions: ["release/v5.5", "release/v5.4", "release/v5.3"]
  build_types: [["Debug", "Release"], ["Debug", "Release"], ["Debug"]]
  target: "esp32c6"
build_directory_pattern: "build-app-{app_type}-type-{build_type}-target-{target}-idf-{idf_version}"

## Application configurations
apps:
  gpio_test:
    ci_enabled: true
    description: "GPIO peripheral comprehensive testing"
    idf_versions: ["release/v5.5"]  # Override global
    build_types: [["Debug", "Release"]]
    
  adc_test:
    ci_enabled: true
    description: "ADC peripheral testing"
    # Uses global configuration
    
  wifi_test:
    ci_enabled: false  # Exclude from CI
    description: "WiFi functionality testing"
    idf_versions: ["release/v5.4"]
    build_types: [["Release"]]

## CI configuration
ci_config:
  exclude_combinations:
    - app_name: "wifi_test"
      idf_version: "release/v5.3"
      build_type: "Release"
```

#### **Configuration Features**
- **Hierarchical Overrides** - Per-app configuration overrides global settings
- **CI Control** - Enable/disable applications in CI builds
- **Build Type Mapping** - Different build types per IDF version
- **Exclusion Rules** - Exclude specific combinations from CI
- **Flexible Patterns** - Customizable build directory naming

---

## 🔄 **CI/CD Workflows & Quality Assurance**

This repository includes comprehensive CI/CD workflows that ensure code quality, security,
and reliability. All workflows run automatically on every push and pull request.

### **🛠️ Available Workflows**

| Workflow | Purpose | Files Checked | Tools Used |
|----------|---------|---------------|------------|
| **Lint Check** | Code formatting & style | Python, Shell, YAML, Markdown | `black`, `isort`, `flake8`, `shellcheck`, `yamllint`, `markdownlint` |
| **Security Scan** | Vulnerability detection | Dependencies, secrets, code | `pip-audit`, `safety`, `bandit`, `gitleaks`, `CodeQL` |
| **Documentation** | Docs validation | README, docs/, script headers | Custom validation, link checking |
| **Static Analysis** | Code quality | Python files | `pylint`, `pydocstyle`, `radon`, `xenon` |
| **Link Check** | Link validation | All markdown files | `markdown-link-check` |

### **🔍 What Each Workflow Does**

#### **1. Lint Check** 🔍
- **Python Code**: Formats with `black`, sorts imports with `isort`, checks style with `flake8`
- **Shell Scripts**: Validates syntax and best practices with `shellcheck`
- **YAML Files**: Checks syntax and formatting with `yamllint`
- **Markdown**: Validates documentation formatting with `markdownlint`

#### **2. Security Scan** 🛡️
- **Dependency Scanning**: Checks `requirements.txt` for vulnerabilities using `pip-audit` and `safety`
- **Secret Detection**: Scans for accidentally committed API keys, passwords, and tokens using `gitleaks`
- **Code Analysis**: Runs `bandit` to find security issues in Python code
- **Static Analysis**: Uses GitHub's CodeQL to find security vulnerabilities

#### **3. Documentation Validation** 📚
- **Structure Check**: Verifies all required documentation files exist
- **Content Validation**: Ensures documentation is complete and properly formatted
- **Link Verification**: Checks internal documentation links work correctly
- **Generation**: Creates documentation index and summaries

#### **4. Static Analysis** 🔬
- **Code Quality**: Analyzes Python code complexity and maintainability
- **Best Practices**: Checks for common programming mistakes and anti-patterns
- **Documentation**: Validates docstrings and code comments
- **Complexity**: Measures cyclomatic complexity to identify overly complex code

#### **5. Link Check** 🔗
- **Internal Links**: Verifies all markdown links within the repository work
- **External Links**: Checks that external URLs are accessible
- **Cross-References**: Ensures documentation references are valid
- **GitHub Links**: Validates GitHub repository and issue links

### **⚡ Quick Local Testing**

Before pushing, you can run similar checks locally:

```bash
## Python formatting and linting
black --check --diff .
isort --check-only --diff .
flake8 . --max-line-length=100

## Shell script validation
find . -name "*.sh" -exec shellcheck {} \;

## Security checks
pip-audit --requirement requirements.txt
safety check --requirement requirements.txt

## Markdown link checking
markdown-link-check README.md
```

---

## 🔍 **Troubleshooting**

### **Common Issues**

#### **ESP-IDF Not Found**
```bash
## Error: ESP-IDF environment not found
## Solution: The build system will auto-install ESP-IDF

## Manual installation if needed:
cd ~/esp
git clone --recursive https://github.com/espressif/esp-idf.git esp-idf-release_v5_5
cd esp-idf-release_v5_5
./install.sh
source export.sh
```

#### **Permission Issues**
```bash
## Error: Permission denied
## Solution: Make scripts executable
chmod +x scripts/*.sh
chmod +x scripts/*.py
```

#### **Python Dependencies**
```bash
## Error: Module not found
## Solution: Install required packages
pip install pyyaml
pip install esptool
```

#### **Build Directory Issues**
```bash
## Error: Invalid build directory name
## Solution: Check app_config.yml build_directory_pattern

## Ensure pattern follows format:
build_directory_pattern: "build-app-{app_type}-type-{build_type}-target-{target}-idf-{idf_version}"
```

#### **Validation System Issues**
```bash
## Error: Invalid build combination
## Solution: Use validation commands to see what's allowed

## Check valid combinations for specific app:
./scripts/build_app.sh info gpio_test

## See all valid combinations:
./scripts/build_app.sh combinations

## Validate specific combination:
./scripts/build_app.sh validate gpio_test Release release/v5.4

## Common validation errors:
## • App doesn't support requested build type
## • App doesn't support requested IDF version
## • Combination constraint violation
```

#### **Smart Default Issues**
```bash
## Error: Smart default not working
## Solution: Check app_config.yml configuration

## Ensure app has idf_versions defined:
apps:
  gpio_test:
    idf_versions: ["release/v5.5"]
    build_types: ["Debug", "Release"]

## Or check global defaults:
metadata:
  idf_versions: ["release/v5.5", "release/v5.4"]
  build_types: [["Debug", "Release"], ["Debug"]]
```

### **Debug Mode**

Enable verbose output for debugging:

```bash
## Verbose build
./scripts/build_app.sh --verbose gpio_test Release

## Clean rebuild
CLEAN=1 ./scripts/build_app.sh gpio_test Release

## Check environment
source scripts/setup_repo.sh
echo $IDF_PATH
echo $IDF_TARGET
```

### **Log Files**

Build logs are available in:

```bash
## Build log
cat build-*/log/build.log

## CMake log
cat build-*/CMakeFiles/CMakeOutput.log

## Ninja log
cat build-*/.ninja_log
```

---

## 🤝 **Contributing**

### **Adding New Scripts**

1. **Create Script File**
   ```bash
   # Create new script
   touch scripts/new_script.sh
   chmod +x scripts/new_script.sh
   ```

2. **Add Documentation**
   - Update this README
   - Add usage examples
   - Document dependencies

3. **Test Integration**
   - Test with existing scripts
   - Verify CI compatibility
   - Check error handling

### **Modifying Existing Scripts**

1. **Backup Original**
   ```bash
   cp scripts/script_name.sh scripts/script_name.sh.backup
   ```

2. **Make Changes**
   - Implement new functionality
   - Maintain backward compatibility
   - Update error handling

3. **Test Changes**
   - Test locally
   - Verify CI compatibility
   - Check all use cases

### **Script Standards**

- **Error Handling** - Comprehensive error checking and reporting
- **Logging** - Detailed logs for debugging
- **Documentation** - Clear usage instructions and examples
- **Testing** - Test all functionality and edge cases
- **CI Compatibility** - Ensure scripts work in CI environment
- **Environment Separation** - Maintain clear separation between local and CI concerns

---

## 📄 **License**

This project is licensed under the GPL-3.0 License - see the [LICENSE](./LICENSE) file for
details.

---

## 🔗 **Related Documentation**

- [CI/CD Workflows](https://github.com/N3b3x/hf-general-ci-tools) - GitHub Actions workflows
- [ESP-IDF Documentation](https://docs.espressif.com/projects/esp-idf/) - ESP-IDF reference

---

**🚀 Built for ESP32 Development**

*Build system with automated CI/CD integration*