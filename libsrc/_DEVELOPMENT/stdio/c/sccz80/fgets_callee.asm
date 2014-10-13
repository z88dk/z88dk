
; char *fgets(char *s, int n, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgets_callee

fgets_callee:

   pop af
   pop ix
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgets_callee

EXTERN fgets_unlocked_callee

defc fgets_callee = fgets_unlocked_callee
   
INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
