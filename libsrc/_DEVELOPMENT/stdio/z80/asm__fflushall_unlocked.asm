
XLIB asm__fflushall_unlocked

INCLUDE "clib_cfg.asm"

XREF __stdio_file_list_open

LIB asm0_fflush_unlocked, asm_p_forward_list_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

XREF __stdio_file_list_lock
LIB asm_mtx_lock, asm_mtx_unlock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm__fflushall_unlocked:

   ; enter : none
   ;
   ; exit  : ix = 0
   ;         carry reset
   ;
   ; uses  : all

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

lock_acquire:

   ld hl,__stdio_file_list_lock
   call asm_mtx_lock           ; acquire list lock
   
   jr c, lock_acquire          ; do not accept lock error on stdio lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_file_list_open

file_loop:

   call asm_p_forward_list_front

   push hl
   pop ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

   jr c, end_loop

ELSE

   ccf
   ret nc                      ; if no more open files in list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push hl   
   call asm0_fflush_unlocked
   pop hl
   
   jr file_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

end_loop:

   ld hl,__stdio_file_list_lock
   jp asm_mtx_unlock           ; release list lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
