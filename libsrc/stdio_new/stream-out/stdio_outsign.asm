; stdio_outsign
; 05.2008 aralbrec

XLIB stdio_outsign
LIB stdio_outchar

; output a sign "+- " depending on specified flags
;
; enter :  e = flags [?+ ????N]
;         ix = FILE *
; exit  : carry set if error on stream, a = ERRNO set appropriately
; uses  : af, exx

.stdio_outsign

   ld a,$61
   and e
   ret z

   ld a,'-'
   bit 0,e
   jp nz, stdio_outchar

   ld a,'+'
   bit 6,e
   jp nz, stdio_outchar
   
   ld a,' '
   jp stdio_outchar
