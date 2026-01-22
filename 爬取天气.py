import requests
from bs4 import BeautifulSoup

def get_weather(city_code):
    url = f"http://www.weather.com.cn/weather/{city_code}.shtml"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    
    response = requests.get(url, headers=headers)
    response.encoding = 'utf-8'
    
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # 获取天气信息
        weather_info = soup.find('ul', class_='t clearfix')
        if weather_info:
            today_weather = weather_info.find('li')
            if today_weather:
                date = today_weather.find('h1').text
                weather = today_weather.find('p', class_='wea').text
                temperature = today_weather.find('p', class_='tem').text.strip()
                wind = today_weather.find('p', class_='win').find('span')['title']
                
                print(f"城市: {city_code}, 日期: {date}, 天气: {weather}, 温度: {temperature}, 风力: {wind}")
            else:
                print(f"未找到{city_code}的当天天气信息")
        else:
            print(f"未找到{city_code}的天气信息")
    else:
        print(f"请求失败，状态码: {response.status_code}")

# 示例：获取北京（101010100）和上海（101020100）的天气
get_weather("101010100")  # 北京
get_weather("101020100")  # 上海    