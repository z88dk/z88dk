
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_24_24x24, l0_fast_divu_24_24x24

EXTERN l0_fast_divu_16_16x16, l0_fast_divu_24_24x16, error_divide_by_zero_mc


divu_24_16x24:

   ; hl / dbc
   
   inc d
   dec d
   jr nz, result_zero

divu_24_16x16:

   ; hl / bc

   ld e,c
   ld d,b
   
   call l0_fast_divu_16_16x16
   
   ; ahl = quotient
   ;  de = remainder
   
   ld c,a
   ret

divu_24_24x16:

   ; ehl / bc
   
   call l0_fast_divu_24_24x16
   
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


l_fast_divu_24_24x24:

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
   ; uses  : af, bc, de, hl, ixh

   ; test for divide by zero
   
   ld a,d
   or b
   or c
   jr z, divide_by_zero

l0_fast_divu_24_24x24:

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
   ; e[hl']/dbc, ahl = remainder
   ; so initialize as if sixteen iterations done

   ld a,e
   ld e,l
   ld l,h
   ld h,a
   xor a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll divide eight times

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   rl e
   adc hl,hl
   jr c, loop_10
   
   rl e
   inc e
   adc hl,hl
   jr c, loop_20

   rl e
   inc e
   adc hl,hl
   jr c, loop_30
   
   rl e
   inc e
   adc hl,hl
   jr c, loop_40
   
   rl e
   inc e
   adc hl,hl
   jr c, loop_50
   
   rl e
   inc e
   adc hl,hl
   jr c, loop_60
   
   rl e
   inc e
   adc hl,hl
   jr c, loop_70

   scf
   jp loop_7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   rl e
   adc hl,hl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_10:

   rla
   
   sbc hl,bc
   sbc a,d

   jr nc, loop_1
   
   add hl,bc
   adc a,d

loop_1:

   rl e
   adc hl,hl

loop_20:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_2
   
   add hl,bc
   adc a,d

loop_2:

   rl e
   adc hl,hl

loop_30:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_3
   
   add hl,bc
   adc a,d

loop_3:

   rl e
   adc hl,hl

loop_40:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_4
   
   add hl,bc
   adc a,d

loop_4:

   rl e
   adc hl,hl

loop_50:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_5
   
   add hl,bc
   adc a,d

loop_5:

   rl e
   adc hl,hl

loop_60:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_6
   
   add hl,bc
   adc a,d

loop_6:

   rl e
   adc hl,hl

loop_70:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_7
   
   add hl,bc
   adc a,d

loop_7:

   rl e
   adc hl,hl
   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, exit_loop
   
   add hl,bc
   adc a,d

exit_loop:

   ; quotient  = ~e[hl'

   ; remainder =  ahl
   ; one more shift left on quotient

   ex de,hl
   ld c,a
   
   ld a,l
   rla
   cpl
   ld l,a
   
   xor a
   ld h,a

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld ixh,8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   rl e
   inc e
   adc hl,hl
   
   jr c, loop_01
   
   dec ixh
   jp loop_00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   scf

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide

loop_11:

   rl e
   adc hl,hl

loop_01:

   rla
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_02
   
   add hl,bc
   adc a,d

loop_02:

   dec ixh
   jp nz, loop_11

   ; quotient  = ~e[hl'

   ; remainder =  ahl
   ; one more shift left on quotient
   
   ex de,hl
   ld c,a
   
   ld a,l
   rla
   cpl
   ld l,a
   
   xor a
   ld h,a

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
