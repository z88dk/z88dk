
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; divuchar_rrx_s
; 
; sdcc unsigned division of two chars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB __divuchar_rrx_s

__divuchar_rrx_s:

   ; enter : stack = packed divisor / dividend, ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder
   ;
   ; uses  : af, bc, de, hl
   
;; IF __CLIB_OPT_IMATH > 50
   
   ld hl,3
   add hl,sp
   
   ld e,(hl)
   dec hl
   ld l,(hl)

   LIB l_fast_divu_8_8x8
   jp l_fast_divu_8_8x8        ; hl = l / e, de = l % e
   
;; ENDIF
