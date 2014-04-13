
; void *_falloc_(void *p, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB _falloc_

LIB asm__falloc

_falloc_:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm__falloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB _falloc_

LIB _falloc__unlocked

_falloc_:

   jp _falloc__unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
