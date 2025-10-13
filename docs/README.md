# MatterGen

A physics-based content generation framework from Microsoft.

## Overview

MatterGen is a powerful toolkit for generating physics-based content with customizable parameters. It uses advanced simulation techniques to create realistic physics scenarios.

## Features

- Generate physics-based content with configurable parameters
- High-performance simulation capabilities
- Batch processing of multiple scenarios
- Customizable output format and location

## Getting Started

### Prerequisites

- Python 3.10
- Git and Git LFS

### Installation

```bash
# Install uv package manager
wget -qO- https://astral.sh/uv/install.sh | sh

# Clone the repository
git clone https://github.com/microsoft/mattergen.git
cd mattergen

# Set up virtual environment
uv venv .venv --python 3.10
source .venv/bin/activate

# Install MatterGen and dependencies
uv pip install -e .

# Install Git LFS (required for model files)
sudo apt install git-lfs
git lfs --version
```

## Usage Example

MatterGen can be used to generate physics simulations with the following command:

```bash
# Set environment variables
export MODEL_NAME=mattergen_base
export RESULTS_PATH=results/
export OUTPUT_PATH="output/"

# Run MatterGen
mattergen-generate $RESULTS_PATH --pretrained-name=$MODEL_NAME --batch_size=16 --num_batches 1 --output_path=$OUTPUT_PATH
```

## For Researchers and Developers

MatterGen can be particularly useful for:

- Creating physics-based training data for machine learning models
- Generating realistic physics simulations for testing and validation
- Exploring complex physical systems through simulation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request to the [MatterGen repository](https://github.com/microsoft/mattergen).

## License

This project is licensed under the terms specified in the repository.

## Acknowledgments

- Microsoft for developing and maintaining MatterGen
- Contributors and maintainers of the project
