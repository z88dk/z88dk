
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_htoul

   ; ascii hex string to unsigned long
   ; whitespace is not skipped, leading 0x not interpretted
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_TXT2NUM_SELECT & $08

   EXTERN l_fast_htoul
   
   defc l_htoul = l_fast_htoul

ELSE

   EXTERN l_small_htoul
   
   defc l_htoul = l_small_htoul

ENDIF

