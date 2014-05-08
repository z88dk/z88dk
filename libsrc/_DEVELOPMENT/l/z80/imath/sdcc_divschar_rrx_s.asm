
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; divschar_rrx_s
; 
; sdcc signed division of two chars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC __divschar_rrx_s

__divschar_rrx_s:

   ; enter : stack = packed divisor / dividend, ret
   ;
   ; exit  : hl = quotient
   ;         de = remainder
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
   
   EXTERN l_small_divs_16_16x16
   jp l_small_divs_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50
   
   ld hl,3
   add hl,sp
   
   ld e,(hl)
   dec hl
   ld l,(hl)

   EXTERN l_fast_divs_8_8x8
   call l_fast_divs_8_8x8      ; l = l / e, e = l % e
   
   ; not sure if we really need a 16-bit result
   ; but the sdcc subroutine is using a 16-bit division
   
   ld a,l
   rla
   sbc a,a
   ld h,a                      ; sign extend l into hl
   
   ld a,e
   rla
   sbc a,a
   ld d,a                      ; sign extend e into de

   ret
   
ENDIF
