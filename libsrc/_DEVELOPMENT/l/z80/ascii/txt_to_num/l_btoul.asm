
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_btoul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_btoul

l_btoul:

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
   jp l_fast_btoul

ELSE

   EXTERN l_small_btoul
   jp l_small_btoul

ENDIF

   