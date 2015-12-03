
SECTION code_clib
SECTION code_l

PUBLIC l_small_lsr_dehl

EXTERN error_lznc

l_small_lsr_dehl:

   ; logical shift right 32-bit unsigned long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl

   or a
   ret z
   
   cp 32
   jp nc, error_lznc
   
   ld b,a
   ld a,e

shift_loop:

   srl d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret
