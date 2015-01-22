
; int fsetpos(FILE *stream, const fpos_t *pos)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos

_fsetpos:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fsetpos
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fsetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos

EXTERN _fsetpos_unlocked

defc _fsetpos = _fsetpos_unlocked
   
INCLUDE "stdio/z80/asm_fsetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
