
; 2016 aralbrec

SECTION code_clib
SECTION code_math

PUBLIC l_small_divu_64_64x64

EXTERN l_setmem_hl, error_divide_by_zero_mc
EXTERN l0_fast_divu_32_32x32

l_small_divu_64_64x64:

   ; unsigned 64-bit division
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
   ;                 | + 0  0xffffffff
   ;                 +------------------------
   ;
   ;            dehl' dehl = dividend
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
 
   ld b,(ix+13)
   ld c,(ix+12)
   
   ld a,b
   or c
   or (ix+15)
   or (ix+14)
   
   jr nz, m_64_bit             ; if MS32(divisor) != 0
   
   ld a,(ix+7)
   or (ix+6)
   or (ix+5)
   or (ix+4)
   
   jp z, m_32_bit              ; if MS32(dividend) == 0
   
   ld a,(ix+11)
   or (ix+10)
   or (ix+9)
   or (ix+8)
   
   jp z, divide_by_zero        ; if divisor == 0
   
m_64_bit:

   xor a
   ld l,a
   ld h,a
   ld e,a
   ld d,a
   
   exx
      
   ld l,a
   ld h,a
   ld e,a
   ld d,a

   ld b,(ix+9)
   ld c,(ix+8)

   ; divisor:
   ;   ix+15, ix+14, b', c', ix+11, ix+10, b, c
   ; dividend:
   ;   ix+7, ix+6, ix+5, ix+4, ix+3, ix+2, ix+1, ix+0
   ; remainder:
   ;   d', e', h', l', d, e, h, l = 0

   ld a,64

loop_0:

   ex af,af'                   ; save loop count

   ; rotate dividend left, quotient bit in
   
   rl (ix+0)
   rl (ix+1)
   rl (ix+2)
   rl (ix+3)
   rl (ix+4)
   rl (ix+5)
   rl (ix+6)
   rl (ix+7)
   
   ; rotate remainder left, dividend bit in

   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   rl e
   rl d
   exx
   
   ; remainder > divisor ?

   sbc hl,bc
   ld a,e
   sbc a,(ix+10)
   ld e,a
   ld a,d
   sbc a,(ix+11)
   ld d,a
   exx
   sbc hl,bc
   ld a,e
   sbc a,(ix+14)
   ld e,a
   ld a,d
   sbc a,(ix+15)
   ld d,a
   exx
   
   jr nc, loop_1
   
   ; no, undo subtraction

   add hl,bc
   ld a,e
   adc a,(ix+10)
   ld e,a
   ld a,d
   adc a,(ix+11)
   ld d,a
   exx
   adc hl,bc
   ld a,e
   adc a,(ix+14)
   ld e,a
   ld a,d
   adc a,(ix+15)
   ld d,a
   exx

loop_1:

   ccf
   ex af,af'                   ; restore loop count

   dec a
   jr nz, loop_0
   
   ; rotate quotient left one more time
   
   ex af,af'

   rl (ix+0)
   rl (ix+1)
   rl (ix+2)
   rl (ix+3)
   rl (ix+4)
   rl (ix+5)
   rl (ix+6)
   rl (ix+7)
 
   or a
   ret

m_32_bit:

   ld d,(ix+3)
   ld e,(ix+2)
   ld h,(ix+1)
   ld l,(ix+0)
   
   exx

   ld d,(ix+11)
   ld e,(ix+10)
   ld h,(ix+9)
   ld l,(ix+8)
   
   ld a,d
   or e
   or h
   or l
   
   jr z, divide_by_zero

   ; dehl = divisor
   ; dehl'= dividend
   
   push ix
   call l0_fast_divu_32_32x32
   pop ix
   
   ; dehl = quotient
   ; dehl'= remainder
   
   ld (ix+0),l
   ld (ix+1),h
   ld (ix+2),e
   ld (ix+3),d
   
   xor a
   
   ld l,a
   ld h,a
   ld e,a
   ld d,a
   
   exx
   ret
  
divide_by_zero:

   ld d,(ix+7)
   ld e,(ix+6)
   ld h,(ix+5)
   ld l,(ix+4)

   exx
   
   ld b,(ix+3)
   ld c,(ix+2)
   ld d,(ix+1)
   ld e,(ix+0)
   
   call error_divide_by_zero_mc
   
   ld a,l
   
   push ix
   pop hl
   
   call l_setmem_hl - 16
   
   ex de,hl
   ld e,c
   ld d,b
   
   ret
