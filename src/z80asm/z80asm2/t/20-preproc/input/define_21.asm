define ; no name
X define
X define ; duplicate definition
Y define
define Y(p1) ; duplicate definition
M7 define M8
M8 define M9
M9 define M7
defb M7 ; recursive call- not expanded
defb X,X,Y,Y
