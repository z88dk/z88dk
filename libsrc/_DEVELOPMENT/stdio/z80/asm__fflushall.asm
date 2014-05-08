
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__fflushall

EXTERN __stdio_file_list_open

EXTERN asm1_fflush_unlocked, asm_p_forward_list_front
EXTERN __stdio_lock_acquire, __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm__fflushall:

   ; enter : none
   ;
   ; exit  : ix = 0
   ;         carry reset
   ;
   ; uses  : all
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_file_list_open

file_loop:

   call asm_p_forward_list_front

   push hl
   pop ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   jp c, __stdio_unlock_file_list

ELSE

   ccf
   ret nc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push hl
   
   call __stdio_lock_acquire
   
   call asm1_fflush_unlocked
   
   call __stdio_lock_release
   
   pop hl
   jr file_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__fflushall

EXTERN asm__fflushall_unlocked

asm__fflushall:

   jp asm__fflushall_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
