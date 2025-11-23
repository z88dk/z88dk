
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_24_24x8, l0_fast_divu_24_24x8, l00_fast_divu_24_24x8

EXTERN l0_fast_divu_16_16x8, error_divide_by_zero_mc

divu_24_16x8:

   ; hl / c
   
   ld e,c
   jp l0_fast_divu_16_16x8

divide_by_zero:

   ld c,e
   ex de,hl
   
   ld a,$ff
   jp error_divide_by_zero_mc


l_fast_divu_24_24x8:

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

l0_fast_divu_24_24x8:

   ; try to reduce the division
   
   inc e
   dec e
   jr z, divu_24_16x8

l00_fast_divu_24_24x8:

   ; ehl >= $ 01 00 00
   ;   c >= $       01

   xor a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll divide eight times
   
   ld b,3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

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
   rl e
   
   rla
   
   cp c
   jr c, loop_80
   
   sub c
   inc l

loop_80:

   dec b

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop
   
loop_0:

   add hl,hl
   rl e

loop_10:

   rla
   jr c, loop_101
   
   cp c
   jr c, loop_1

loop_101:

   sub c
   inc l

loop_1:

   add hl,hl
   rl e

loop_20:

   rla
   jr c, loop_201
   
   cp c
   jr c, loop_2

loop_201:
   
   sub c
   inc l

loop_2:

   add hl,hl
   rl e

loop_30:

   rla
   jr c, loop_301
   
   cp c
   jr c, loop_3

loop_301:

   sub c
   inc l

loop_3:

   add hl,hl
   rl e

loop_40:

   rla
   jr c, loop_401
   
   cp c
   jr c, loop_4

loop_401:

   sub c
   inc l

loop_4:

   add hl,hl
   rl e

loop_50:

   rla
   jr c, loop_501
   
   cp c
   jr c, loop_5

loop_501:

   sub c
   inc l

loop_5:

   add hl,hl
   rl e
   
loop_60:

   rla
   jr c, loop_601
   
   cp c
   jr c, loop_6

loop_601:
   
   sub c
   inc l

loop_6:

   add hl,hl
   rl e

loop_70:

   rla
   jr c, loop_701
   
   cp c
   jr c, loop_7

loop_701:

   sub c
   inc l

loop_7:

   add hl,hl
   rl e
   rla
   jr c, loop_801
   
   cp c
   jr c, loop_8

loop_801:

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

   add hl,hl
   rl e
   jr c, loop_01
   
   djnz loop_00
   
   ; will never get here

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_11:

   add hl,hl
   rl e

loop_01:

   rla
   
   jr c, loop_02
   
   cp c
   jr c, loop_03
   
loop_02:

   sub c
   inc l

loop_03:

   djnz loop_11

   ;   a = remainder
   ; ehl = quotient

   ld c,a
   ld a,e
   ld e,c
   ld d,b
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
