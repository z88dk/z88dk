
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_16_8x8

l_fast_mulu_16_8x8:

   ; unsigned multiplication of two 8-bit
   ; multiplicands into a sixteen bit product
   ;
   ; enter : l = 8-bit multiplicand
   ;         e = 8-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;          a = 0
   ;          d = 0
   ;         carry reset
   ;
   ; uses  : af, b, de, hl

   xor a
   ld d,a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $08

   ld h,l
   ld l,e

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld h,l
   ld l,a

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $04
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $08

   ; eliminate leading zero bits

loop_00:

   sla h
   jr c, loop_11
   
   sla h
   jr c, loop_12
   
   sla h
   jr c, loop_13

   sla h
   jr c, loop_14

   sla h
   jr c, loop_15
   
   sla h
   jr c, loop_16
   
   sla h
   jr c, loop_17

   sla h
   ccf
   ret nc

   xor a
   ld l,a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

loop_10:

   sla h
   jr nc, loop_11
   add hl,de

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general multiplication loop

loop_11:
   
   add hl,hl
   jr nc, loop_12
   add hl,de

loop_12:

   add hl,hl
   jr nc, loop_13
   add hl,de

loop_13:

   add hl,hl
   jr nc, loop_14
   add hl,de

loop_14:

   add hl,hl
   jr nc, loop_15
   add hl,de

loop_15:

   add hl,hl
   jr nc, loop_16
   add hl,de

loop_16:

   add hl,hl
   jr nc, loop_17
   add hl,de

loop_17:

   add hl,hl
   ret nc
   add hl,de
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld b,8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $08

   ; eliminate leading zeroes

loop_00:

   sla h
   jr c, loop_01
   
   djnz loop_00
   
   xor a
   ld l,a
   ret

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general multiply loop

loop_11:

   add hl,hl
   jr nc, loop_01
   add hl,de

loop_01:

   djnz loop_11
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
