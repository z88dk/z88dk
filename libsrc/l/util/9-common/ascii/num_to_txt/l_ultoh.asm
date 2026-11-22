
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_ultoh

   ; write unsigned long hex to ascii buffer (no termination)
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $08

   EXTERN l_fast_ultoh
   
   defc l_ultoh = l_fast_ultoh

ELSE

   EXTERN l_small_ultoh
   
   defc l_ultoh = l_small_ultoh

ENDIF
