
SECTION code_clib
SECTION code_math

PUBLIC l_fast_divs_16_16x16, l0_fast_divs_16_16x16

EXTERN l0_fast_divu_16_16x16, error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor

   ex de,hl

l_fast_divs_16_16x16:

   ; signed division of two 16-bit numbers
   ;
   ; enter : hl = 16-bit dividend
   ;         de = 16-bit divisor
   ;
   ; exit  : success
   ;
   ;            hl = hl / de
   ;            de = hl % de
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

l0_fast_divs_16_16x16:

   ; C standard requires that the result of division satisfy
   ; a = (a/b)*b + a%b
   ; remainder takes sign of the dividend

   ld b,h                      ; b = MSB of dividend
   ld c,d                      ; c = MSB of divisor
   
   push bc                     ; save sign info

   ld a,h
   rla
   jr nc, dividend_ok

   xor a
   sub l
   ld l,a
   sbc a,a
   sub h
   ld h,a                      ; take absolute value of dividend

dividend_ok:

   ld a,d
   rla
   jr nc, divisor_ok
   
   xor a
   sub e
   ld e,a
   sbc a,a
   sub d
   ld d,a                      ; take absolute value of divisor

divisor_ok:

   ; perform unsigned division
   
   call l0_fast_divu_16_16x16
   
   ; hl = unsigned quotient
   ; de = unsigned remainder
   
   pop bc                      ; bc = sign info
   
   ld a,b
   xor c
   jp p, quotient_ok
   
   xor a
   sub l
   ld l,a
   sbc a,a
   sub h
   ld h,a                      ; negate quotient if signs differ
   or a

quotient_ok:
   
   bit 7,b
   ret z                       ; if dividend > 0
   
   xor a
   sub e
   ld e,a
   sbc a,a
   sub d
   ld d,a                      ; make remainder negative

   or a
   ret
   
divide_by_zero:

   ex de,hl                      ; de = dividend

   call error_divide_by_zero_mc
   ld h,$7f                      ; hl = INT_MAX
   
   bit 7,d
   ret z                       ; if dividend > 0
   
   inc hl                      ; hl = INT_MIN
   ret
