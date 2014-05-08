
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_24_16x8
; called by __strtou
;
; compute: ahl = hl * e
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_mulu_24_16x8

l_mulu_24_16x8:

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_32_32x32
   
   ld a,e
   ld de,0
   
   exx
   
   push bc
   push de
   push hl
   
   ld l,a
   ld de,0
   ld h,d
   
   call l_small_mul_32_32x32
   
   exx
   
   pop hl
   pop de
   pop bc
   
   exx
   
   ld a,e
   ret

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_24_16x8
   jp l_fast_mulu_24_16x8

ENDIF
