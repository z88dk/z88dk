
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_utoo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_utoo

l_utoo:

   ; write unsigned octal integer to ascii buffer (no termination)
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry reset (implementation may write leading zeroes if carry set)
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

;; IF __CLIB_OPT_NUM2TXT ....

   LIB l_fast_utoo
   jp l_fast_utoo

;; ENDIF
