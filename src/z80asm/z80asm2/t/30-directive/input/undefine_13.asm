#define X(p) hello ## p
defb X(world)
#undefine X
defb X(p)
#undefine X
defb X(p)
