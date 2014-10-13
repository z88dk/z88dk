
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getdelim_callee

getdelim_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_getdelim.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getdelim_callee

EXTERN getdelim_unlocked_callee

defc getdelim_callee = getdelim_unlocked_callee
   
INCLUDE "stdio/z80/asm_getdelim.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
