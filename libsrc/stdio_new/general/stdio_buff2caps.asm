; stdio_buff2caps
; 05.2008 aralbrec

PUBLIC stdio_buff2caps
EXTERN asm_toupper

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
   call asm_toupper
   ld (hl),a
   djnz loop

   pop hl
   pop bc
   ret
