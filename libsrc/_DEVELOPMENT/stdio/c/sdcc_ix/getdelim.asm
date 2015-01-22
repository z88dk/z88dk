
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getdelim

_getdelim:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   
   push bc
   exx
   push bc
   push de
   push hl
   push af
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_getdelim
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getdelim.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getdelim

EXTERN _getdelim_unlocked

defc _getdelim = _getdelim_unlocked
   
INCLUDE "stdio/z80/asm_getdelim.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
