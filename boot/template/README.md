# Minimal PyTorch project environment

This Docker-image creates a basic structure to develop ML-projects.
The following structure is used:

- **/data:** \
    The data-files are saved here. The raw, untouched data (./raw) is saved in a different place than the sanitized (./interim) and fully preprocessed (./processed) data for versioning reasons.

- **/models:** \
    Saved models and checkpoints.

- **/notebooks:** \
    Notebooks are purely for presentation of results!
    - data-exploration.ipynb
    - training-evaluation.ipynb
    - visualization.ipynb (?)

- **/reports:** \
    Archive for latex-files and markdown-scribblings.
    - ./figures:
        Created figures to use in the final report.

- **/src:** \
    Source-code.
    - **./data:** \
        Code to generate and preprocess data.
        Uses and saves in /data
        Is used by a single notebook in /notebooks to visualize/analyze datasets.
    - **./models:** \
        Code of models. (own py-files)
        Scripts for training/predicting (own py-files)
        Are used by notebooks in /notebooks to visualize and analyze training-behavior.
    - **./visualization:** \
        Code to visualize/compare models of ./models.
        Is used by notebooks in /notebooks to visualize, compare and explain.



1. Write src/data/make_data.py
    data/raw/xy.csv                   # Raw, downloaded data
    -> data/interim/train.csv         # Theoretically usable data (usable data-format, scaled, ...)
    -> data/interim/test.csv
    -> data/processed/train.csv       # Final and used processed data (PCA, sanitized, ...)
    -> data/processed/test.csv

    notebooks/data-exploration.ipynb  # Visualization and Evaluation of data-preprocessing

   Write final configuration to config-file (?)

2. Write src/models/model_impl.py
    Write arguments, makefile, ...
    Write src/models/train_model.py. Execute with make train (configurations)
    Log to file!

    notebooks/training-evaluation.ipynb # Visualization and Evaluation of training and parameter-tuning

3. Write src/models/predict_model.py
    Execute with make predict (read config from train-log)

4. Write src/visualization/visualize.py (?)

## TODOs

- Install kite (code-suggestions)
- Snippets?
- Test setup
- vim
- git
