
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_ultob

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

   EXTERN l_fast_ultob
   
   defc l_ultob = l_fast_ultob

ELSE

   EXTERN l_small_ultob
   
   defc l_ultob = l_small_ultob

ENDIF
