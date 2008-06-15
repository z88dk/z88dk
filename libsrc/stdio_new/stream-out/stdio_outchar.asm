; stdio_outchar
; 05.2008 aralbrec

XLIB stdio_outchar
LIB l_jpix

INCLUDE "stdio.def"

; all character output to attached file or device passes through this function
;
; enter : ix  = FILE *
;          a  = char for output
;         bc' = number of chars output thus far
; exit  : bc' = number of chars output thus far
;         carry set if error on stream, a = (errorno) set appropriately
; uses  : af, exx

.stdio_outchar

   exx
   push bc
   ld b,a
   ld c,STDIO_MSG_PUTC
   call l_jpix
   pop bc
   jr c, error
   
   inc bc

.error

   exx
   ret
