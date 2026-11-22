
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_24_24x16, l0_fast_divu_24_24x16

EXTERN l0_fast_divu_16_16x16, l00_fast_divu_24_24x8, error_divide_by_zero_mc


divu_24_16x16:

   ; hl / bc

   ld e,c
   ld d,b
   
   jp l0_fast_divu_16_16x16

divide_by_zero:

   ld c,e
   ex de,hl
   
   ld a,$ff
   jp error_divide_by_zero_mc

l_fast_divu_24_24x16:

   ; unsigned division of 24-bit number by 16-bit number
   ;
   ; enter : ehl = 24-bit dividend
   ;          bc = 16-bit divisor
   ;
   ; exit  : success
   ;
   ;            ahl = ehl / bc
   ;             de = ehl % bc
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            ahl = $fffff = UINT_MAX
   ;            cde = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   ; test for divide by zero
   
   ld a,b
   or c
   jr z, divide_by_zero

l0_fast_divu_24_24x16:

   ; try to reduce the division
   
   inc e
   dec e
   jr z, divu_24_16x16

   inc b
   dec b
   jp z, l00_fast_divu_24_24x8

   ; ehl >= $ 01 00 00
   ;  bc >= $    01 00
   ;
   ; this means the results of the first eight
   ; iterations of the division loop are known
   ;
   ; inside the loop the computation is
   ; ac[b] / de, hl = remainder
   ; so initialize as if eight iterations done

   ld d,b
   ld a,e
   ld e,c
   ld c,l
   ld l,a
   ld a,h
   ld h,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll divide eight times

   ld b,2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02
   
   ; eliminating leading zeroes

   rl c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_00

   rl c
   inc c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_11
   
   rl c
   inc c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_22
   
   rl c
   inc c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_33
   
   rl c
   inc c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_44
   
   rl c
   inc c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_55   
   
   rl c
   inc c
   rla
   adc hl,hl
   inc h
   dec h
   jr nz, loop_66

   scf
   jp loop_7

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_0:

   rl c
   rla
   adc hl,hl
   jr c, loop_000

loop_00:

   sbc hl,de
   jr nc, loop_1
   add hl,de

loop_1:

   rl c
   rla
   adc hl,hl
   jr c, loop_111

loop_11:

   sbc hl,de
   jr nc, loop_2
   add hl,de

loop_2:

   rl c
   rla
   adc hl,hl
   jr c, loop_222

loop_22:

   sbc hl,de
   jr nc, loop_3
   add hl,de

loop_3:

   rl c
   rla
   adc hl,hl
   jr c, loop_333

loop_33:

   sbc hl,de
   jr nc, loop_4
   add hl,de

loop_4:

   rl c
   rla
   adc hl,hl
   jr c, loop_444

loop_44:

   sbc hl,de
   jr nc, loop_5
   add hl,de

loop_5:

   rl c
   rla
   adc hl,hl
   jr c, loop_555

loop_55:

   sbc hl,de
   jr nc, loop_6
   add hl,de

loop_6:

   rl c
   rla
   adc hl,hl
   jr c, loop_666

loop_66:

   sbc hl,de
   jr nc, loop_7
   add hl,de

loop_7:

   rl c
   rla
   adc hl,hl
   jr c, loop_777

loop_77:

   sbc hl,de
   jr nc, loop_8
   add hl,de

loop_8:

   djnz loop_0
   
exit_loop:

   rl c
   rla
   
   ; ac = ~quotient, hl = remainder
   
   ex de,hl

   cpl
   ld h,a
   ld a,c
   cpl
   ld l,a
   
   xor a
   ret

loop_000:

   or a
   sbc hl,de
   or a
   jp loop_1

loop_111:

   or a
   sbc hl,de
   or a
   jp loop_2

loop_222:

   or a
   sbc hl,de
   or a
   jp loop_3

loop_333:

   or a
   sbc hl,de
   or a
   jp loop_4

loop_444:

   or a
   sbc hl,de
   or a
   jp loop_5

loop_555:

   or a
   sbc hl,de
   or a
   jp loop_6

loop_666:

   or a
   sbc hl,de
   or a
   jp loop_7

loop_777:

   or a
   sbc hl,de
   or a
   jp loop_8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld b,16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   rl c
   inc c
   rla
   adc hl,hl
   
   inc h
   dec h
   
   jr nz, loop_03
   djnz loop_00
   
   ; will never get here
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_11:

   rl c
   rla
   adc hl,hl
   
   jr c, loop_01

loop_03:

   sbc hl,de
   jr nc, loop_02
   add hl,de

loop_02:

   djnz loop_11
   
   rl c
   rla
   
   ; ac = ~quotient, hl = remainder
   
   ex de,hl

   cpl
   ld h,a
   ld a,c
   cpl
   ld l,a
   
   xor a
   ret

loop_01:

   or a
   sbc hl,de
   or a
   jp loop_02

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
