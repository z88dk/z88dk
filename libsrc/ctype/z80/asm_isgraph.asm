
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isgraph

asm_isgraph:

   ; determine if char is visible -- satisfies isprint except space
   
   ; enter : a = char
   ; exit  : carry if not isgraph
   ; uses  : f
   
   cp 33
   ret c
   
   cp 127
   ccf
   ret
