
; ===============================================================
; Nov 2013
; ===============================================================
; 
; _Noreturn void quick_exit(int status)
;
; Execute functions registered by at_quick_exit() and then exit
; program via _Exit(status).
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_quick_exit

EXTERN __quickexit_stack

EXTERN asm0_exit

asm_quick_exit:

   ; enter : hl = status
   
   ld de,__quickexit_stack
   jp asm0_exit
