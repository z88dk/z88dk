
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_otoul

   ; ascii octal string to unsigned long
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

IF __CLIB_OPT_TXT2NUM_SELECT & $02

   EXTERN l_fast_otoul
   
   defc l_otoul = l_fast_otoul

ELSE

   EXTERN l_small_otoul
   
   defc l_otoul = l_small_otoul

ENDIF
