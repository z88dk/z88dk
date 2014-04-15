
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_ultoh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_ultoh

l_ultoh:

   ; write unsigned long hex to ascii buffer (no termination)
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

;; IF __CLIB_OPT_NUM2TXT ....

   LIB l_fast_ultoh
   jp l_fast_ultoh

;; ENDIF
