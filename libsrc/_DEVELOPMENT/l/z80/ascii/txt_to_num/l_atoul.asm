
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_atoul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_atoul

l_atoul:

   ; ascii buffer to unsigned long conversion
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_TXT2NUM_SELECT & $04

   EXTERN l_fast_atoul
   jp l_fast_atoul

ELSE

   EXTERN l_small_atoul
   jp l_small_atoul

ENDIF

