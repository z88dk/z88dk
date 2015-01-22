
; int vfprintf(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf

_vfprintf:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push bc
   push af
   
   push bc
   exx

   ex (sp),ix
      
   call asm_vfprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf

EXTERN _vfprintf_unlocked

defc _vfprintf = _vfprintf_unlocked
   
INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
