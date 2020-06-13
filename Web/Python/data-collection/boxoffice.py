import os
import csv
from datetime import datetime, timedelta
import requests


key = os.getenv('KOBIS_KEY')

result = {}

for i in range(50):
    target_dt = (datetime(2020, 5, 31) - timedelta(weeks=i)).strftime('%Y%m%d')
    print(target_dt)
    
    url = f'http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key={key}&weekGb=0&targetDt={target_dt}'
    response = requests.get(url).json()

    movies = response.get('boxOfficeResult').get('weeklyBoxOfficeList')
    
    for movie in movies:
        movie_code = movie.get('movieCd')
        if movie_code not in result:
            result[movie_code] = {
                'movie_code': movie_code,
                'title': movie.get('movieNm'),
                'audience': movie.get('audiAcc'),
            }

with open('boxoffice.csv', 'w', encoding='utf8', newline='') as file:
    fieldnames = ('movie_code', 'title', 'audience',)
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    for row in result.values():
        writer.writerow(row)
