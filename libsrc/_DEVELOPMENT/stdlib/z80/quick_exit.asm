
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

INCLUDE "../../crt_vars.inc"

XLIB quick_exit
XDEF asm_quick_exit

LIB asm0_exit

quick_exit:
asm_quick_exit:

   ; enter : hl = status
   
   ld de,__quickexit_stack
   jp asm0_exit
