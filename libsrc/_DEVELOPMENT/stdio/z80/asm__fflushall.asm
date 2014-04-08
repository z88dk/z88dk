
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm__fflushall

XREF __stdio_file_list_lock, __stdio_file_list_open

LIB asm0_fflush, asm_mtx_lock, asm_mtx_unlock, asm_p_forward_list_front

asm__fflushall:

   ; enter : none
   ;
   ; exit  : ix = 0
   ;         carry reset
   ;
   ; uses  : all

lock_acquire:

   ld hl,__stdio_file_list_lock
   call asm_mtx_lock           ; acquire list lock
   
   jr c, lock_acquire          ; do not accept lock error on stdio lock

   ld hl,__stdio_file_list_open

file_loop:

   call asm_p_forward_list_front

   push hl
   pop ix

   jr c, end_loop              ; if no more open files in list

   push hl   
   call asm0_fflush
   pop hl
   
   jr file_loop

end_loop:

   ld hl,__stdio_file_list_lock
   jp asm_mtx_unlock           ; release list lock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm__fflushall

LIB asm__fflushall_unlocked

asm__fflushall:

   jp asm__fflushall_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
