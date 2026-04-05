#define M1(a,b) (a+b)
defb M1(2,3)
#define M2(a,b) = (a-b)
defb M2(4,5)
#define M3(a,b) (M1(a,b)+M2(a,b))*3
defb M3(6,7)
#define M4(a,b) = (M3(a,b))*3
defb M4(8,9)
