from model_impl import MyModel

import pytorch_lightning as pl
from argparse import ArgumentParser

INPUT_DIM = 10
OUTPUT_DIM = 1

def main(hparams):
    model = MyModel(layer_widths=[INPUT_DIM, 16, OUTPUT_DIM])
    trainer = pl.Trainer(max_epochs=hparams.max_epochs)
    # use trainloader from src/data
    trainer.fit(model, hparams.trainloader)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--input_dim", "-i", type=int)
    parser.add_argument("hidden_dims",  # name on the CLI - drop the `--` for positional/required parameters
        nargs="+",  # 0 or more values expected => creates a list
        type=int
    )
    parser.add_argument("--output_dim", "-o", type=int)
    parser.add_argument("--learning-rate", "-l", type=float)
    parser.add_argument("--optim", "-p", type=str)
    parser.add_argument("--max-epochs", default=1, type=int)
    args = parser.parse_args()
    main(args)
