
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_ultoa

   ; write unsigned long decimal to ascii buffer (no termination)
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl, bc', hl'

IF __CLIB_OPT_NUM2TXT_SELECT & $04

   EXTERN l_fast_ultoa
   
   defc l_ultoa = l_fast_ultoa

ELSE

   EXTERN l_small_ultoa
   
   defc l_ultoa = l_small_ultoa

ENDIF
