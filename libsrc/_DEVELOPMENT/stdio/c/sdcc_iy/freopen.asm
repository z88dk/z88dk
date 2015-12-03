
; FILE *freopen(char *filename, char *mode, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _freopen

EXTERN asm_freopen

_freopen:

   pop af
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push af
   
   jp asm_freopen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _freopen

EXTERN _freopen_unlocked

defc _freopen = _freopen_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
