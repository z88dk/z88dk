
SECTION code_clib
SECTION code_l

PUBLIC l_fast_lsr_dehldehl

EXTERN l_lsr_dehl
EXTERN error_lznc

l_fast_lsr_dehldehl:

   ; logical shift right 64-bit number
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl >> a
   ;
   ; uses  : af, b, de, hl, de', hl'

   or a
   ret z

   sub 32
   jr c, shift_64

   ; shift at least 32 bits
   
   call error_lznc
   
   exx
   
   jp l_lsr_dehl

shift_64:

   add a,32

loop:

   sub 8
   jr c, fine_shift
   
   ld b,a
   
   exx
   
   ld a,l
   ld l,h
   ld h,e
   ld e,d
   ld d,0
   
   exx
   
   ld l,h
   ld h,e
   ld e,d
   ld d,a
   
   ld a,b
   jr loop

fine_shift:

   add a,8
   ret z
   
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
