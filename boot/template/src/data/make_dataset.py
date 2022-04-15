from argparse import ArgumentParser

import torch
from torch.utils.data import Dataset, DataLoader, random_split
from torchvision import transforms
import numpy as np
import pandas as pd


RAW_DATA_PATH = "/project/data/raw/"
INTERIM_DATA_PATH = "/project/data/interim/"
PROCESSED_DATA_PATH = "/project/data/processed/"

class MyDataset(Dataset):

    def __init__(self, csv_path, transform=None):
        """
        csv_file (str): Path to the csv file.
        transform (callable, optional): Optional transform to be applied
            on a sample.
        """
        self.samples = pd.read_csv(csv_path, header=0, delimiter=';')
        self.samples.drop(columns=['Car', 'Origin'], inplace=True)
        self.samples = self.samples.astype(float)
        elf.x = torch.tensor(self.samples.iloc[:,1:-1].values, dtype=torch.float32)
        self.y = torch.tensor(self.samples.iloc[:,-1].values.reshape(-1,1), dtype=torch.float32)
        self.transform = transform

    def __len__(self):
        return len(self.y)

    def __getitem__(self, idx):
        """
        Execute transform on both x and y.
        """
        sample = (self.x[idx], self.y[idx])
        if self.transform:
            sample = self.transform(sample)
        return sample


def load_data_from_args(base_path, train_file, test_file, transform, batch_size, split_ratio) -> DataLoader:
    """
    Parse the commandline-arguments and create the test- and trainloader correspondingly.
    """
    if test_file == "": # data is in a single csv-file
        trainloader, testloader = load_data(base_path+train_file, transform=transform, batch_size=batch_size, split_ratio=split_ratio)
    else: # data is in separate csv-files
        trainloader = load_data(base_path+train_file, transform=transform, batch_size=batch_size)
        testloader = load_data(base_path+test_file, transform=transform, batch_size=batch_size)
    return trainloader, testloader


def load_data(path, transform=None, batch_size=64, split_ratio=None) -> DataLoader:
    """
    Load data from a csv-file at given path.
    """
    dataset = MyDataset(path, transform)
    if split_ratio:
        train_dataset, test_dataset = random_split(dataset,
                                                   [int(np.round(len(dataset)*split_ratio)), int(np.round(len(dataset)*(1-split_ratio)))])
        train_dataloader = DataLoader(train_dataset, batch_size=batch_size, num_workers=1)
        test_dataloader = DataLoader(test_dataset, batch_size=batch_size, num_workers=1)
        return train_dataloader, test_dataloader
    else:
        dataloader = DataLoader(dataset, batch_size=batch_size, num_workers=1)
        return dataloader


def get_mean_std(dataloader: DataLoader):
    """
    Calculate sample mean and standard-deviation of the dataset.
    """
    sample_mean = []
    sample_std = []

    for i, batch in enumerate(dataloader):
        numpy_image = batch[0].numpy()  # shape (batch_size, feature_length)
        batch_mean = np.mean(numpy_image, axis=(0))  # shape (feature_length,)
        batch_std = np.std(numpy_image, axis=(0), ddof=1)  # sample variance

        sample_mean.append(batch_mean)
        sample_std.append(batch_std)

    sample_mean = np.array(sample_mean).mean(axis=0)  # shape (num_iterations, 3) -> (mean across 0th axis) -> shape (3,)
    sample_std = np.array(sample_std).mean(axis=0)
    return sample_mean, sample_std


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--train', '--data', type=str, dest='train_filename',
                    help='The filename of either the training data or the combined dataset.')
    parser.add_argument('--test', default='', dest='test_filename',
                    help='The filename of the test data if present separately.')
    parser.add_argument('--train_ratio', '-r', type=float, default=0.8,
                    help='The ratio to split train- and test-data. Only usable if --test is unused.')
    args = parser.parse_args()

    # Initial load is used to calculate normalization-statistics.
    # A high batch-size increases accuracy of the statistics but uses more memory.
    # Only calculate normalization-statistics on the training set.
    stat_trainloader, _ = load_data_from_args(RAW_DATA_PATH, args.train_filename, args.test_filename,
                                              transform=None, batch_size=4096, split_ratio=args.train_ratio)
    mean, std = get_mean_std(stat_trainloader)

    # Load and preprocess the actual data.
    # Add Transformations after Normalize().
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize(mean, std)
    ])

    trainloader, testloader = load_data_from_args(RAW_DATA_PATH, args.train_filename, args.test_filename,
                                        transform=transform, batch_size=64, split_ratio=args.train_ratio)
    # save this to interim

    # use sklearn to preprocess. Visualize this somehow in a notebook
    # save results to processed
    torch.save(trainloader, PROCESSED_DATA_PATH+"train.dat")
    torch.save(testloader, PROCESSED_DATA_PATH+"test.dat")

    # run workflow through make data --test (to include test-set preprocessing)
