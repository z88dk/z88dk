
XLIB l_divu_32_32x32
XDEF l0_divu_32_32x32

LIB error_divide_by_zero_mc

l_divu_32_32x32:

   ; enter :  dehl = 32-bit divisor
   ;         stack = 32-bit dividend, return address
   ;
   ; exit  :   dehl = stack / dehl (quotient -- $ffffffff if divide by 0)
   ;         de'hl' = stack % dehl (remainder -- dividend if divide by zero)
   ;         on divide by zero, carry set and errno=EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld a,d
   or e
   or h
   or l
   jr z, divide_zero

l0_divu_32_32x32:

   ; enter :  dehl = 32-bit divisor
   ;         stack = 32-bit dividend, return address
   ;         (no divide by zero check!)
   ;
   ; exit  :   dehl = stack / dehl (quotient)
   ;         de'hl' = stack % dehl (remainder)
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af                      ; return address
   
   push hl
   exx
   pop de
   pop bc
   ld hl,0
   exx
   ld hl,0
   pop bc
   
   push af                     ; save return address
   
   ; dede' = 32-bit divisor
   ; bcbc' = 32-bit dividend
   ; hlhl' = result

   ld a,32
   or a

div1:

   exx                         ; dividend <<= 1
   rl c
   rl b
   exx
   rl c
   rl b
   
   exx                         ; result <<= 1
   adc hl,hl
   exx
   adc hl,hl
   
   exx                         ; result -= dividend
   sbc hl,de
   exx
   sbc hl,de
   jr nc, div2

   exx                         ; result += divisor
   add hl,de
   exx
   adc hl,de

div2:

   ccf
   dec a
   jp nz, div1

   exx                         ; dividend <<= 1
   rl c
   rl b
   exx
   rl c
   rl b

   ; looking to return:
   ;
   ;  dehl  =  quotient = bcbc'
   ; de'hl' = remainder = hlhl'
   
   push hl
   exx
   pop de
   push bc
   exx
   pop hl
   ld e,c
   ld d,b
   
   or a
   ret


divide_zero:

   ;  dehl = 0
   ; stack = 32-bit dividend, return address

   pop af
   exx
   pop hl
   pop de
   exx
   push af
   
   dec de
   jp error_divide_by_zero_mc
