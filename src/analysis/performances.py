import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from typing import List


def build_df(currencies_list: List[str]):
    # Load monthly data
    df = pd.read_csv('data/processed/monthly_data.csv')
    df['Date'] = df['Date'].map(lambda x: pd.Timestamp(x))
    df.set_index('Date', inplace=True)
    df = df[[x for x in currencies_list if x in df.columns] + [x + 'i' for x in currencies_list if x in df.columns] + ['CHFi']]
    return df

def compute_returns(df: pd.DataFrame,
                    currencies_list: List[str] = None) -> pd.DataFrame:
    returns = pd.DataFrame(index=df.index, columns=currencies_list)
    for ccy in currencies_list:
        returns[ccy] = df[ccy] / df[ccy].shift() - 1
    return returns

def compute_carry_fx_xs_returns(df: pd.DataFrame,
                                currencies_list: List[str] = None) -> pd.DataFrame:
    carry_fx_xs_returns = pd.DataFrame(index=df.index, columns=currencies_list)
    for ccy in currencies_list:
        carry_fx_xs_returns[ccy] = df[ccy] / df[ccy].shift() * (1 + df[ccy + 'i']/100)**(1/12) - 1
    carry_fx_xs_returns = carry_fx_xs_returns.subtract((1+df['CHFi']/100)**(1/12)-1, 0)
    return carry_fx_xs_returns

def plot_performances(returns: pd.DataFrame,
                      use_semilogy: bool = False,
                      save: bool = False,
                      fig_name: str = 'None',
                      title: str = None):
    (1+returns).cumprod().plot(figsize=(12, 8), title=title)
    if use_semilogy:
        plt.semilogy()
    plt.ylabel('FX_t / FX_0')
    plt.xlabel('Time')
    if save:
        plt.savefig(f'latex/figures/{fig_name}')
    plt.show()
    plt.close()

def plot_return_histograms(returns_df: pd.DataFrame,
                           currencies_list: List[str] = None,
                           n_bins: int = 40,
                           max_return: float = 0.16):
    for ccy in currencies_list:
        plt.figure()
        plt.title(ccy)
        plt.hist(returns_df[ccy],
                 bins=n_bins,
                 range=(-max_return, max_return),
                 density=True)
        plt.show()

def get_avg_returns(returns_df: pd.DataFrame) -> pd.Series:
    return (1 + returns_df.mean(0))^12 - 1

def get_autocorrelations(excess_returns: pd.DataFrame,
                          currencies_list: List[str] = None,
                          max_bars: int = 16) -> pd.DataFrame:
    autocorrelations = np.vstack([excess_returns.apply(lambda col: col.autocorr(i)) for i in range(1, 16)])
    autocorrelations = pd.DataFrame(autocorrelations, index=range(1, 16), columns=currencies_list)
    return autocorrelations

def plot_autocorrelations(excess_returns: pd.DataFrame,
                          currencies_list: List[str] = None,
                          max_bars: int = 16):
    autocorrelations = np.vstack([excess_returns.apply(lambda col: col.autocorr(i)) for i in range(1, 16)])
    autocorrelations = pd.DataFrame(autocorrelations, index=range(1, 16), columns=currencies_list)
    for ccy in currencies_list:
        plt.bar(range(1, max_bars), autocorrelations[ccy])
        plt.title(f'{ccy} - Autocorrelations')
        plt.show()

def get_covariance_matrix(returns: pd.DataFrame,
                          currencies_list: List[str] = None):
    return returns[currencies_list].cov()

def get_covrrelation_matrix(returns: pd.DataFrame,
                          currencies_list: List[str] = None):
    return returns[currencies_list].corr()

def plot_eigenvector_components(matrix: pd.DataFrame,
                                currencies_list: List[str] = None,
                                component: int = 0):
    plt.figure()
    plt.bar(currencies_list, pd.DataFrame(-np.linalg.eig(matrix.loc[currencies_list, currencies_list])[component],
                        index=currencies_list)[0])
    plt.title('Eigenvector loadings on each G10/CHF pair')
    plt.show()




if __name__ == "__main__":
    currencies_list = ['USD', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD', 'NZD', 'SEK', 'NOK']
    df = build_df(currencies_list)
    returns = compute_returns(df)
    carry_fx_xs_returns = compute_carry_fx_xs_returns(df)

    # Plot currency performances
    plot_performances(returns,
                      save=True,
                      fig_name='ccy_perfs.jpg',
                      )
    # Plot carry FX excess performances
    plot_performances(carry_fx_xs_returns,
                      save=True,
                      fig_name='carry_fx_perfs.jpg',
                      title='FX Carry - excess returns')