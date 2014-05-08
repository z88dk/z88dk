
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_utoh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_utoh

l_utoh:

   ; write unsigned hex integer to ascii buffer (no termination)
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_NUM2TXT_SELECT & $08

   EXTERN l_fast_utoh
   jp l_fast_utoh

ELSE

   EXTERN l_small_utoh
   jp l_small_utoh

ENDIF

