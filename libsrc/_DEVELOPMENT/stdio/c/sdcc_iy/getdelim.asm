
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getdelim

EXTERN asm_getdelim

_getdelim:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push hl
   push bc
   push de
   push hl
   push af

   jp asm_getdelim

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getdelim

EXTERN _getdelim_unlocked

defc _getdelim = _getdelim_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
