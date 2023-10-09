from bs4 import BeautifulSoup
import requests
import pandas as pd

url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text, 'html.parser')

table = soup.find_all('table')[1]

world_titles = table.find_all('th')

world_table_titles = [title.text.strip() for title in world_titles]
print(world_table_titles)

data_frame = pd.DataFrame(columns = world_table_titles)
print(data_frame)

column_data = table.find_all('tr')

for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    print(individual_row_data)
    length = len(data_frame)
    data_frame.loc[length] = individual_row_data
    
data_frame.to_csv(r'D:\Desktop\Python Practice\Companies.csv', index = False)
    
