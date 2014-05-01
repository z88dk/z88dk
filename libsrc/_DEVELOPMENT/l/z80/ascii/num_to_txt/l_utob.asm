
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_utob
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_utob

l_utob:

   ; write unsigned binary integer to ascii buffer (no termination)
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $01

   LIB l_fast_utob
   jp l_fast_utob

ELSE

   LIB l_small_utob
   jp l_small_utob

ENDIF

