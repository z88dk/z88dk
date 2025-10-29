
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_utoo

   ; write unsigned octal integer to ascii buffer (no termination)
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $02

   EXTERN l_fast_utoo
   
   defc l_utoo = l_fast_utoo

ELSE

   EXTERN l_small_utoo
   
   defc l_utoo = l_small_utoo

ENDIF
