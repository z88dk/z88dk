
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_32_16x16
; called by asm_bit_beep
;
; compute: dehl = hl * de
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_mulu_32_16x16

l_mulu_32_16x16:

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_32_32x32
   
   push de
   ld de,0
   
   exx
   
   ex (sp),hl
   push de
   push bc
   
   ld de,0
   call l_small_mul_32_32x32
   
   exx
   
   pop bc
   pop de
   pop hl
   
   exx
   ret

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_32_16x16
   jp l_fast_mulu_32_16x16

ENDIF
