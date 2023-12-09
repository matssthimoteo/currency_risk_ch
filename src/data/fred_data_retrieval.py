import requests
import pandas as pd
import numpy as np


if _name_ == '_main_':
    # Set start and end dates
    start_date = pd.Timestamp('2002-04-01')
    end_date = pd.Timestamp('2023-10-31')

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
df = df.sort_index().loc[start_date:end_date]

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



# Export data to csvs
df_chf.to_csv('data/interim/daily_data_fred.csv')
df_chf.resample('M').last().to_csv('data/interim/monthly_data_fred.csv')