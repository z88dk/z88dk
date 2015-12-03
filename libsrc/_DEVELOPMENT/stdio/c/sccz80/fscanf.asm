
; int fscanf(FILE *stream, const char *format, ...)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fscanf

EXTERN asm_fscanf

defc fscanf = asm_fscanf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fscanf

EXTERN fscanf_unlocked

defc fscanf = fscanf_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
