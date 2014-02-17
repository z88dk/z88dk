
XLIB l_divu_16_16x16
XDEF l0_divu_16_16x16

LIB l0_divu_16_16x8, error_divide_by_zero_mc

l_divu_16_16x16:

   ; unsigned division of two 16-bit numbers
   ;
   ; enter : hl = 16-bit dividend
   ;         de = 16-bit divisor
   ;
   ; exit  : success
   ;
   ;             a = 0
   ;            hl = hl / de
   ;            de = hl % de
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            hl = $ffff = UINT_MAX
   ;            de = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   ; test for divide by zero
   
   ld a,d
   or e
   jr z, divide_by_zero

l0_divu_16_16x16:

   ; try to reduce the division
   
   inc d
   dec d
   jp z, l0_divu_16_16x8
   
   ; check divisor size
   
   ld a,h
   cp d
   jr c, result_zero
   
   jp nz, begin

   ld a,l
   cp e
   jr c, result_zero

begin:

   ; hl >= de
   ; hl >= $ 01 00
   ; de >= $ 01 00
   ;
   ; max quotient is 255
   ;
   ; this means the results of the first eight
   ; iterations of the division loop are known
   ;
   ; inside the loop the computation is
   ; ac / de, hl = remainder
   ; so initialize as if eight iterations done
   
   ld a,l
   ld c,$ff
   
   ld l,h
   ld h,0
   
   ; unroll divide eight times
   
   scf

   ; eliminating zeroes is not much faster than division loop
   
   ; general divide loop

loop_0:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_1
   add hl,de

loop_1:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_2
   add hl,de

loop_2:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_3
   add hl,de

loop_3:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_4
   add hl,de

loop_4:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_5
   add hl,de

loop_5:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_6
   add hl,de

loop_6:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_7
   add hl,de

loop_7:

   rl c
   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, exit_loop
   add hl,de

exit_loop:

   rl c
   rla
   
   ; ac = ~quotient, hl = remainder

   cpl
   ld d,a
   
   ld a,c
   cpl
   ld e,a
   
   ex de,hl
   
   xor a
   ret

result_zero:

   ; dividend < divisor
   
   xor a
   ld e,a
   ld d,a
   
   ex de,hl
   ret

divide_by_zero:

   ex de,hl
   jp error_divide_by_zero_mc
