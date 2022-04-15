import torch
from torch import nn
from torch.nn import functional
import pytorch_lightning as pl


def block(in_dims, out_dims, activation=None, *args, **kwargs):
    """
    A block which occurs repeatedly in the sequential model.
    """
    if activation is None:
        activation = nn.ReLU
    return nn.Sequential(
        nn.Linear(in_dims, out_dims),
        activation()
    )

class MyModel(pl.LightningModule):

    def __init__(self, layer_widths: list, optimizer=None, lr=None, *args, **kwargs):
        """
        Creates a model consisting ofk
        - a Sequence of blocks
        layer_widths: []
            [input_dim, *hidden_layer_dims, n_classes]
       activation=method
            nn.ReLU, ...
        """
        super().__init__()
        if optimizer is None:
            optimizer = torch.optim.Adam
        self.optimizer = optimizer
        self.lr = lr
        blocks = nn.Sequential(*[
            block(in_dim, out_dim, *args, **kwargs)
            for in_dim, out_dim in zip(layer_widths, layer_widths[1:]) # zip with shifted version of itself
            ])                                                         # to make dimensions match.
                                                                       # Exclude last layer for self.tail
        self.model = nn.Sequential(*[
            blocks,
        ])

    def forward(self, x):
        return self.model(x)

    def _calculate_loss(self, x, y):
        """
        Calculation of loss-function used in training, validation, testing etc.
        """
        y_predicted = self(x)
        loss = functional.mse_loss(y_predicted, y)
        return loss

    def training_step(self, batch, batch_idx):
        """
        Customize the training-procedure and the loss function.
        """
        print(batch)
        x, y = batch
        loss = self._calculate_loss(x, y)
        return loss

    def validation_step(self, batch, batch_idx):
        x, y = batch
        y_predicted = self(x)
        loss = self._calculate_loss(x, y)
        metrics = {'val_loss': loss}
        self.log_dict(metrics)
        return metrics

    def test_step(self, batch, batch_idx):
        x, y = batch
        loss = self._calculate_loss(x, y)
        metrics = {'test_loss': loss}
        self.log_dict(metrics)
        return metrics

    def predict_step(self, batch, batch_idx, dataloader_idx=0):
        x, y = batch
        y_predicted = self(x)
        return y_predicted

    def configure_optimizers(self):
        """
        Configure optimizer to use.
        """
        return self.optimizer(self.parameters(), self.lr)
