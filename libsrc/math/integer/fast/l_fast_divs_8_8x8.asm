
SECTION code_clib
SECTION code_math

PUBLIC l_fast_divs_8_8x8, l0_fast_divs_8_8x8

EXTERN l0_fast_divu_8_8x8, error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor
   
   ex de,hl

l_fast_divs_8_8x8:

   ; signed division of two 8-bit numbers
   ;
   ; enter : l = 8-bit dividend
   ;         e = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;            l = l / e
   ;            e = l % e
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;             l = CHAR_MAX or CHAR_MIN
   ;             e = dividend
   ;             carry set, errno = EDOM
   ;
   ; uses  : af, b, de, hl

   ; test for divide by zero
   
   inc e
   dec e
   jr z, divide_by_zero

l0_fast_divs_8_8x8:

   ; C standard requires that the result of division satisfy
   ; a = (a/b)*b + a%b
   ; remainder takes sign of the dividend

   ld a,l
   xor e                       ; P flag set if quotient > 0
   ld a,l                      ; a = dividend
   
   push af                     ; save sign info

   or a
   jp p, dividend_ok

   neg
   ld l,a                      ; take absolute value of dividend

dividend_ok:

   ld a,e
   or a
   jp p, divisor_ok

   neg
   ld e,a                      ; take absolute value of divisor

divisor_ok:

   ; perform unsigned division
   
   call l0_fast_divu_8_8x8
   
   ; l = unsigned quotient
   ; e = unsigned remainder
   
   pop af                      ; recover sign info
   ld d,a                      ; d = dividend

   jp p, quotient_ok           ; if quotient > 0
   
   ld a,l
   neg
   ld l,a                      ; negate quotient

quotient_ok:

   bit 7,d
   ret z                       ; if dividend > 0
   
   ld a,e
   neg
   ld e,a                      ; negate remainder
   
   ret

divide_by_zero:

   ld e,l                      ; e = dividend
   
   call error_divide_by_zero_mc
   ld l,$80                      ; hl = CHAR_MIN
   
   bit 7,e
   ret nz                      ; if dividend < 0
   
   inc h
   dec l                       ; hl = CHAR_MAX
   
   ret
