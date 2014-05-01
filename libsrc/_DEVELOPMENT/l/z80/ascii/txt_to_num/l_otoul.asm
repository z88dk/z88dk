
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_otoul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_otoul

l_otoul:

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

   LIB l_fast_otoul
   jp l_fast_otoul

ELSE

   LIB l_small_otoul
   jp l_small_otoul

ENDIF
