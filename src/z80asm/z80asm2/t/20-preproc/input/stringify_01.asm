#define cat(a, b) a ## b
#define stringify(x) # x
#define inner cat(x, y)

str1 defm stringify(inner)
str2 defm stringify(cat(x, y))
str3 defm stringify(xy)
