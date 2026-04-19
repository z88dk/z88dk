#define ; no name
#define X
#define X ; duplicate definition
#define Y
#define Y(p1) ; duplicate definition
#define M1( ; missing close paren
#define M2(21 ; missing parameter
#define M3(p1 p2 ; missing comma
#define M4(p1,p1) ; duplicate parameters
#define M5 (p1,p2) ; object macro
defb M5(1,2) ; (p1,p2) (1,2)
defb M5 (1,2) ; (p1,p2) (1,2)
#define M6(p1,p2) (p1+p2) ; function macro
defb M6 ; not expanded
defb M6( ; missing ')'
defb M6(1,2,3) ; argument mismatch
defb M6(1,(2,3)) ; ok
#define M7 M8
#define M8 M9
#define M9 M7
defb M7 ; recursive call- not expanded
defb X,X,Y,Y
