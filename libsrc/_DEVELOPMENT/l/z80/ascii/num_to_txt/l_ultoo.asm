
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_ultoo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_ultoo

l_ultoo:

   ; write unsigned long octal to ascii buffer (no termination)
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $02

   EXTERN l_fast_ultoo
   jp l_fast_ultoo

ELSE

   EXTERN l_small_ultoo
   jp l_small_ultoo

ENDIF
