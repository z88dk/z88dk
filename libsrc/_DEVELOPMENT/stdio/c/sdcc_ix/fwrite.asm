
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fwrite

_fwrite:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push bc
   push hl
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
      
   call asm_fwrite
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fwrite.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fwrite

EXTERN _fwrite_unlocked

defc _fwrite = _fwrite_unlocked
   
INCLUDE "stdio/z80/asm_fwrite.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
