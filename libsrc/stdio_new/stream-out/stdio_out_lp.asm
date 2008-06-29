; stdio_out_lp
; 05.2008 aralbrec

XLIB stdio_out_lp
LIB stdio_out_lx

; output %lp parameter, handles both 16-bit %p and 24-bit %lp
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

.stdio_out_lp

   set 3,c
   bit 2,c
   jp nz, stdio_out_lx
   
   set 2,c
   ld a,6
   jp stdio_out_lx
