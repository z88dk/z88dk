; stdio_out_p
; 05.2008 aralbrec

XLIB stdio_out_p
LIB stdio_out_x

; output %p parameter
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

.stdio_out_p

   set 3,c
   bit 2,c
   jp nz, stdio_out_x
   
   set 2,c
   ld a,4
   jp stdio_out_x

