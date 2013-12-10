
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int at_quick_exit(void (*func)(void))
;
; Register the function to run when quick_exit() is called.
; Return 0 if successful.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB at_quick_exit
LIB asm0_atexit

at_quick_exit:
asm_at_quick_exit:

   ; enter : hl = func
   ;
   ; exit  : hl = 0 and carry reset if successful
   ;         hl = nonzero and carry set if unsuccessful
   ;
   ; uses  : af, bc, de, hl

   ex de,hl                    ; de = func
   
   ld hl,__quickexit_stack
   ld a,__QUICK_EXITSTACK_SZ

   jp asm0_atexit
