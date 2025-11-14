
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_utob

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

   EXTERN l_fast_utob
   
   defc l_utob = l_fast_utob

ELSE

   EXTERN l_small_utob
   
   defc l_utob = l_small_utob

ENDIF

