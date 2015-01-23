; stdio_outpad
; 05.2008

PUBLIC stdio_outpad
EXTERN stdio_outchar

; output n identical characters
;
; enter : ix  = FILE *
;          c  = char for output
;          b  = number of chars to output
;         carry set if error on stream, ERRNO set appropriately
; uses  : af, b, exx

.stdio_outpad

   ld a,b
   or a
   ret z
      
.loop

   ld a,c
   call stdio_outchar
   ret c
   djnz loop
   
   ret
