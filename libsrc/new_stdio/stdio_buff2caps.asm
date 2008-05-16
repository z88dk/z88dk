; stdio_buff2caps
; 05.2008 aralbrec

XLIB stdio_buff2caps

; output string of chars to file / device from temporary buffer
;
; enter :  b = number of chars from buffer to output
;         hl = & buffer - 1
; uses  : af, exx

.stdio_buff2caps

   ld a,b
   or a
   ret z
   
   push bc
   push hl
   
.loop

   inc hl
   ld a,(hl)
   
   cp 'a'
   jr c, skip
   
   and $df
   ld (hl),a

.skip

   djnz loop

   pop hl
   pop bc
   ret
