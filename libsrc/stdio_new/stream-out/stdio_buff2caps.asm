; stdio_buff2caps
; 05.2008 aralbrec

XLIB stdio_buff2caps

; capitalize all letters in buffer
;
; enter :  b = number of chars in buffer
;         hl = & buffer - 1
; uses  : af

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
