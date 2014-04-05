
XLIB l_fast_divu_32_32x24
XDEF l0_fast_divu_32_32x24

INCLUDE "clib_cfg.asm"

LIB l0_fast_divu_32_32x16, l0_fast_divu_24_24x24, l_cpl_dehl, error_divide_by_zero_mc


divu_32_32x16:

   ; dehl'/ bc

   push bc
   exx
   pop bc
   
   jp l0_fast_divu_32_32x16

divu_32_24x24:

   ; ehl / dbc'

   ld a,e
   push hl
   
   exx
      
   pop hl
   ld e,a
   
   call l0_fast_divu_24_24x24
   
   push bc
   push de
   
   ld e,a
   xor a
   ld d,a
   
   exx
   
   pop hl
   pop de
   
   ld d,a
   
   exx
   ret

divide_by_zero:

   ld de,$ffff
   jp error_divide_by_zero_mc


l_fast_divu_32_32x24:

   ; unsigned division of 32-bit number
   ; by a 24-bit number
   ;
   ; enter : dehl'= 32-bit dividend
   ;          dbc = 24-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;            dehl'= 24-bit remainder
   ;
   ;         divide by zero
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc. de. hl, bc', de', hl', ixh

   ; test for divide by zero
   
   ld a,d
   or b
   or c
   jr z, divide_by_zero

l0_fast_divu_32_32x24:

   ; try to reduce the division

   inc d
   dec d
   jr z, divu_32_32x16
   
   exx
   
   inc d
   dec d
   jr z, divu_32_24x24
   
   ; dehl = dividend >= $ 01 00 00 00
   ;  dbc'= divisor  >= $    01 00 00
   ;
   ; the results of the first sixteen
   ; iterations are known
   ;
   ; inside the loop the computation is
   ; dehl'/dbc, ahl = remainder
   ; so initialize as if sixteen iterations done

   push de
   ex de,hl
   ld hl,$ffff
   
   exx
   
   pop hl
   xor a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll eight times
   
   ld ixh,2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jr c, loop_10

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jr c, loop_20

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jr c, loop_30

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jp c, loop_40

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jp c, loop_50

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jp c, loop_60

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
   adc hl,hl
   
   jp c, loop_70

   scf
   jp loop_7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   scf
   jp loop_0

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

loop_100:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_1

loop_200:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_2

   ; general divide loop

loop_0:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_10:

   rla
   jr c, loop_100
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_1
   add hl,bc
   adc a,d

loop_1:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_20:

   rla
   jr c, loop_200
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_2
   add hl,bc
   adc a,d

loop_2:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_30:

   rla
   jr c, loop_300
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_3
   add hl,bc
   adc a,d

loop_3:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_40:

   rla
   jr c, loop_400
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_4
   add hl,bc
   adc a,d

loop_4:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_50:

   rla
   jr c, loop_500
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_5
   add hl,bc
   adc a,d

loop_5:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_60:

   rla
   jr c, loop_600
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_6
   add hl,bc
   adc a,d

loop_6:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_70:

   rla
   jr c, loop_700
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_7
   add hl,bc
   adc a,d

loop_7:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   rla
   jr c, loop_800
   
   sbc hl,bc
   sbc a,d
   jr nc, loop_8
   add hl,bc
   adc a,d

loop_8:

   dec ixh
   jp nz, loop_0

   ; dehl'=~quotient with one more shift
   ;  ahl = remainder

   ld e,a
   ld d,0
   
   exx
   
   adc hl,hl
   rl e
   rl d
   
   or a
   jp l_cpl_dehl

loop_300:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_3

loop_400:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_4

loop_500:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_5
   
loop_600:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_6

loop_700:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_7

loop_800:

   or a
   sbc hl,bc
   sbc a,d
   or a
   jp loop_8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld ixh,16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   exx
   add hl,hl
   inc l
   rl e
   rl d
   exx
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

   ; general divide loop

loop_11:

   exx
   adc hl,hl
   rl e
   rl d
   exx
   adc hl,hl

loop_01:

   rla
   jr c, loop_03
   
   sbc hl,bc
   sbc a,d
   
   jr nc, loop_02
   
   add hl,bc
   adc a,d

loop_02:

   dec ixh
   jp nz, loop_11

   ; dehl'=~quotient with one more shift
   ;  ahl = remainder

   ld e,a
   ld d,0
   
   exx
   
   adc hl,hl
   rl e
   rl d
   
   or a
   jp l_cpl_dehl

loop_03:

   or a
   sbc hl,bc
   sbc a,d
   or a
   
   jp loop_02

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
