
XLIB l_ultob
LIB l_utob
   
l_ultob:

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

   push hl                     ; save least significant word
   
   ex de,hl
   ld e,c
   ld d,b
   
   call l_utob                 ; write most significant binary digits
   jr c, was_writing
   
   dec de                      ; remove solo '0' in buffer
   
was_writing:

   pop hl                      ; hl = least significant word
   jp l_utob                   ; write last binary digits
