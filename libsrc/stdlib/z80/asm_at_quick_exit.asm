
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

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_at_quick_exit

EXTERN __quickexit_stack, __quickexit_stack_size
EXTERN asm0_atexit

asm_at_quick_exit:

   ; enter : hl = func
   ;
   ; exit  : hl = 0 and carry reset if successful
   ;         hl = nonzero and carry set if unsuccessful
   ;
   ; uses  : af, bc, de, hl

   ex de,hl                    ; de = func
   
   ld hl,__quickexit_stack
   ld a,__quickexit_stack_size

   jp asm0_atexit
