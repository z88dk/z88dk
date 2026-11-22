
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_btoul

   ; ascii binary string to unsigned long
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_TXT2NUM_SELECT & $01

   EXTERN l_fast_btoul
   
   defc l_btoul = l_fast_btoul

ELSE

   EXTERN l_small_btoul
   
   defc l_btoul = l_small_btoul

ENDIF

   