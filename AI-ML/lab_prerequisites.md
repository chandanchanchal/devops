# Lab Prerequisites for AI-ML Practicals

## Hardware Requirements

### Basic Setup (Minimum Requirements)
- **CPU**: Intel Core i5/i7 or AMD Ryzen 5/7 (8th gen or newer)
- **RAM**: 16GB minimum
- **Storage**: 256GB SSD
- **Display**: Standard display with 1080p resolution
- **Internet**: Stable broadband connection

### Recommended Setup (For Deep Learning & Computer Vision)
- **CPU**: Intel Core i7/i9 or AMD Ryzen 7/9 (10th gen or newer)
- **RAM**: 32GB or more
- **GPU**: NVIDIA GeForce RTX 3060 or better with at least 8GB VRAM
- **Storage**: 512GB SSD or larger
- **Display**: High-resolution display (1440p or higher)
- **Internet**: High-speed broadband connection

### Advanced Setup (For Large Models & Generative AI)
- **CPU**: Intel Core i9 or AMD Ryzen 9/Threadripper
- **RAM**: 64GB or more
- **GPU**: NVIDIA GeForce RTX 3080/3090 or NVIDIA RTX A4000/A5000 or better
- **Storage**: 1TB SSD or larger
- **Display**: Dual monitor setup recommended
- **Internet**: High-speed broadband connection

## Software Requirements

### Common Software (For All Practicals)
- **Operating System**: Windows 10/11, macOS, or Linux (Ubuntu 20.04 or newer recommended)
- **Python**: Python 3.8 or newer
- **IDE/Code Editor**: 
  - Jupyter Notebook/JupyterLab
  - Visual Studio Code with Python extensions
  - PyCharm Community/Professional
- **Version Control**: Git
- **Package Management**: pip, conda (Anaconda or Miniconda)

### Time Series Analysis
- **Core Libraries**:
  - NumPy, pandas
  - matplotlib, seaborn, plotly for visualization
  - statsmodels for statistical models
  - scikit-learn for machine learning models
- **Specialized Libraries**:
  - prophet for Facebook Prophet models
  - pmdarima for auto ARIMA
  - tslearn for time series specific algorithms
  - xgboost, lightgbm for gradient boosting models
  - tensorflow or pytorch for deep learning time series models

### Deep Learning & Computer Vision
- **Core Frameworks**:
  - PyTorch (latest stable version)
  - TensorFlow/Keras (optional alternative)
- **GPU Support**:
  - CUDA Toolkit (compatible with installed PyTorch/TensorFlow)
  - cuDNN library
- **Computer Vision Libraries**:
  - OpenCV
  - Pillow/PIL
  - torchvision
  - albumentations for augmentations
- **Model Libraries**:
  - timm (PyTorch Image Models)
  - transformers (Hugging Face)
  - detectron2 (for object detection)
  - segmentation-models-pytorch
- **Visualization**:
  - TensorBoard
  - Weights & Biases (optional, for experiment tracking)

### Generative AI
- **Additional Libraries**:
  - diffusers (for diffusion models)
  - accelerate (for optimization)
  - bitsandbytes (for quantization)
  - xformers (for efficient attention)

## Lab Environment Options

### Local Setup
- Individual workstations with the hardware specifications mentioned above
- Local installation of all required software
- Advantages: No internet dependency for computation, full control over environment
- Disadvantages: Higher upfront cost, maintenance requirements

### Cloud-Based Options
- **Google Colab**: 
  - Free tier with limited GPU access
  - Colab Pro/Pro+ for more resources
  - Good for introductory practicals
- **Kaggle Kernels**:
  - Free GPU/TPU access with limitations
  - Integrated datasets
- **AWS SageMaker/EC2**:
  - Pay-as-you-go model
  - Various instance types available
  - Good for advanced practicals
- **Azure Machine Learning**:
  - Similar to AWS with different pricing model
  - Integrated with Microsoft ecosystem
- **Paperspace Gradient**:
  - User-friendly interface
  - Various GPU options

### Hybrid Approach (Recommended)
- Basic practicals on local machines
- Resource-intensive tasks on cloud platforms
- Shared high-performance workstations for advanced tasks
- Version control system to synchronize work between environments
