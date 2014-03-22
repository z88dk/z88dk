
XLIB l_divu_24_24x8
XDEF l0_divu_24_24x8, l00_divu_24_24x8

LIB l0_divu_16_16x8, error_divide_by_zero_mc


divu_24_16x8:

   ; hl / c
   
   ld e,c
   jp l0_divu_16_16x8

divide_by_zero:

   ld c,e
   ex de,hl
   
   ld a,$ff
   jp error_divide_by_zero_mc


l_divu_24_24x8:

   ; unsigned division of 24-bit number by 8-bit number
   ;
   ; enter : ehl = 24-bit dividend
   ;           c = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;              d = 0
   ;            ahl = ehl / c
   ;              e = ehl % c
   ;
   ;         divide by zero
   ;
   ;            ahl = $ffffff = UINT_MAX
   ;            cde = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   ; test for divide by zero
   
   inc c
   dec c
   jr z, divide_by_zero

l0_divu_24_24x8:

   ; try to reduce the division
   
   inc e
   dec e
   jr z, divu_24_16x8

l00_divu_24_24x8:

   ; ehl >= $ 01 00 00
   ;   c >= $       01

   xor a
   
   ; unroll divide eight times
   
   ld b,3
   
   ; eliminate leading zeroes

loop_00:

   add hl,hl
   rl e
   jr c, loop_10

   add hl,hl
   rl e
   jr c, loop_20

   add hl,hl
   rl e
   jr c, loop_30

   add hl,hl
   rl e
   jr c, loop_40

   add hl,hl
   rl e
   jr c, loop_50

   add hl,hl
   rl e
   jr c, loop_60

   add hl,hl
   rl e
   jr c, loop_70

   add hl,hl
   rla
   
   cp e
   jr c, loop_80
   
   sub e
   inc l

loop_80:

   dec b

   ; general divide loop
   
loop_0:

   add hl,hl
   rl e

loop_10:

   rla
   
   cp c
   jr c, loop_1
   
   sub c
   inc l

loop_1:

   add hl,hl
   rl e

loop_20:

   rla
   
   cp c
   jr c, loop_2
   
   sub c
   inc l

loop_2:

   add hl,hl
   rl e

loop_30:

   rla
   
   cp c
   jr c, loop_3
   
   sub c
   inc l

loop_3:

   add hl,hl
   rl e

loop_40:

   rla
   
   cp c
   jr c, loop_4
   
   sub c
   inc l

loop_4:

   add hl,hl
   rl e

loop_50:

   rla
   
   cp c
   jr c, loop_5
   
   sub c
   inc l

loop_5:

   add hl,hl
   rl e
   
loop_60:

   rla
   
   cp c
   jr c, loop_6
   
   sub c
   inc l

loop_6:

   add hl,hl
   rl e

loop_70:

   rla
   
   cp c
   jr c, loop_7
   
   sub c
   inc l

loop_7:

   add hl,hl
   rl e
   rla
   
   cp c
   jr c, loop_8
   
   sub c
   inc l

loop_8:

   djnz loop_0

exit_loop:

   ;   a = remainder
   ; ehl = quotient

   ld c,a
   ld a,e
   ld e,c
   ld d,b
   
   or a
   ret
