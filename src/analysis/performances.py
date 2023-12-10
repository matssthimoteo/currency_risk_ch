import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


currencies_list = ['USD', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD', 'NZD', 'SEK', 'NOK']

# Load monthly data
df = pd.read_csv('data/processed/monthly_data.csv')
df['Date'] = df['Date'].map(lambda x: pd.Timestamp(x))
df.set_index('Date', inplace=True)

returns = pd.DataFrame(index=df.index, columns=currencies_list)
for ccy in currencies_list:
    returns[ccy] = df[ccy] / df[ccy].shift() - 1

carry_fx_xs_returns = pd.DataFrame(index=df.index, columns=currencies_list)
for ccy in currencies_list:
    carry_fx_xs_returns[ccy] = df[ccy] / df[ccy].shift() * (1 + df[ccy + 'i']/100)**(1/12) - 1
carry_fx_xs_returns = carry_fx_xs_returns.subtract((1+df['CHFi']/100)**(1/12)-1, 0)

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




if __name__ == "__main__":
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