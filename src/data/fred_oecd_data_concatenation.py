import pandas as pd


def merge():
    # Load separate data FRED/OECD
    fred_df = pd.read_csv('data/interim/monthly_data_fred.csv')
    oecd_df = pd.read_csv('data/interim/monthly_data_oecd.csv')

    # Handle timestamps
    assert 'date' in fred_df.columns, "Bad FRED csv formatting."
    fred_df.rename(columns={'date': 'Date'}, inplace=True)
    assert 'Date' in oecd_df.columns, "Bad OECD csv formatting."
    fred_df['Date'] = fred_df['Date'].map(lambda x: pd.Timestamp(x))
    oecd_df['Date'] = oecd_df['Date'].map(lambda x: pd.Timestamp(x))
    fred_df.set_index('Date', inplace=True)
    oecd_df.set_index('Date', inplace=True)

    # Concatenate data
    df = pd.concat([fred_df, oecd_df], axis=1)

    # Export final CSV
    df.to_csv('data/processed/monthly_data.csv')

if __name__ == '__main__':
    merge()