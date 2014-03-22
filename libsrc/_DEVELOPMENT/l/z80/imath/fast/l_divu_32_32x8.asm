
XLIB l_divu_32_32x8
XDEF l0_divu_32_32x8

LIB l0_divu_24_24x8, error_divide_by_zero_mc


divu_32_24x8:

   ; ehl / c
   
   call l0_divu_24_24x8
   
   ld c,a
   ld a,e
   ld e,c
   
   ret

divide_by_zero:

   exx
   
   ld de,$ffff
   jp error_divide_by_zero_mc


l_divu_32_32x8:

   ; unsigned division of a 32-bit number
   ; by an 8-bit number
   ;
   ; enter : dehl = 32-bit dividend
   ;            c = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;               a = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; test for divide by zero

   inc c
   dec c
   jr z, divide_by_zero

l0_divu_32_32x8:

   ; uses  : af, bc, de, hl

   ; try to reduce the division

   inc d
   dec d
   jr z, divu_32_24x8

   ; dehl >= $ 01 00 00 00
   ;    c >= $          01

   xor a
   
   ; unroll divide eight times
   
   ld b,3

   ; eliminate leading zeroes

loop_00:

   add hl,hl
   rl e
   rl d
   jr c, loop_10

   add hl,hl
   rl e
   rl d
   jr c, loop_20

   add hl,hl
   rl e
   rl d
   jr c, loop_30

   add hl,hl
   rl e
   rl d
   jr c, loop_40

   add hl,hl
   rl e
   rl d
   jr c, loop_50

   add hl,hl
   rl e
   rl d
   jr c, loop_60

   add hl,hl
   rl e
   rl d
   jr c, loop_70

   add hl,hl
   rl e
   rl d
   rla
   
   cp c
   jr c, loop_80
   
   sub c
   inc l

loop_80:

   dec b
   
   ; general divide loop

loop_0:

   add hl,hl
   rl e
   rl d

loop_10:

   rla
   
   cp c
   jr c, loop_1
   
   sub c
   inc l

loop_1:

   add hl,hl
   rl e
   rl d

loop_20:

   rla
   
   cp c
   jr c, loop_2
   
   sub c
   inc l

loop_2:

   add hl,hl
   rl e
   rl d

loop_30:

   rla
   
   cp c
   jr c, loop_3
   
   sub c
   inc l

loop_3:

   add hl,hl
   rl e
   rl d

loop_40:

   rla
   
   cp c
   jr c, loop_4
   
   sub c
   inc l

loop_4:

   add hl,hl
   rl e
   rl d

loop_50:

   rla
   
   cp c
   jr c, loop_5
   
   sub c
   inc l

loop_5:

   add hl,hl
   rl e
   rl d

loop_60:

   rla
   
   cp c
   jr c, loop_6
   
   sub c
   inc l

loop_6:

   add hl,hl
   rl e
   rl d

loop_70:

   rla
   
   cp c
   jr c, loop_7
   
   sub c
   inc l

loop_7:

   add hl,hl
   rl e
   rl d
   rla
   
   cp c
   jr c, loop_8
   
   sub c
   inc l

loop_8:

   djnz loop_0

   or a
   ret
