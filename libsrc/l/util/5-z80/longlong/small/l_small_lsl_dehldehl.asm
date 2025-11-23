
SECTION code_clib
SECTION code_l

PUBLIC l_small_lsl_dehldehl

EXTERN l_lsl_dehl
EXTERN error_llznc, error_lznc

l_small_lsl_dehldehl:

   ; logical shift left 64-bit number
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl << a
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
   
   call l_lsl_dehl
   
   exx
   jp error_lznc

shift:
   
   ; 64-bit shift
   
   ld b,a
   ld a,e
   
shift_loop:
 
   add hl,hl
   rla
   rl d

   exx

   adc hl,hl
   rl e
   rl d

   exx

   djnz shift_loop
   
   ld e,a
   ret
