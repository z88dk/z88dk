; stdio_outbuff
; 05.2008 aralbrec

PUBLIC stdio_outbuff
EXTERN stdio_outchar

; output string of chars to file / device from temporary buffer
;
; enter :  b = number of chars from buffer to output
;         hl = & buffer - 1
;         ix = & attached file / device output function
; exit  : carry set if error on stream, ERRNO set appropriately
; uses  : af, b, hl, exx

.stdio_outbuff

   ld a,b
   or a
   ret z
   
.loop

   inc hl
   ld a,(hl)
   call stdio_outchar
   ret c
   djnz loop
   
   ret
