
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_divs_16_16x16, l0_kc160_divs_16_16x16
EXTERN error_divide_by_zero_mc


   ; alternate entry to swap dividend / divisor

   ex de,hl
   
l_kc160_divs_16_16x16:

   ; signed division of two 16-bit numbers
   ;
   ; enter : hl = 16-bit dividend
   ;         de = 16-bit divisor
   ;
   ; exit  : success
   ;
   ;            hl = quotient
   ;            de = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            hl = INT_MAX or INT_MIN
   ;            de = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   ; test for divide by zero
   
   ld a,d
   or e
   jr z, divide_by_zero

l0_kc160_divs_16_16x16:
   ld bc,de
   ld a,h
   rlca
   sbc a
   ld e,a
   ld d,a
   divs dehl,bc
   and  a
   ret

divide_by_zero:

   ex de,hl                      ; de = dividend

   call error_divide_by_zero_mc
   ld h,$7f                      ; hl = INT_MAX

   bit 7,d
   ret z                       ; if dividend > 0

   inc hl                      ; hl = INT_MIN
   ret
