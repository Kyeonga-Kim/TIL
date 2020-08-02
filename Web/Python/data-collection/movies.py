import os
import csv
from datetime import datetime, timedelta
import requests


key = os.getenv('KOBIS_KEY')

result = []

with open('boxoffice.csv', newline='', encoding='utf8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        url = f'http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key={key}&movieCd={row["movie_code"]}'
        response = requests.get(url).json()

        movie = response.get('movieInfoResult').get('movieInfo')
        print(movie)
        movie_info = {
            'movie_code': movie.get('movieCd'),
            'movie_name_ko': movie.get('movieNm'),
            'movie_name_en': movie.get('movieNmEn'),
            'movie_name_og': movie.get('movieNmOg'),
            'watch_grade_nm': movie.get('audits')[0].get('watchGradeNm') if movie.get('audits') else '',
            'open_dt': movie.get('openDt'),
            'show_tm': movie.get('showTm'),
            'genres': '/'.join([g.get('genreNm') for g in movie.get('genres')]),
            'directors': '/'.join([d.get('peopleNm') for d in movie.get('directors')]),
        }
        result.append(movie_info)

with open('movies.csv', 'w', encoding='utf8', newline='') as file:
    fieldnames = ('movie_code','movie_name_ko', 'movie_name_en','movie_name_og','open_dt','show_tm','genres','directors','watch_grade_nm')
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    for row in result:
        writer.writerow(row)
