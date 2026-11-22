
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_32_32x16, l0_fast_divu_32_32x16

EXTERN l0_fast_divu_24_24x16, l0_fast_divu_32_32x8, l_cpl_dehl, error_divide_by_zero_mc


divu_32_24x16:

   ; ehl / bc
   
   call l0_fast_divu_24_24x16
   
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
   
   call l0_fast_divu_32_32x8
   
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


l_fast_divu_32_32x16:

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
   ; uses : af, bc, de, hl, bc', de', hl'
   
   ; test for divide by zero
   
   ld a,b
   or c
   jr z, divide_by_zero

l0_fast_divu_32_32x16:

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
   ; hl'a[*]/ de, hl = remainder
   ; so initialize as if eight iterations done

   ld a,l
   ld l,d
   ld d,e
   ld e,h
   ld h,0
   push de
   exx
   pop hl
   exx
   ld e,c
   ld d,b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll eight times
   
   ld b,3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

   exx
   add a,a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_000

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_111

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_222

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_333

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_444

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_555

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   inc h
   dec h
   jr nz, loop_666

   scf
   jp loop_7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   scf
   jp loop_0

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

loop_00:

   or a
   sbc hl,de
   or a
   jp loop_1

   ; general divide loop

loop_0:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_00

loop_000:

   sbc hl,de
   jr nc, loop_1
   add hl,de

loop_1:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_11

loop_111:

   sbc hl,de
   jr nc, loop_2
   add hl,de

loop_2:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_22

loop_222:

   sbc hl,de
   jr nc, loop_3
   add hl,de

loop_3:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_33

loop_333:

   sbc hl,de
   jr nc, loop_4
   add hl,de

loop_4:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_44

loop_444:

   sbc hl,de
   jr nc, loop_5
   add hl,de

loop_5:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_55

loop_555:

   sbc hl,de
   jr nc, loop_6
   add hl,de

loop_6:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_66

loop_666:

   sbc hl,de
   jr nc, loop_7
   add hl,de

loop_7:

   exx
   adc a,a
   adc hl,hl
   exx
   adc hl,hl
   jr c, loop_77
   
   sbc hl,de
   jr nc, loop_8
   add hl,de

loop_8:

   djnz loop_0
   
   ; hl = remainder, hl'a=~quotient with one more shift left

   ld e,b
   ld d,b
   
   exx
   
   rla
   adc hl,hl

   ld d,$ff
   ld e,h
   ld h,l
   ld l,a

   or a
   jp l_cpl_dehl

loop_11:

   or a
   sbc hl,de
   or a
   jp loop_2

loop_22:

   or a
   sbc hl,de
   or a
   jp loop_3

loop_33:

   or a
   sbc hl,de
   or a
   jp loop_4

loop_44:

   or a
   sbc hl,de
   or a
   jp loop_5

loop_55:

   or a
   sbc hl,de
   or a
   jp loop_6

loop_66:

   or a
   sbc hl,de
   or a
   jp loop_7

loop_77:

   or a
   sbc hl,de
   or a
   jp loop_8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld b,24

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   exx
   add a,a
   inc a
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   
   jr nz, loop_01
   djnz loop_00
   
   ; will never get here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   scf
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_11:

   exx
   adc a,a
   adc hl,hl
   exx
   
   adc hl,hl
   jr c, loop_03

loop_01:

   sbc hl,de
   jr nc, loop_02
   add hl,de

loop_02:

   djnz loop_11
   
   ; hl = remainder, hl'a=~quotient with one more shift left

   ld e,b
   ld d,b
   
   exx
   
   rla
   adc hl,hl

   ld d,$ff
   ld e,h
   ld h,l
   ld l,a

   or a
   jp l_cpl_dehl

loop_03:

   or a
   sbc hl,de
   or a
   jp loop_02

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
