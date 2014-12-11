
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread

_fread:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   
   push bc
   exx
   push hl
   push bc
   push de
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_fread
   
   pop ix
   ret
   
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
