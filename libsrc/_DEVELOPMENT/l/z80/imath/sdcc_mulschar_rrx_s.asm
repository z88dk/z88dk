
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mulschar_rrx_s
; 
; sdcc signed multiply of two chars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB __mulschar_rrx_s

__mulschar_rrx_s:

   ; enter : stack = packed multiplicand / multiplicand, ret
   ;
   ; exit  : hl = 16-bit product
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_IMATH <= 50

   ld hl,3
   add hl,sp
   
   ld e,(hl)
   dec hl
   ld l,(hl)
   
   ld a,e
   rla
   sbc a,a
   ld d,a
   
   ld a,l
   rla
   sbc a,a
   ld h,a
   
   LIB l_small_mul_16_16x16
   jp l_small_mul_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50
   
   ld hl,3
   add hl,sp
   
   ld e,(hl)
   dec hl
   ld l,(hl)

   LIB l_fast_muls_8_8x8
   jp l_fast_muls_8_8x8        ; hl = l * e
   
ENDIF
