
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_32_32x8, l0_fast_divu_32_32x8

EXTERN l0_fast_divu_24_24x8, error_divide_by_zero_mc


divu_32_24x8:

   ; ehl / c
   
   call l0_fast_divu_24_24x8
   
   ld c,a
   ld a,e
   ld e,c
   
   ret

divide_by_zero:

   exx
   
   ld de,$ffff
   jp error_divide_by_zero_mc


l_fast_divu_32_32x8:

   ; unsigned division of a 32-bit number
   ; by an 8-bit number
   ;
   ; enter : dehl = 32-bit dividend
   ;            c = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;               a = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            dehl'= dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; test for divide by zero

   inc c
   dec c
   jr z, divide_by_zero

l0_fast_divu_32_32x8:

   ; uses  : af, bc, de, hl

   ; try to reduce the division

   inc d
   dec d
   jr z, divu_32_24x8

   ; dehl >= $ 01 00 00 00
   ;    c >= $          01

   xor a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; unroll divide eight times
   
   ld b,4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   add hl,hl
   rl e
   rl d
   jr c, loop_10

   add hl,hl
   rl e
   rl d
   jr c, loop_20

   add hl,hl
   rl e
   rl d
   jr c, loop_30

   add hl,hl
   rl e
   rl d
   jr c, loop_40

   add hl,hl
   rl e
   rl d
   jr c, loop_50

   add hl,hl
   rl e
   rl d
   jr c, loop_60

   add hl,hl
   rl e
   rl d
   jr c, loop_70

   jp loop_7

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_0:

   add hl,hl
   rl e
   rl d

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
   rl d

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
   rl d

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
   rl d

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
   rl d

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
   rl d

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
   rl d

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
   rl d
   rla
   jr c, loop_801
   
   cp c
   jr c, loop_8

loop_801:

   sub c
   inc l

loop_8:

   djnz loop_0

   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld b,32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   add hl,hl
   rl e
   rl d
   
   jr c, loop_01
   djnz loop_00
   
   ; will never get here

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_11:

   add hl,hl
   rl e
   rl d

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

   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
