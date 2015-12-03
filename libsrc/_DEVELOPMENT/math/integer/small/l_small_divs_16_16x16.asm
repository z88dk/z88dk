
SECTION code_clib
SECTION code_math

PUBLIC l_small_divs_16_16x16, l0_small_divs_16_16x16

EXTERN l_neg_hl, l_neg_de
EXTERN l0_small_divu_16_16x16, error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor

   ex de,hl
   
l_small_divs_16_16x16:

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

l0_small_divs_16_16x16:

   ; C standard requires that the result of division satisfy
   ; a = (a/b)*b + a%b
   ; remainder takes sign of the dividend

   ld b,h                      ; b = MSB of dividend
   ld c,d                      ; c = MSB of divisor
   
   push bc                     ; save sign info

   bit 7,h
   call nz, l_neg_hl           ; take absolute value of dividend

   bit 7,d
   call nz, l_neg_de           ; take absolute value of divisor

   ; perform unsigned division
   
   call l0_small_divu_16_16x16
   
   ; hl = unsigned quotient
   ; de = unsigned remainder
   
   pop bc                      ; bc = sign info
   
   ld a,b
   xor c
   jp m, l_neg_hl              ; negate quotient
   
   bit 7,b
   ret z                       ; if dividend was positive
   
   jp l_neg_de                 ; negate remainder

divide_by_zero:

   ex de,hl                      ; de = dividend

   call error_divide_by_zero_mc
   ld h,$7f                      ; hl = INT_MAX
   
   bit 7,d
   ret z                       ; if dividend > 0
   
   inc hl                      ; hl = INT_MIN
   ret
