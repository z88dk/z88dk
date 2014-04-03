
; l_mulu_40_32x8
; called by __strtoul

; compute:  adehl = dehl * a
; can alter: af, bc, de, hl, ixh

XLIB l_mulu_40_32x8

INCLUDE "clib_cfg.asm"

l_mulu_40_32x8:

;; IF __CLIB_OPT_IMATH > 50

   LIB l_fast_mulu_40_32x8
   
   jp l_fast_mulu_40_32x8

;; ENDIF

