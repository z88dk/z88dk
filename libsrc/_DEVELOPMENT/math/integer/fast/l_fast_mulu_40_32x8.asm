
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_40_32x8, l0_fast_mulu_40_32x8

EXTERN l0_fast_mulu_32_24x8, error_lznc

l_fast_mulu_40_32x8:

   ; enter :  dehl = 32-bit multiplicand
   ;             a = 8-bit multiplicand
   ;
   ; exit  : adehl = 40-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, de', hl' (ixh if loop unrolling disabled)
   
   ; try to reduce the multiplication
   
   inc d
   dec d
   jp z, l0_fast_mulu_32_24x8

l0_fast_mulu_40_32x8:

   ; two full size multiplicands

   push hl
   
   ld l,e
   ld h,d
   
   exx
   
   pop de

   ld l,e
   ld h,d

   ;  de'de = 32-bit multiplicand
   ;      a = 8-bit multiplicand
   ;  hl'hl = 32-bit multiplicand

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $04
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE LOOP UNROLLING ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld c,0

   ; eliminate leading zeroes

loop_00:

   add a,a
   jr c, loop11

   add a,a
   jr c, loop12
   
   add a,a
   jr c, loop13
   
   add a,a
   jr c, loop14

   add a,a
   jr c, loop15
   
   add a,a
   jr c, loop16
   
   add a,a
   jr c, loop17

   add a,a
   ccf
   jr nz, loop_exit
   
   xor a
   jp error_lznc

   ; general multiplication loop

loop11:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop12

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop12:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop13

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop13:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop14

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop14:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop15

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop15:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop16

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop16:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop17

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop17:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop_exit

   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop_exit:

   ; ahl'hl = product

   push hl
   exx
   pop de
   
   ex de,hl
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISABLE LOOP UNROLLING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld bc,0x0700

   ; eliminate leading zeroes

loop_00:

   add a,a
   jr c, loop
   djnz loop_00   

   add a,a
   ccf
   jr nc, loop_exit

   xor a
   jp error_lznc

   ; general multiply loop

loop:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

   jr nc, loop_end
   
   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop_end:

   djnz loop

loop_exit:

   ; ahl'hl = product

   push hl
   exx
   pop de
   
   ex de,hl
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
