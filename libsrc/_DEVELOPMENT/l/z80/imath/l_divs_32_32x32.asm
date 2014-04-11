
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_divs_32_32x32
; called by asm__ldiv
;
; compute:  dehl = dehl' / dehl, dehl' = dehl' % dehl
; test for divide by zero
; can alter: af, bc, de, hl, bc, de, hl, ix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_divs_32_32x32

l_divs_32_32x32:

;; IF __CLIB_OPT_IMATH > 50

   LIB l_fast_divs_32_32x32
   
   jp l_fast_divs_32_32x32

;; ENDIF
