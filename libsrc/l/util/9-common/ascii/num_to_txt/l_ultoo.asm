
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_ultoo

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
   
   defc l_ultoo = l_fast_ultoo

ELSE

   EXTERN l_small_ultoo
   
   defc l_ultoo = l_small_ultoo

ENDIF
