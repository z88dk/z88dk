
SECTION code_clib
SECTION code_l

PUBLIC l_small_lsr_dehldehl

EXTERN l_lsr_dehl
EXTERN error_llznc, error_lznc

l_small_lsr_dehldehl:

   ; logical shift right 64-bit unsigned long
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl >> a
   ;
   ; uses  : af, b, de, hl, de', hl'

   or a
   ret z
   
   cp 64
   jp nc, error_llznc
   
   cp 32
   jr c, shift
   
   ; 32-bit shift
   
   sub 32
   call error_lznc
   
   exx
   
   jp l_lsr_dehl
   
shift:

   ld b,a
   ld a,e

shift_loop:

   exx
   
   srl d
   rr e
   rr h
   rr l
   
   exx
   
   rr d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret
