import requests
import pandas as pd
import numpy as np


if __name__ == '__main__':
    # Set FRED API key
    api_key = '41641234dac871704cd09b2b8dd163ac'

    # G10 currency series codes
    g10_currency_series_codes = {
        'USDCHF': 'DEXSZUS',
        'EURUSD': 'DEXUSEU',
        'USDJPY': 'DEXJPUS',
        'GBPUSD': 'DEXUSUK',
        'AUDUSD': 'DEXUSAL',
        'USDCAD': 'DEXCAUS',
        'NZDUSD': 'DEXUSNZ',
        'USDSEK': 'DEXSDUS',
        'USDNOK': 'DEXNOUS',
        'VIX': 'VIXCLS',
        'CHFi': 'IRSTCI01CHM156N',
        'USDi': 'IRSTCI01USM156N',
        'EURi': 'IRSTCI01EZM156N',
        'JPYi': 'IRSTCI01JPM156N',
        'GBPi': 'IRSTCI01GBM156N',
        'AUDi': 'IRSTCI01AUM156N',
        'CADi': 'IRSTCI01CAM156N',
        'NZDi': 'IRSTCI01NZM156N',
        'SEKi': 'IRSTCI01SEM156N',
        'NOKi': 'IRSTCI01NOM156N'
    }

    # Dataframe to save results
    df = pd.DataFrame()

    # Loop through G10 currencies and make API requests
    for currency, series_code in g10_currency_series_codes.items():
        endpoint = 'https://api.stlouisfed.org/fred/series/observations'
        params = {
            'series_id': series_code,
            'api_key': api_key,
            'file_type': 'json',
        }

        response = requests.get(endpoint, params=params)

        if response.status_code == 200:
            data = response.json()
            observations = data['observations']

            currency_df = pd.DataFrame(observations, dtype=float).rename(columns={'value':f'{currency}'})
            currency_df['date'] = pd.to_datetime(currency_df['date'])


            # Merge the currency DataFrame with the main DataFrame
            if df.empty:
                df = currency_df
            else:
                df = pd.merge(df, currency_df, on='date', how='outer')
                df = df.fillna(method='ffill')

            currency_df = pd.DataFrame(observations, dtype=float).rename(columns={'value':f'{currency}'})
            currency_df['date'] = pd.to_datetime(currency_df['date'])
        else:
            print(f"Error: {response.status_code}, {response.text}")

df = df.set_index('date')[g10_currency_series_codes.keys()]
for column in df.columns:
    if not column == 'date':
        df[column] = df[column].map(lambda x: np.nan if x=='.' else x)
        df[column] = df[column].map(lambda x: float(x))
df = df.sort_index().loc['1999-01-02':]

currencies_list = ['USD', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD', 'NZD', 'SEK', 'NOK']
df_chf = pd.DataFrame(columns=currencies_list , index=df.index, dtype=float)

df_chf['USD'] = df['USDCHF']
df_chf['EUR'] = df['USDCHF'] * df['EURUSD']
df_chf['JPY'] = df['USDCHF'] / df['USDJPY']
df_chf['GBP'] = df['USDCHF'] * df['GBPUSD']
df_chf['AUD'] = df['USDCHF'] * df['AUDUSD']
df_chf['CAD'] = df['USDCHF'] / df['USDCAD']
df_chf['NZD'] = df['USDCHF'] * df['NZDUSD']
df_chf['SEK'] = df['USDCHF'] / df['USDSEK']
df_chf['NOK'] = df['USDCHF'] / df['USDNOK']
df_chf['VIX'] = df['VIX']

for ccy in currencies_list:
    df_chf[ccy + 'i'] = df[ccy + 'i']
df_chf['CHFi'] = df['CHFi']

# Export data to csvs
df_chf.to_csv('data/processed/daily_data.csv')
df_chf.resample('M').last().to_csv('data/processed/monthly_data.csv')
