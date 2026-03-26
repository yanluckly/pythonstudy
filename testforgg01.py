print('test')

def is_leap_year(year):
    """
    判断年份是否为闰年
    闰年规则：
    - 能被4整除但不能被100整除，或者能被400整除
    """
    if (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0):
        return True
    else:
        return False

# 测试
print(is_leap_year(2020))  # True
print(is_leap_year(1900))  # False
print(is_leap_year(2000))  # True
print(is_leap_year(2023))  # False