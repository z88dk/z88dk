
SECTION code_clib
SECTION code_l

PUBLIC l_small_ultob

EXTERN l_small_utob
   
l_small_ultob:

   ; write unsigned binary long to ascii buffer
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de   = char *buffer (one byte past last char written)
   ;         carry set if in write loop
   ;
   ; uses  : af, b, de, hl

   push hl
   ex de,hl
   
   ld e,c
   ld d,b
   
   call l_small_utob
   jr c, was_writing
   
   dec de

was_writing:

   pop hl
   jp l_small_utob
