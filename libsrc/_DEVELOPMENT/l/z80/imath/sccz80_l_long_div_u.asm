
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_long_div_u
; 
; sccz80 division of two unsigned longs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_long_div_u

l_long_div_u:

   ; enter : dehl = 32-bit divisor
   ;         stack = 32-bit dividend, ret
   ;
   ; exit  : dehl = quotient
   ;         dehl'= remainder
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
   
;; IF __CLIB_OPT_IMATH > 50

   exx
   
   pop af
   pop hl
   pop de
   push af

   exx
   
   LIB l_fast_divu_32_32x32
   jp l_fast_divu_32_32x32

;; ENDIF
