
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_utoa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_utoa

l_utoa:

   ; write unsigned decimal integer to ascii buffer (no termination)
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $04

   LIB l_fast_utoa
   jp l_fast_utoa

ELSE

   LIB l_small_utoa
   jp l_small_utoa

ENDIF
