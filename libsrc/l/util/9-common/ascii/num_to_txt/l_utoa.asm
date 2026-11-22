
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_utoa

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

   EXTERN l_fast_utoa
   
   defc l_utoa = l_fast_utoa

ELSE

   EXTERN l_small_utoa
   
   defc l_utoa = l_small_utoa

ENDIF
