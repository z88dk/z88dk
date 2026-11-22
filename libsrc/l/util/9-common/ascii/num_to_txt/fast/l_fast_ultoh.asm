
SECTION code_clib
SECTION code_l

PUBLIC l_fast_ultoh

EXTERN l_fast_utoh

l_fast_ultoh:

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
   
   push hl                     ; save least significant word
   ex de,hl

   ld e,c
   ld d,b
   
   call l_fast_utoh            ; write most significant hex digits
   jr c, was_writing
   
   dec de                      ; remove solo '0' in buffer
   
was_writing:

   pop hl                      ; hl = least significant word
   jp l_fast_utoh              ; write last four hex digits
