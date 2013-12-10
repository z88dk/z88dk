
XLIB l_eat_ws
LIB asm_isspace

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
   jp l_eat_ws
