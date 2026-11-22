
SECTION code_clib
SECTION code_l

PUBLIC l_small_lsr_hl

EXTERN error_znc

l_small_lsr_hl:

   ; logical shift right 16-bit unsigned int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, b, hl

   or a
   ret z
   
   cp 16
   jp nc, error_znc
   
   ld b,a
   ld a,l

shift_loop:

   srl h
   rra
   
   djnz shift_loop
   
   ld l,a
   ret
