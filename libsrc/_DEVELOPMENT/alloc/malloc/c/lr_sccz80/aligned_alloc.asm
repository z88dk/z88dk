
; void *aligned_alloc(size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB aligned_alloc

LIB asm_aligned_alloc

aligned_alloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_aligned_alloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB aligned_alloc

LIB aligned_alloc_unlocked

aligned_alloc:

   jp aligned_alloc_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
