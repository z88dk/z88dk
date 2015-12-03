
SECTION code_clib
SECTION code_math

PUBLIC l_fast_divs_32_32x32, l0_fast_divs_32_32x32

EXTERN l0_fast_divu_32_32x32, l_neg_dehl, error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor
   
   exx

l_fast_divs_32_32x32:

   ; signed division of two 32-bit numbers
   ;
   ; enter : dehl'= 32-bit dividend
   ;         dehl = 32-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;            dehl'= 32-bit remainder
   ;
   ;         divide by zero
   ;
   ;            dehl = LONG_MAX or LONG_MIN
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc. de. hl, bc', de', hl', ixh

   ; test for divide by zero
   
   ld a,d
   or e
   or h
   or l
   jr z, divide_by_zero
   
l0_fast_divs_32_32x32:

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
   
   call l0_fast_divu_32_32x32

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
