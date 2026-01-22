a = 0
b = 0
c = 0
max_abc = 0
min_abc = 11110

while a <= 26:
    b = 0
    c = 0
    a = a + 1
    while b <= 26:
        c = 0
        b = b + 1
        while c <= 26:
            c = c + 1
            if a == b or b == c or a == c:
                continue
            if 28 != (a + b + c):
                continue
            if max_abc < a * b * c:
                max_abc = a * b * c
            if min_abc > a * b * c:
                min_abc = a * b * c
print( max_abc, min_abc )

def is_palindrome(s):
    s = s.replace(" ", "").lower()
    return s == s[::-1]

print(is_palindrome("A man a plan a canal Panama"))
print(is_palindrome("racecar"))
print(is_palindrome("hello"))
