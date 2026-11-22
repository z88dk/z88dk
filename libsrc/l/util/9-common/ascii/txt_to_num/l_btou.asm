
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_btou

   ; ascii binary string to unsigned integer
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_TXT2NUM_SELECT & $01

   EXTERN l_fast_btou
   
   defc l_btou = l_fast_btou

ELSE

   EXTERN l_small_btou
   
   defc l_btou = l_small_btou

ENDIF

