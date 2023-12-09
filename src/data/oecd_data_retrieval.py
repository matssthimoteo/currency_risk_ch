mport requests
from bs4 import BeautifulSoup
import pandas as pd
import json

# Set start and end dates
start_date = pd.Timestamp('2002-04-01')
end_date = pd.Timestamp('2023-10-31')

# URL for the SNB exchange rate data
url = f"https://stats.oecd.org/sdmx-json/data/DP_LIVE/AUS+CAN+CHE+EA19+GBR+JPN+NOR+NZL+SWE+USA.STINT.TOT.PC_PA.M/OECD?json-lang=en&dimensionAtObservation=allDimensions&startPeriod={start_date.year}"

ccy_from_country = dict(pd.Series(['AUD', 'CAD', 'CHF', 'EUR', 'GBP', 'JPY', 'NOK', 'NZD', 'SEK', 'USD'],
                                  index=["AUS", "CAN", "CHE", "EA19", "GBR", "JPN", "NOR", "NZL", "SWE", "USA"]))

# Make a GET request to the URL
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Parse the HTML content of the page
    soup = BeautifulSoup(response.content, 'html.parser')

    data = json.loads(str(soup))
    # Organize the data into a dictionary
    organized_data = {
        'header': data['header'],
        'dataSets': data['dataSets'],
        'structure': data['structure']
    }

    # Get index of dates for the Data Frame
    dates_str = organized_data['structure']['dimensions']['observation'][5]['values']
    dates_timestamp = pd.Series([dates_str[i]['id'] for i in range(len(dates_str))]).map(lambda x: pd.Timestamp(x)) + pd.offsets.MonthEnd(0)

    # Get columns in correct order
    columns_countries = organized_data['structure']['dimensions']['observation'][0]['values']
    columns_countries = [columns_countries[i]['id'] for i in range(len(columns_countries))]

    oecd_df = pd.DataFrame(index=dates_timestamp,
                           columns=[ccy_from_country[country] + 'i' for country in columns_countries])
    
    observations = organized_data['dataSets'][0]['observations']
    for obs in observations.keys():
        row = int(obs.split(':')[5])
        col = int(obs.split(':')[0])
        oecd_df.iloc[row, col] = observations[obs][0]
    oecd_df.rename_axis('Date', inplace=True)
    oecd_df = oecd_df.sort_index()
    oecd_df = oecd_df.loc[start_date:end_date]
    oecd_df.to_csv('data/interim/monthly_data_oecd.csv')

else:
    print(f"Error: {response.status_code}")