
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_otou

   ; ascii octal string to unsigned integer
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

IF __CLIB_OPT_TXT2NUM_SELECT & $02

   EXTERN l_fast_otou
   
   defc l_otou = l_fast_otou

ELSE

   EXTERN l_small_otou
   
   defc l_otou = l_small_otou

ENDIF
