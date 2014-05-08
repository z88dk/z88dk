
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_btou
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_btou

l_btou:

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
   jp l_fast_btou

ELSE

   EXTERN l_small_btou
   jp l_small_btou

ENDIF

