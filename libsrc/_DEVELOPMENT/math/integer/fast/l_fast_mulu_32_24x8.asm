
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_32_24x8, l0_fast_mulu_32_24x8

EXTERN l1_fast_mulu_24_16x8

l0_fast_mulu_32_24x8:

   ; enter : ehl = 24-bit multiplicand
   ;           a = 8-bit multiplicand
   
   ld d,e
   ld e,a
   ld a,d

l_fast_mulu_32_24x8:

   ; unsigned multiplication of 24-bit and 8-bit
   ; multiplicands into a 32-bit product
   ;
   ; enter :    e = 8-bit multiplicand
   ;          ahl = 24-bit multiplicand
   ;
   ; exit  : dehl = 32-bit result
   ;            a = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, (ixh if loop unrolling disabled)
   
   ; try to reduce the multiplication
   
   or a
   jp z, l1_fast_mulu_24_16x8

   ; two full size multiplicands

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $08

   ld c,e
   ld b,a
   ld e,l
   ld d,h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld c,e
   ld b,a
   ex de,hl
   
   xor a
   ld l,a
   ld h,a

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; bde = 24-bit multiplicand
   ;   c = 8-bit multiplicand

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $04
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $08

   ; eliminate leading zero bits

loop_00:

   sla c
   jr c, loop_11

   sla c
   jr c, loop_12

   sla c
   jr c, loop_13

   sla c
   jr c, loop_14

   sla c
   jr c, loop_15

   sla c
   jr c, loop_16

   sla c
   jr c, loop_17

   sla c
   jr c, exit_18
      
   xor a
   
   ld e,a
   ld d,a
   ld l,a
   ld h,a
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

loop_10:

   sla c
   jr nc, loop_11
   
   add hl,de
   adc a,b

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general multiplication loop

loop_11:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_12
   
   add hl,de
   adc a,b
   
   jp nc, loop_12
   inc c

loop_12:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_13
   
   add hl,de
   adc a,b
   
   jp nc, loop_13
   inc c

loop_13:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_14
   
   add hl,de
   adc a,b
   
   jp nc, loop_14
   inc c

loop_14:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_15
   
   add hl,de
   adc a,b
   
   jp nc, loop_15
   inc c

loop_15:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_16
   
   add hl,de
   adc a,b
   
   jp nc, loop_16
   inc c

loop_16:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_17
   
   add hl,de
   adc a,b
   
   jp nc, loop_17
   inc c

loop_17:

   add hl,hl
   rla 
   rl c
   
   jr nc, exit_18
   
   add hl,de
   adc a,b
   
   jp nc, exit_18
   inc c

exit_18:

   ; product in cahl
  
   ld e,a
   ld d,c
  
   xor a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld ixh,8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $08

   ; eliminate leading zeroes

loop_00:

   sla c
   jr c, loop_01
   
   dec ixh
   jp nz, loop_00
   
   xor a
   
   ld e,a
   ld d,a
   ld l,a
   ld h,a
   
   ret

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; general multiplication loop

loop_11:

   add hl,hl
   rla 
   rl c
   
   jr nc, loop_01
   
   add hl,de
   adc a,b
   
   jp nc, loop_01
   inc c

loop_01:

   dec ixh
   jp nz, loop_11
   
   ; product in cahl
  
   ld e,a
   ld d,c
  
   xor a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
