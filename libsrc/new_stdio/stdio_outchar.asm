; stdio_outchar
; 05.2008 aralbrec

XLIB stdio_outchar
LIB l_jpix

; all character output to attached file or device passes through this function
;
; enter : ix  = & attached file / device output function
;          a  = char for output
;         bc' = number of chars output thus far
; exit  : bc' = number of chars output thus far
;         carry set if error on stream, a = (errorno) set appropriately
; uses  : af, exx

.stdio_outchar

   exx
   push bc
   call l_jpix
   pop bc
   jr c, error
   
   inc bc
   res 0,(ix-2)                ; no unget char available

.error

   exx
   ret
