
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_divu_16_16x8, l0_kc160_divu_16_16x8

EXTERN error_divide_by_zero_mc

   ex de,hl

l_kc160_divu_16_16x8:

   ; unsigned division of 16-bit by 8-bit
   ;
   ; enter : hl = 16-bit dividend
   ;          e = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;            hl = quotient
   ;            de = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            hl = $ffff = UINT_MAX
   ;            de = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   inc e
   dec e
   jr z, divide_zero

l0_kc160_divu_16_16x8:
   ld a,e
   div hl,a
   ld e,h
   ld d,0
   ld h,0
   and a
   ret

divide_zero:

   ex de,hl
   jp error_divide_by_zero_mc
