
PUBLIC l_small_asr_dehl

l_small_asr_dehl:

   ; arithmetic shift right 32-bit signed long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl
   
   or a
   ret z
   
   ld b,a
   ld a,e

shift_loop:

   sra d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret
