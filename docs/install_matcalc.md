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