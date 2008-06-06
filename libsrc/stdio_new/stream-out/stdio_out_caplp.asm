; stdio_out_caplp
; 05.2008 aralbrec

XLIB stdio_out_caplp
LIB stdio_out_lx

; output %lP parameter, handles 16-bit %P and 24-bit %lP
;
; enter :    ix  = FILE *
;             a = precision
;             b = width
;             c = flags [-+ O#PLN]
;            de = void *
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
;           carry flag set = want capitals
; exit  :   bc' = total num chars output on stream thus far
;            hl = & parameter list
;         carry set if error on stream, ERRNO set appropriately
; uses  : af, bc, de, hl, exx

.stdio_out_caplp

   set 3,c
   scf
   jp stdio_out_lx

