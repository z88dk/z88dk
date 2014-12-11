
; FILE *freopen(char *filename, char *mode, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC freopen_callee

freopen_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_freopen.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC freopen_callee

EXTERN freopen_unlocked_callee

defc freopen_callee = freopen_unlocked_callee
   
INCLUDE "stdio/z80/asm_freopen.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
