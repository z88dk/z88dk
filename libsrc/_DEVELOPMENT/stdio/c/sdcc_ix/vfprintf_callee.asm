
; int vfprintf_callee(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf_callee, l0_vfprintf_callee

_vfprintf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_vfprintf_callee:

   push hl
   ex (sp),ix
      
   call asm_vfprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf_callee

EXTERN _vfprintf_unlocked_callee

defc _vfprintf_callee = _vfprintf_unlocked_callee
   
INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
