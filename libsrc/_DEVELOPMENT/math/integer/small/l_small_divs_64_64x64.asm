
; 2016 aralbrec

SECTION code_clib
SECTION code_math

PUBLIC l_small_divs_64_64x64

EXTERN error_divide_by_zero_mc, l_offset_ix_de
EXTERN l_neg_64_mhl, l_neg_64_dehldehl
EXTERN l_small_divu_64_64x64, l_setmem_hl

l_small_divs_64_64x64:

   ; signed 64-bit division
   ;
   ; enter :      +------------------------
   ;              | +15 
   ;              | ...  divisor (8 bytes)
   ;              | + 8 
   ;         ix = |------------------------
   ;              | + 7
   ;              | ...  dividend (8 bytes)
   ;              | + 0
   ;              +------------------------
   ;
   ; exit  : success
   ;
   ;                 +------------------------
   ;                 | +15 
   ;                 | ...  divisor (8 bytes)
   ;                 | + 8 
   ;            ix = |------------------------
   ;                 | + 7
   ;                 | ...  quotient (8 bytes)
   ;                 | + 0
   ;                 +------------------------
   ;
   ;            dehl' dehl = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;                 +------------------------
   ;                 | +15 
   ;                 | ...  divisor (8 bytes)
   ;                 | + 8 
   ;            ix = |------------------------
   ;                 | + 7
   ;                 | ...  quotient(8 bytes)
   ;                 | + 0  LONGLONG_MAX or LONGLONG_MIN
   ;                 +------------------------
   ;
   ;            dehl' dehl = dividend
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld b,(ix+7)                 ; b = MSB of dividend
   ld c,(ix+15)                ; c = MSB of divisor
   
   ld a,c
   or (ix+14)
   or (ix+13)
   or (ix+12)
   or (ix+11)
   or (ix+10)
   or (ix+9)
   or (ix+8)
   
   jr z, divide_by_zero

   push bc                     ; save sign info
   
   bit 7,b
   jr z, dividend_positive

   ; take absolute value of dividend
   
   push ix
   pop hl                      ; hl = & dividend
   
   call l_neg_64_mhl
   
dividend_positive:

   bit 7,c
   jr z, divisor_positive

   ; take absolute value of divisor
   
   ld hl,8
   call l_offset_ix_de         ; hl = & divisor
   
   call l_neg_64_mhl

divisor_positive:

   ; perform unsigned division
   
   call l_small_divu_64_64x64
   
   ; dehl dehl' = remainder
   
   pop bc                      ; bc = sign info
   
   ld a,b
   xor c
   
   jp p, quotient_positive
   
   ; negate quotient
   
   push ix
   ex (sp),hl
   
   call l_neg_64_mhl
   
   pop hl

quotient_positive:

   bit 7,b
   ret z                       ; if dividend > 0
   
   ; negate remainder
   
   jp l_neg_64_dehldehl

divide_by_zero:

   call error_divide_by_zero_mc

   ld d,(ix+7)
   ld e,(ix+6)
   ld h,(ix+5)
   ld l,(ix+4)

   bit 7,d
   
   exx
   
   ld b,(ix+3)
   ld c,(ix+2)
   ld d,(ix+1)
   ld e,(ix+0)

   push ix
   pop hl
   
   jr z, pos_inf

neg_inf:

   ld a,0
   call l_setmem_hl - 14
   
   ld (hl),0x80
   jr exit

pos_inf:

   ld a,0xff
   call l_setmem_hl - 14

   ld (hl),0x7f
   
exit:

   ex de,hl
   ld e,c
   ld d,b
   
   ret
