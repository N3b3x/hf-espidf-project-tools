---
layout: default
title: "Getting Started"
description: "Quick start guide for the HardFOC ESP32 CI Tools"
nav_order: 2
permalink: /getting-started/
---

# Getting Started with HardFOC ESP32 CI Tools

Welcome to the HardFOC ESP32 CI Tools! This guide will help you get up and running quickly with our comprehensive CI/CD solution for ESP32 development.

## 🚀 Quick Start

### 1. Prerequisites

Before you begin, ensure you have:

- **Git** installed on your system
- **GitHub account** with repository access
- **ESP32 project** ready for CI/CD integration
- **Basic understanding** of GitHub Actions

### 2. Installation

#### Option A: Copy Workflow Files (Recommended)

1. **Clone or download** the HardFOC ESP32 CI Tools repository
2. **Copy workflow files** from `.github/workflows/` to your project's `.github/workflows/` directory
3. **Copy configuration files** as needed for your project

#### Option B: Use as Submodule

```bash
# Add as submodule
git submodule add https://github.com/n3b3x/hf-espidf-project-tools.git scripts

# Copy workflows
cp scripts/.github/workflows/* .github/workflows/
```

### 3. Configuration

#### Basic Configuration

1. **Update project paths** in workflow files to match your project structure
2. **Configure ESP-IDF versions** you want to test against
3. **Set up build configurations** for your applications

#### Advanced Configuration

- **[Configuration System](configuration/)** - Centralized YAML configuration
- **[Build System](build-system/)** - ESP-IDF build management
- **[CI Pipeline](ci-pipeline/)** - Workflow optimization

### 4. First Run

1. **Commit and push** your changes to GitHub
2. **Navigate to Actions** tab in your GitHub repository
3. **Monitor the workflow** execution in real-time
4. **Review results** and artifacts

## 📚 Next Steps

Once you have the basic setup working:

- **[Build System](build-system/)** - Learn about intelligent build management
- **[CI Pipeline](ci-pipeline/)** - Optimize your workflows
- **[Configuration](configuration/)** - Master centralized configuration
- **[Advanced Topics](advanced/)** - Explore advanced features

## 🆘 Need Help?

- **[Troubleshooting](troubleshooting/)** - Common issues and solutions
- **[Examples](examples/)** - Real-world usage examples
- **[GitHub Issues](https://github.com/n3b3x/hf-espidf-project-tools/issues)** - Report bugs or request features

## 🎯 What's Next?

- **Customize workflows** for your specific needs
- **Add security scanning** to your pipeline
- **Set up automated documentation** updates
- **Configure multi-version testing** across ESP-IDF versions

---

**Ready to dive deeper?** Check out our [Build System Documentation](build-system/) or explore [Advanced Topics](advanced/) for power users.
