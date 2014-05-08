
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_atou
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_atou

l_atou:

   ; ascii to unsigned integer conversion
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_TXT2NUM_SELECT & $04

   EXTERN l_fast_atou
   jp l_fast_atou

ELSE

   EXTERN l_small_atou
   jp l_small_atou

ENDIF

