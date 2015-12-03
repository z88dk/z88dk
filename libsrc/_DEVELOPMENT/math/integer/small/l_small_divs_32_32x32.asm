
SECTION code_clib
SECTION code_math

PUBLIC l_small_divs_32_32x32, l0_small_divs_32_32x32

EXTERN l_neg_dehl, l0_small_divu_32_32x32, error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor
   
   exx

l_small_divs_32_32x32:

   ; signed division of 32-bit numbers
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
   ;            dehl = LONG_MAX or LONG_MIN
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,d
   or e
   or h
   or l
   jr z, divide_by_zero

l0_small_divs_32_32x32:

   ; C standard requires that the result of division satisfy
   ; a = (a/b)*b + a%b
   ; remainder takes sign of the dividend

   ld a,d
   
   exx
   
   ld b,d                      ; b = MSB of dividend
   ld c,a                      ; c = MSB of divisor
   
   push bc                     ; save sign info

   bit 7,d
   call nz, l_neg_dehl         ; take absolute value of dividend

   exx

   bit 7,d
   call nz, l_neg_dehl         ; take absolute value of divisor

   ; perform unsigned division

   call l0_small_divu_32_32x32

   ; dehl = unsigned quotient
   ; dehl'= unsigned remainder

   pop bc                      ; bc = sign info
   
   ld a,b
   xor c
   call m, l_neg_dehl          ; negate quotient if signs different
   
   bit 7,b
   ret z                       ; if dividend > 0

   exx
   call l_neg_dehl             ; make remainder negative
   exx
   
   ret

divide_by_zero:

   ; result is
   ; dehl'= remainder = dividend
   ; dehl = LONG_MAX or LONG_MIN depending on sign of dividend
   
   ld de,$7fff
   call error_divide_by_zero_mc  ; dehl = LONG_MAX
   
   exx
   bit 7,d
   exx

   ret z                         ; if dividend positive
   
   inc de
   inc hl                        ; dehl = LONG_MIN
   
   ret
