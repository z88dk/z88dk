
SECTION code_clib
SECTION code_l

PUBLIC l_fast_lsl_dehldehl

EXTERN l_lsl_dehl
EXTERN error_lznc

l_fast_lsl_dehldehl:

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

   sub 32
   jr c, shift_64

   ; shift at least 32 bits
   
   call l_lsl_dehl
   
   exx
   jp error_lznc

shift_64:

   add a,32

loop:

   sub 8
   jr c, fine_shift
   
   ld b,a
   ld a,d
   
   exx
   
   ld d,e
   ld e,h
   ld h,l
   ld l,a
   
   exx
   
   ld d,e
   ld e,h
   ld h,l
   ld l,0
   
   ld a,b
   jr loop

fine_shift:

   add a,8
   ret z
   
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
