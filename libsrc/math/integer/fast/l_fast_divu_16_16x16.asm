
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_16_16x16, l0_fast_divu_16_16x16

EXTERN l0_fast_divu_16_16x8, error_divide_by_zero_mc

   ; alternate entry to swap dividend / divisor

   ex de,hl

l_fast_divu_16_16x16:

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

l0_fast_divu_16_16x16:

   ; try to reduce the division
   
   inc d
   dec d
   jp z, l0_fast_divu_16_16x8
   
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
   ; a[c] / de, hl = remainder
   ; so initialize as if eight iterations done
   
   ld a,l   
   ld l,h
   ld h,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll divide eight times

   ; eliminating leading zeroes is only marginal

   ; general divide loop

loop_0:

   rla
   adc hl,hl

loop_00:

   sbc hl,de
   jr nc, loop_1
   add hl,de

loop_1:

   rla
   adc hl,hl

loop_11:

   sbc hl,de
   jr nc, loop_2
   add hl,de

loop_2:

   rla
   adc hl,hl

loop_22:

   sbc hl,de
   jr nc, loop_3
   add hl,de

loop_3:

   rla
   adc hl,hl

loop_33:

   sbc hl,de
   jr nc, loop_4
   add hl,de

loop_4:

   rla
   adc hl,hl

loop_44:

   sbc hl,de
   jr nc, loop_5
   add hl,de

loop_5:

   rla
   adc hl,hl

loop_55:

   sbc hl,de
   jr nc, loop_6
   add hl,de

loop_6:

   rla
   adc hl,hl

loop_66:

   sbc hl,de
   jr nc, loop_7
   add hl,de

loop_7:

   rla
   adc hl,hl

loop_77:

   sbc hl,de
   jr nc, exit_loop
   add hl,de

exit_loop:

   rla
   
   ; a = ~quotient, hl = remainder

   cpl
   ld e,a
   xor a
   ld d,a

   ex de,hl
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld b,8
   
   ; eliminating leading zeroes is marginal
   
   ; general divide loop

loop_11:

   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_02
   add hl,de

loop_02:

   djnz loop_11

   rla
   
   ; a = ~quotient, hl = remainder

   cpl
   ld e,a
   ld d,b   
   ex de,hl
   
   xor a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
