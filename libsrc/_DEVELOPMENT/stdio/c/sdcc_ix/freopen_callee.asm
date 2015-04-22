
; FILE *freopen_callee(char *filename, char *mode, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _freopen_callee, l0_freopen_callee

_freopen_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_freopen_callee:

   push bc
   ex (sp),ix
   
   call asm_freopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_freopen.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _freopen_callee

EXTERN _freopen_unlocked_callee

defc _freopen_callee = _freopen_unlocked_callee
   
INCLUDE "stdio/z80/asm_freopen.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
