
; FILE *freopen_callee(char *filename, char *mode, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _freopen_callee, l0_freopen_callee

EXTERN asm_freopen

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _freopen_callee

EXTERN _freopen_unlocked_callee

defc _freopen_callee = _freopen_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
