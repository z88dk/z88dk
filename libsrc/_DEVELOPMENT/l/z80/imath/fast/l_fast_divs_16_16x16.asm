
XLIB l_fast_divs_16_16x16
XDEF l0_fast_divs_16_16x16

LIB l_neg_hl, l_neg_de
LIB l0_fast_divu_16_16x16, error_divide_by_zero_mc

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
   
   bit 7,h
   call nz, l_neg_hl           ; take absolute value of dividend
   
   bit 7,d
   call nz, l_neg_de           ; take absolute value of divisor

   ; perform unsigned division
   
   call l0_fast_divu_16_16x16
   
   ; hl = unsigned quotient
   ; de = unsigned remainder
   
   pop bc                      ; bc = sign info
   
   ld a,b
   xor c
   call m, l_neg_hl            ; negate quotient if signs differ
   
   bit 7,b
   ret z                       ; if dividend > 0
   
   jp l_neg_de                 ; make remainder negative

divide_by_zero:

   ex de,hl                      ; de = dividend

   call error_divide_by_zero_mc
   ld h,$7f                      ; hl = INT_MAX
   
   bit 7,d
   ret z                       ; if dividend > 0
   
   inc hl                      ; hl = INT_MIN
   ret
