
; 2000 djm
; 2007 aralbrec - use bcbc' rather than bytes indexed by ix per djm suggestion

SECTION code_clib
SECTION code_math

PUBLIC l_small_divu_32_32x32
PUBLIC l0_small_divu_32_32x32,  l1_small_divu_32_32x32

EXTERN error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor
   
   exx

l_small_divu_32_32x32:

   ; unsigned division of 32-bit numbers
   ;
   ; enter : dehl = 32-bit divisor
   ;         dehl'= 32-bit dividend
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;            dehl'= 32-bit remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,d
   or e
   or h
   or l
   jr z, divide_zero  

l0_small_divu_32_32x32:

   xor a
   push hl
   exx
   ld c,l
   ld b,h
   pop hl
   push de
   ex de,hl
   ld l,a
   ld h,a
   exx
   pop bc
   ld l,a
   ld h,a

 l1_small_divu_32_32x32:
   
   ; dede' = 32-bit divisor
   ; bcbc' = 32-bit dividend
   ; hlhl' = 0

   ld a,b
   ld b,32

loop_0:

   exx
   rl c
   rl b
   exx
   rl c
   rla
   
   exx
   adc hl,hl
   exx
   adc hl,hl
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   jr nc, loop_1

   exx
   add hl,de
   exx
   adc hl,de

loop_1:

   ccf
   djnz loop_0

   exx
   rl c
   rl b
   exx
   rl c
   rla

   ; quotient  = acbc'
   ; remainder = hlhl'
   
   push hl
   exx
   pop de
   push bc
   exx
   pop hl
   ld e,c
   ld d,a
   
   ret

divide_zero:
   
   dec de
   jp error_divide_by_zero_mc
