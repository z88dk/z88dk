
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_htou

   ; ascii hex string to unsigned integer
   ; whitespace is not skipped, leading 0x not interpretted
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_TXT2NUM_SELECT & $08

   EXTERN l_fast_htou
   
   defc l_htou = l_fast_htou

ELSE

   EXTERN l_small_htou
   
   defc l_htou = l_small_htou

ENDIF
