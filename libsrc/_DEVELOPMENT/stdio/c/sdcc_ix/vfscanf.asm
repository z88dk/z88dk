
; int vfscanf(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf

_vfscanf:

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
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_vfscanf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vfscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf

EXTERN _vfscanf_unlocked

defc _vfscanf = _vfscanf_unlocked
   
INCLUDE "stdio/z80/asm_vfscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
