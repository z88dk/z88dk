
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void call_once(once_flag *flag, void (*func)(void))
;
; Execute the function func() exactly once.
;
; If the function func() has already completed execution,
; immediately return.
;
; If the the function func() is executing but is not yet
; finished, do not return until it is finished executing.
;
; If the function func() has not been run yet, execute it
; and wait to return until it is finished executing.
;
; ===============================================================

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_call_once

EXTERN asm_spinlock_tryacquire, __thread_context_switch, l_jphl

asm_call_once:

   ; enter : hl = once_flag *flag
   ;         de = void (*func)(void)
   ;
   ; uses  : af, bc, de, hl + func()
   
   call asm_spinlock_tryacquire
   inc hl
   
   jr nc, run_function           ; if function has not yet started
   
   ld a,(hl)
   or a
   ret nz                        ; if function has completed execution
   
   dec hl
   
   call __thread_context_switch
   jr asm_call_once

run_function:

   push hl                     ; save once_flag

   ex de,hl
   call l_jphl                 ; execute function
   
   pop hl

   ld (hl),$ff
   ret
