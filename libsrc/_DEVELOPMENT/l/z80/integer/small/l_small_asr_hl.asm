
PUBLIC l_small_asr_hl

l_small_asr_hl:

   ; arithmetic shift right 16-bit signed int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, b, hl

   or a
   ret z
   
   ld b,a
   ld a,l

shift_loop:

   sra h
   rra
   
   djnz shift_loop
   
   ld l,a
   ret
