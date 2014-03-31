
XLIB l_divu_32_32x16
XDEF l0_divu_32_32x16

LIB l0_divu_24_24x16, l0_divu_32_32x8, l_cpl_dehl, error_divide_by_zero_mc


divu_32_24x16:

   ; ehl / bc
   
   call l0_divu_24_24x16
   
   push de

   exx

   pop hl
   ld de,0

   exx

   ld e,a
   ld d,0
   
   ret

divu_32_32x8:

   ; dehl / c
   
   call l0_divu_32_32x8
   
   exx
   
   ld l,a
   xor a
   ld h,a
   ld e,a
   ld d,a
   
   exx
   
   ret

divide_by_zero:

   exx
   
   ld de,$ffff
   jp error_divide_by_zero_mc


l_divu_32_32x16:

   ; unsigned division of 32-bit number
   ; by 16-bit number
   ;
   ; enter : dehl = 32-bit dividend
   ;           bc = 16-bit dividend
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;            dehl'= 16-bit remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses : af, bc, de, hl, bc', de', hl', ixh
   
   ; test for divide by zero
   
   ld a,b
   or c
   jr z, divide_by_zero

l0_divu_32_32x16:

   ; try to reduce the division

   inc b
   dec b
   jr z, divu_32_32x8

   inc d
   dec d
   jr z, divu_32_24x16

   ; dehl >= $ 01 00 00 00
   ;   bc >= $       01 00
   ;
   ; the results of the first eight
   ; iterations of the division loop are known
   ;
   ; inside the loop the computation is
   ; dehl'/ bc, hl = remainder
   ; so initialize as if eight iterations done

   push de
   push hl

   ld h,0
   ld l,d

   exx
   
   pop hl
   pop de
   
   ld d,e
   ld e,h
   ld h,l
   ld l,$ff
   
   exx
   
   ; unroll eight times
   
   ld ixh,3

   ; eliminate leading zeroes

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_000

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_111

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_222

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_333

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_444

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_555

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_666

   scf
   jp loop_7

loop_00:

   or a
   sbc hl,bc
   or a
   jp loop_1

   ; general divide loop

loop_0:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_00

loop_000:

   sbc hl,bc
   jr nc, loop_1
   add hl,bc

loop_1:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_11

loop_111:

   sbc hl,bc
   jr nc, loop_2
   add hl,bc

loop_2:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_22

loop_222:

   sbc hl,bc
   jr nc, loop_3
   add hl,bc

loop_3:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_33

loop_333:

   sbc hl,bc
   jr nc, loop_4
   add hl,bc

loop_4:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_44

loop_444:

   sbc hl,bc
   jr nc, loop_5
   add hl,bc

loop_5:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_55

loop_555:

   sbc hl,bc
   jr nc, loop_6
   add hl,bc

loop_6:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_66

loop_666:

   sbc hl,bc
   jr nc, loop_7
   add hl,bc

loop_7:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   jr c, loop_77
   
   sbc hl,bc
   jr nc, loop_8
   add hl,bc

loop_8:

   dec ixh
   jp nz, loop_0

   ; hl = remainder, dehl'=~quotient with one more shift left

   ld de,0
   
   exx
   
   adc hl,hl
   rl e
   rl d
   
   or a
   jp l_cpl_dehl

loop_11:

   or a
   sbc hl,bc
   or a
   jp loop_2

loop_22:

   or a
   sbc hl,bc
   or a
   jp loop_3

loop_33:

   or a
   sbc hl,bc
   or a
   jp loop_4

loop_44:

   or a
   sbc hl,bc
   or a
   jp loop_5

loop_55:

   or a
   sbc hl,bc
   or a
   jp loop_6

loop_66:

   or a
   sbc hl,bc
   or a
   jp loop_7

loop_77:

   or a
   sbc hl,bc
   or a
   jp loop_8
