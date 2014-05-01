
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_ultob
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_ultob

l_ultob:

   ; write unsigned long binary to ascii buffer (no termination)
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $01

   LIB l_fast_ultob
   jp l_fast_ultob

ELSE

   LIB l_small_ultob
   jp l_small_ultob

ENDIF
