
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_32_32x32, l0_fast_divu_32_32x32

EXTERN l0_fast_divu_32_32x24, error_divide_by_zero_mc


divu_32_32x24:

   ; dehl'= 32-bit dividend
   ;  ehl = 24-bit divisor

   ld d,e
   ld b,h
   ld c,l
   
   jp l0_fast_divu_32_32x24

result_zero:

   ; dehl = dividend
   ; dehl'= divisor

   exx
   
   xor a
   ld l,a
   ld h,a
   ld e,a
   ld d,a
   
   ret

divide_by_zero:

   dec de
   jp error_divide_by_zero_mc


   ; alternate entry point that swaps dividend / divisor
   
   exx

l_fast_divu_32_32x32:

   ; unsigned division of two 32-bit numbers
   ;
   ; enter : dehl'= 32-bit dividend
   ;         dehl = 32-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit quotient
   ;            dehl'= 32-bit remainder
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
   or e
   or h
   or l
   jr z, divide_by_zero

l0_fast_divu_32_32x32:
   
   ; try to reduce the division
   
   ld a,d
   or a
   jr z, divu_32_32x24
   
   exx
   
   inc d
   dec d
   jr z, result_zero
   
   ; dehl = dividend >= $ 01 00 00 00
   ; dehl'= divisor  >= $ 01 00 00 00
   ; carry reset

   ; check if divisor > dividend

   exx
   
   push hl
   push de
   
   exx
   
   pop bc
   ex de,hl
   sbc hl,bc
   add hl,bc
   
   pop bc
   ex de,hl
   
   jr c, result_zero
   jr nz, begin
   
   sbc hl,bc
   add hl,bc
   
   jr c, result_zero

begin:

   ; max quotient is 255
   ;
   ; this means the result of the first 24 iterations
   ; of the division loop is known
   ;
   ; inside the loop the computation has
   ;
   ;    a = dividend, quotient
   ; hlhl'= remainder
   ; dede'= divisor 
   ;
   ; so initialize as if 24 iterations done
   
   ld a,e
   push hl
   
   exx
   
   ex de,hl
   ex (sp),hl
   ld l,h
   ld h,a
   
   exx
   
   ld a,l
   ld l,d
   ld h,0
   pop de
   
   ;    a = dividend, quotient
   ; hlhl'= remainder
   ; dede'= divisor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_z0:

   add a,a
      
   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_00

loop_z1:

   add a,a
   inc a

   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_10

loop_z2:

   add a,a
   inc a

   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_20

loop_z3:

   add a,a
   inc a

   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_30

loop_z4:

   add a,a
   inc a

   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_40

loop_z5:

   add a,a
   inc a

   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_50

loop_z6:

   add a,a
   inc a

   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_60

   scf
   jp loop_7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   add a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_00:

   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_1

   exx
   add hl,de
   exx
   adc hl,de
   
loop_1:
   
   adc a,a

   exx
   adc hl,hl
   exx
   adc hl,hl

loop_10:

   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_2

   exx
   add hl,de
   exx
   adc hl,de
   
loop_2:
   
   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

loop_20:

   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_3

   exx
   add hl,de
   exx
   adc hl,de
   
loop_3:
   
   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

loop_30:
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_4

   exx
   add hl,de
   exx
   adc hl,de
   
loop_4:
   
   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

loop_40:
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_5

   exx
   add hl,de
   exx
   adc hl,de
   
loop_5:
   
   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

loop_50:
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_6

   exx
   add hl,de
   exx
   adc hl,de
   
loop_6:
   
   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

loop_60:
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_7

   exx
   add hl,de
   exx
   adc hl,de
   
loop_7:
   
   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, exit_loop

   exx
   add hl,de
   exx
   adc hl,de

exit_loop:

   ; form last quotient bit
   
   adc a,a
      
   ;    a = ~quotient
   ; hlhl'= remainder

   cpl
   
   push hl
   exx
   pop de
   exx
   
   ld l,a
   xor a
   ld h,a
   
   ld e,h
   ld d,h
   
   ; dehl = quotient
   ; dehl'= remainder
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld b,8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $02

   ; eliminate leading zeroes

loop_00:

   add a,a
   inc a
      
   exx
   adc hl,hl
   exx
   adc hl,hl
   
   inc h
   dec h
   jr nz, loop_01
   
   djnz loop_00
   
   ; will never get here

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general divide loop

loop_11:

   adc a,a
   
   exx
   adc hl,hl
   exx
   adc hl,hl

loop_01:
   
   exx
   sbc hl,de
   exx
   sbc hl,de
   
   jr nc, loop_02

   exx
   add hl,de
   exx
   adc hl,de

loop_02:

   djnz loop_11

   ; form last quotient bit
   
   adc a,a
      
   ;    a = ~quotient
   ; hlhl'= remainder

   cpl
   
   push hl
   exx
   pop de
   exx
   
   ld l,a
   xor a
   ld h,a
   
   ld e,h
   ld d,h
   
   ; dehl = quotient
   ; dehl'= remainder
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
