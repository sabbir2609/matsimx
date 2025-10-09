# Install the Libraries

## For Linux/WSL (using uv)
You can install the libraries with:
```
pip install matcalc matgl seekpath crystal_toolkit
```

## For Windows (using conda)
Create a new conda environment:
```
conda create -n matsim python=3.10
conda activate matsim
```
Then install the libraries with:
```
pip install matcalc matgl seekpath crystal_toolkit
```

NOTE: This is really difficult to get working on Windows. If you run into issues, consider using WSL instead.

## More Information
1. [DGL Documentation](https://www.dgl.ai/pages/start.html)