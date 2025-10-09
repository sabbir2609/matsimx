## Advanced Computational tools for Materials Simulations (ACMS)
This repo contains a collection of tools and scripts developed for advanced computational materials simulations. These tools are designed to facilitate various tasks in materials science, including data analysis, visualization, and simulation management.

### Tools
- Density Functional Theory (DFT) Analysis: Quantum ESPRESSO, Matcalc.


# Install the Libraries

## For Linux/WSL (using uv)
You can install the libraries with:
```
uv add matcalc matgl seekpath crystal_toolkit
```

## For Windows (using conda)
You can install the libraries with:
```
conda install -c conda-forge matcalc
conda install -c dglteam dgl
conda install -c conda-forge matgl  # depends on dgl
conda install -c conda-forge seekpath
conda install conda-forge::crystal-toolkit
```

Additionally, install JupyterLab and IPython kernel:
```
conda install jupyterlab ipykernel
```

## More Information
1. [DGL Documentation](https://www.dgl.ai/pages/start.html)