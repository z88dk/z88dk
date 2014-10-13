
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread

_fread:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   
   push ix
   push hl
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fread.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread

EXTERN _fread_unlocked

defc _fread = _fread_unlocked
   
INCLUDE "stdio/z80/asm_fread.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
