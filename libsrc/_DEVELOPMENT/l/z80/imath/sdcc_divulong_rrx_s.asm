
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; divulong_rrx_s
; 
; sdcc unsigned division of two longs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB __divulong_rrx_s

__divulong_rrx_s:

   ; enter : stack = 32-bit divisor, 32-bit dividend, ret
   ;
   ; exit  : dehl = quotient
   ;         dehl'= remainder (sdcc does not use remainder)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', (iy if SDCC_IY)

IF __CLIB_OPT_IMATH <= 50

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push de
   push hl
   push af
   
   exx
   
   LIB l_small_divu_32_32x32
   jp l_small_divu_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push de
   push hl
   push af
   
   exx

   IF __SDCC_IX
   
      push ix
      
      LIB l_fast_divu_32_32x32
      call l_fast_divu_32_32x32
      
      pop ix
      ret
   
   ELSE

      LIB l_fast_divu_32_32x32
      jp l_fast_divu_32_32x32
      
   ENDIF

ENDIF
