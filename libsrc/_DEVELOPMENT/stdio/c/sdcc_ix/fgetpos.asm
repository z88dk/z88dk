
; int fgetpos(FILE *stream, fpos_t *pos)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetpos

_fgetpos:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fgetpos
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetpos

EXTERN _fgetpos_unlocked

defc _fgetpos = _fgetpos_unlocked
   
INCLUDE "stdio/z80/asm_fgetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
