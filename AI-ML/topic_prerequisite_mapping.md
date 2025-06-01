# Mapping of Practical Topics to Lab Prerequisites

## Time Series Analysis

### Topics:
- Time Series Decomposition and Smoothing
- Time Series Models (ARIMA, SARIMA, Prophet, ML models)
- Model Selection and Evaluation
- Advanced Techniques and Applications

### Required Hardware:
- **Basic Setup** is sufficient for most time series practicals
- **Recommended Setup** for larger datasets and more complex models (Random Forest, XGBoost)
- **Advanced Setup** only needed for deep learning time series applications

### Required Software:
- Python 3.8+
- Jupyter Notebook/Lab
- NumPy, pandas
- matplotlib, seaborn, plotly
- statsmodels
- scikit-learn
- prophet
- pmdarima
- tslearn
- xgboost, lightgbm
- tensorflow/pytorch (for deep learning time series only)

## Deep Learning & Computer Vision

### Topics:
- Neural Network Implementation
- Loss Functions and Optimization
- PyTorch and Model Building
- Convolutional Neural Networks (CNNs)
- Modern CNN Architectures
- Recurrent Neural Networks (RNNs)
- Autoencoders
- Object Detection
- Image Segmentation
- Vision Transformers and Foundation Models
- Generative AI in Vision

### Required Hardware:
- **Basic Setup** only sufficient for small neural networks and basic CNN exercises
- **Recommended Setup** required for most CNN, RNN, and autoencoder practicals
- **Advanced Setup** necessary for:
  - Modern CNN architectures (ResNet, etc.)
  - Object detection (YOLOv5, Faster R-CNN)
  - Image segmentation (U-Net, Mask R-CNN)
  - Vision transformers
  - Foundation models (SAM, CLIP, DINO)
  - Generative AI (GANs, diffusion models)

### Required Software:
- Python 3.8+
- Jupyter Notebook/Lab or VS Code
- PyTorch (with CUDA support)
- CUDA Toolkit and cuDNN
- NumPy, pandas
- matplotlib, seaborn
- OpenCV, Pillow
- torchvision
- albumentations
- timm
- transformers
- detectron2
- segmentation-models-pytorch
- TensorBoard
- diffusers (for generative AI)
- accelerate, bitsandbytes, xformers (for large models)

## Validation Notes

1. **Time Series Analysis**:
   - Most practicals can run on standard hardware
   - Deep learning for time series requires GPU acceleration
   - All software is open-source and freely available

2. **Deep Learning & Computer Vision**:
   - GPU is essential for all but the most basic exercises
   - CUDA compatibility is critical - ensure PyTorch/TensorFlow version matches CUDA version
   - Foundation models and generative AI require significant GPU memory (≥16GB VRAM ideal)
   - Cloud options recommended for resource-intensive tasks if local hardware is insufficient

3. **Lab Environment Considerations**:
   - Local setup provides best experience but highest cost
   - Cloud options provide flexibility but require internet connectivity
   - Hybrid approach balances cost and performance
   - Version control essential for any setup to manage code and collaborate
