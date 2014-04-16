
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mult
; 
; sccz80 multiplication of two ints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NOTE: this entry does not distinguish
; between signed and unsigned multiply
; so the LIA-1 option will not generate
; correct results.

INCLUDE "clib_cfg.asm"

XLIB l_mult

l_mult:

   ; enter : hl = 16-bit mutiplicand
   ;         de = 16-bit multiplicand
   ;
   ; exit  : hl = product
   ;
   ; uses  : af, bc, de, hl
   
;; IF __CLIB_OPT_IMATH > 50
   
   LIB l_fast_mulu_16_16x16
   jp l_fast_mulu_16_16x16     ; hl = hl * de

;; ENDIF
