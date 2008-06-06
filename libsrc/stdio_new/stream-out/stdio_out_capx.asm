; stdio_out_capx
; 05.2008 aralbrec

XLIB stdio_out_capx
LIB stdio_out_x

INCLUDE "stdio.def"

; output %X parameter
;
; enter :    ix  = FILE *
;             a = precision
;             b = width
;             c = flags [-+ O#PLN]
;            de = integer
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
;           carry flag set = want capitals
; exit  :   bc' = total num chars output on stream thus far
;            hl = & parameter list
;         carry set if error on stream, ERRNO set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_capx

   scf
   jp stdio_out_x
