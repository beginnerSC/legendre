FROM jupyter/base-notebook:latest

# Switch to root for package installation
USER root

# Install build tools and dependencies for xeus-cpp
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jovyan user
USER jovyan

# Install xeus-cpp kernel using mamba/conda (latest version)
RUN mamba install -c conda-forge xeus-cpp -y

# Keep only the C++23 kernel in JupyterLab
RUN rm -rf /opt/conda/share/jupyter/kernels/* \
    && cp -r /opt/conda/share/jupyter/kernels/xcpp23 /opt/conda/share/jupyter/kernels/

# Install any additional kernels or packages
RUN pip install --no-cache-dir \
    jupyterlab \
    ipykernel

# Set the working directory
WORKDIR /home/jovyan

# Expose the default Jupyter port
EXPOSE 8888

# Set environment variables
ENV JUPYTER_ENABLE_LAB=yes

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
