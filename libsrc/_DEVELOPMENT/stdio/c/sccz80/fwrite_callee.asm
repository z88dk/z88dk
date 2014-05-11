
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fwrite_callee

fwrite_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fwrite.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fwrite_callee

EXTERN fwrite_unlocked_callee

fwrite_callee:

   jp fwrite_unlocked_callee

   INCLUDE "stdio/z80/asm_fwrite.asm"
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
