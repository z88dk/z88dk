
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm__fflushall

XREF __stdio_file_list_open

LIB asm0_fflush, asm_p_forward_list_front
LIB __stdio_lock_file_list, __stdio_unlock_file_list

asm__fflushall:

   ; enter : none
   ;
   ; exit  : ix = 0
   ;         carry reset
   ;
   ; uses  : all

   call __stdio_lock_file_list     ; acquire list lock

   ld hl,__stdio_file_list_open

file_loop:

   call asm_p_forward_list_front

   push hl
   pop ix

   jp c, __stdio_unlock_file_list  ; if no more open files in list

   push hl   
   call asm0_fflush
   pop hl
   
   jr file_loop

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
