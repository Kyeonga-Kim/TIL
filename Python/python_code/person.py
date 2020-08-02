class Person():
    name = '사람의 고유한 속성'
    age = '출생 이후부터 삶을 마감할 때까지의 기간'

    def greeting(self):
        print(f'{self.name}이 인사합니다. 안녕하세요.')

    def eating(self):
        print(f'{self.name}은 밥을 먹습니다.')

    def aging(self):
        print(f'{self.name}은 {self.age}살이지만, 나이를 먹어가는 중입니다.')

# 클래스 - 사람(집단)
# 인스턴스 - 사람(개인)
# 메소드 - 사람이 가지고 있는 행위
# 클래스 변수 - 사람(집단, 특성)이 가지고 있는 공통 속성
# 인스턴스 변수 - 사람(개인)이 가지는 고유한 특성


# DB - Class
# 테이블 - 클래스
# 열 - 클래스 변수
# 행 - 인스턴스
# 행이 가지는 값들 - 인스턴스 변수
# 값들의 조합 or 가공 - 메소드