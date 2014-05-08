
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_40_32x8
; called by __strtoul
;
; compute:  adehl = dehl * a
; can alter: af, bc, de, hl, ixh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_mulu_40_32x8

l_mulu_40_32x8:

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_40_32x8
   
   exx
   push bc
   push de
   push hl
   exx
   
   call l_small_mul_40_32x8

   exx
   pop hl
   pop de
   pop bc
   exx
   
   ret

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_40_32x8
   jp l_fast_mulu_40_32x8

ENDIF
