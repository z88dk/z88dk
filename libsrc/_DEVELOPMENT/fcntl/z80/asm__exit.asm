
; ===============================================================
; Oct 2014
; ===============================================================
; 
; _Noreturn void _exit(int status)
;
; "The _Exit() and _exit() functions shall be equivalent."
;
; Exit the program without running the exit stack.
;
; ===============================================================

SECTION code_clib
SECTION code_fcntl

PUBLIC asm__exit

EXTERN __Exit

defc asm__exit = __Exit
