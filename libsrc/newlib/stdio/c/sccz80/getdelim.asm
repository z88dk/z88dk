
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getdelim

EXTERN asm_getdelim

getdelim:

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push hl
   push af
   
   jp asm_getdelim

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getdelim

EXTERN getdelim_unlocked

defc getdelim = getdelim_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
