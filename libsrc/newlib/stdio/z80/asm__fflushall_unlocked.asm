
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm__fflushall_unlocked

EXTERN __stdio_open_file_list
EXTERN asm1_fflush_unlocked, asm_p_forward_list_next

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

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
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list   ; acquire list lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_open_file_list

file_loop:

   call asm_p_forward_list_next

   push hl
   pop ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   jp z, __stdio_unlock_file_list  ; if no more open files in list

ELSE

   ret z                           ; if no more open files in list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push hl
   
   call asm1_fflush_unlocked
   
   pop hl
   jr file_loop
