
; size_t getline(char **lineptr, size_t *n, FILE *stream)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getline

EXTERN asm_getline

getline:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push ix
   push af
   
   jp asm_getline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC getline

EXTERN getline_unlocked

getline:

   jp getline_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
