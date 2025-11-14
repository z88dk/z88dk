
SECTION code_clib
SECTION code_l

PUBLIC l_eat_ws

EXTERN asm_isspace

l_eat_ws:

   ; advance the buffer pointer past whitespace characters
   ;
   ; enter : hl = char *
   ;
   ; exit  : hl = char * (first non-ws char)
   ;          a = first non-ws char
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   call asm_isspace
   ret c
   
   inc hl
   jr l_eat_ws
