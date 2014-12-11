
; size_t getline(char **lineptr, size_t *n, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getline_callee

getline_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_getline.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getline_callee

EXTERN getline_unlocked_callee

defc getline_callee = getline_unlocked_callee
   
INCLUDE "stdio/z80/asm_getline.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
