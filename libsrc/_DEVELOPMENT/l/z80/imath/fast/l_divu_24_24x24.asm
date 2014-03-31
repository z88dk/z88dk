
XLIB l_divu_24_24x24
XDEF l0_divu_24_24x24

LIB l0_divu_16_16x16, l0_divu_24_24x16, error_divide_by_zero_mc


divu_24_16x24:

   ; hl / dbc
   
   inc d
   dec d
   jr nz, result_zero

divu_24_16x16:

   ; hl / bc

   ld e,c
   ld d,b
   
   call l0_divu_16_16x16
   
   ; ahl = quotient
   ;  de = remainder
   
   ld c,a
   ret

divu_24_24x16:

   ; ehl / bc
   
   call l0_divu_24_24x16
   
   ; ahl = quotient
   ;  de = remainder
   
   ld c,0
   ret

result_zero:

   ; dividend < divisor
   
   ld c,e
   ex de,hl
   
   xor a
   ld l,a
   ld h,a
   
   ret

divide_by_zero:

   ld c,e
   ex de,hl
   
   ld a,$ff
   jp error_divide_by_zero_mc


l_divu_24_24x24:

   ; unsigned division of two 24-bit numbers
   ;
   ; enter : ehl = 24-bit dividend
   ;         dbc = 24-bit divisor
   ;
   ; exit  : success
   ;
   ;            ahl = 24-bit quotient
   ;            cde = 24-bit remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            ahl = $ffffff = UINT_MAX
   ;            cde = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ixh

   ; test for divide by zero
   
   ld a,d
   or b
   or c
   jr z, divide_by_zero

l0_divu_24_24x24:

   ; try to reduce the division
   
   inc e
   dec e
   jr z, divu_24_16x24
   
   inc d
   dec d
   jr z, divu_24_24x16

   ; ehl >= $ 01 00 00
   ; dbc >= $ 01 00 00
   
   ; check divisor size
   
   ld a,e
   cp d
   jr c, result_zero
   
   jp nz, begin
   
   ld a,h
   cp b
   jr c, result_zero
   
   jp nz, begin
   
   ld a,l
   cp c
   jr c, result_zero

begin:

   ; ehl >= dbc
   ; ehl >= $ 01 00 00
   ; dbc >= $ 01 00 00
   ;
   ; max quotient is 255
   ;
   ; this means the results of the first sixteen
   ; iterations of the division loop are known
   ;
   ; inside the loop the computation is
   ; ehl'/dbc, ahl = remainder
   ; so initialize as if sixteen iterations done
   
   ld a,l
   exx
   ld e,a
   ld hl,$ffff
   exx
   ld l,h
   ld h,e
   xor a

   ; unroll divide eight times
   
   ; eliminate leading zeroes

loop_00:

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_10

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_20

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_30

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_40

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_50

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_60

   exx
   add hl,hl
   inc l
   rl e
   exx
   adc hl,hl
   
   jr c, loop_70

   scf
   jp loop_7

   ; general divide loop

loop_10:

   rla
   
   sbc hl,bc
   sbc a,d

   jr nc, loop_1
   
   add hl,bc
   adc a,d

loop_1:

   exx

   adc hl,hl
   rl e
   
   exx
   
   adc hl,hl

loop_20:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_2
   
   add hl,bc
   adc a,d

loop_2:

   exx

   adc hl,hl
   rl e
   
   exx
   
   adc hl,hl

loop_30:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_3
   
   add hl,bc
   adc a,d

loop_3:

   exx

   adc hl,hl
   rl e
   
   exx
   
   adc hl,hl

loop_40:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_4
   
   add hl,bc
   adc a,d

loop_4:

   exx

   adc hl,hl
   rl e
   
   exx
   
   adc hl,hl

loop_50:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_5
   
   add hl,bc
   adc a,d

loop_5:

   exx

   adc hl,hl
   rl e
   
   exx
   
   adc hl,hl

loop_60:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_6
   
   add hl,bc
   adc a,d

loop_6:

   exx

   adc hl,hl
   rl e
   
   exx
   
   adc hl,hl

loop_70:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_7
   
   add hl,bc
   adc a,d

loop_7:

   exx

   adc hl,hl
   rl e

loop_80:

   exx
   
   adc hl,hl
   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, exit_loop
   
   add hl,bc
   adc a,d

exit_loop:

   ; quotient  = ~ehl'
   ; remainder =  ahl
   ; one more shift left on quotient
   
   push af
   push hl
   
   exx
   
   adc hl,hl
   
   ld a,l
   cpl
   ld l,a
   ld a,h
   cpl
   ld h,a
   
   ld a,e
   rla
   cpl
   
   pop de
   pop bc
   ld c,b
   
   or a
   ret
