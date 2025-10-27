
; ===============================================================
; Jan 2015
; ===============================================================
; 
; _Noreturn void abort(void)
;
; Signals not supported so just jump to _Exit.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_abort

EXTERN __Exit

asm_abort:

   ld hl,-1
   jp __Exit
