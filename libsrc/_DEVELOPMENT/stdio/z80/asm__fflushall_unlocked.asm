
INCLUDE "clib_cfg.asm"

XLIB asm__fflushall_unlocked

XREF __stdio_file_list_open

LIB asm0_fflush_unlocked, asm_p_forward_list_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

LIB __stdio_lock_file_list, __stdio_unlock_file_list

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

   call __stdio_lock_file_list   ; acquire list lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_file_list_open

file_loop:

   call asm_p_forward_list_front

   push hl
   pop ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

   jp c, __stdio_unlock_file_list  ; if no more open files in list

ELSE

   ccf
   ret nc                      ; if no more open files in list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push hl   
   call asm0_fflush_unlocked
   pop hl
   
   jr file_loop
