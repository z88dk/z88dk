
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fwrite

EXTERN asm_fwrite

fwrite:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push ix
   push af
   
   jp asm_fwrite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fwrite

EXTERN fwrite_unlocked

fwrite:

   jp fwrite_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
