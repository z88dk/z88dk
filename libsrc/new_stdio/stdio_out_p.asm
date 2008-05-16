; stdio_out_p
; 05.2008 aralbrec

XLIB stdio_out_p
LIB stdio_out_x

; output %p parameter
;
; enter :    ix  = & attached file / device output function
;             a = precision
;             b = width
;             c = flags [-+ O#P0N]
;            de = void *
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
; exit  :   bc' = total num chars output on stream thus far
;         stack = & parameter list
;         carry set if error on stream, a = (errorno) set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_p

   ld c,$08
   jp stdio_out_x

