
; void heap_info(void *heap, void *callback)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_info

EXTERN asm_heap_info

heap_info:

   pop af
   pop bc
   pop de

   push de
   push hl
   push af

   push ix
   push bc
   pop ix

   call asm_heap_info
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_info

EXTERN heap_info_unlocked

defc heap_info = heap_info_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
