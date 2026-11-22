
SECTION code_clib
SECTION code_l

PUBLIC l_small_ultoh

EXTERN l_small_utoh

l_small_ultoh:

   ; write unsigned hexadecimal long to ascii buffer in uppercase
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de   = char *buffer (one byte past last char written)
   ;         carry set if in write loop
   ;
   ; uses  : af, de

   push hl
   ex de,hl
   
   ld e,c
   ld d,b
   
   call l_small_utoh
   jr c, was_writing
   
   dec de

was_writing:

   pop hl
   jp l_small_utoh
