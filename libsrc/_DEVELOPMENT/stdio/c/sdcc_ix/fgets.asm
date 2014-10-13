
; char *fgets(char *s, int n, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets

_fgets:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm_fgets
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets

EXTERN _fgets_unlocked

defc _fgets = _fgets_unlocked
   
INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
