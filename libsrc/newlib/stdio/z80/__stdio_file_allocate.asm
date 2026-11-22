
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_file_allocate

EXTERN error_emfile_zc
EXTERN __stdio_closed_file_list, asm_p_forward_list_alt_pop_front

__stdio_file_allocate:

   ; retrieve an available FILE struct from pool
   ;
   ; enter : none
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   EXTERN __stdio_lock_file_list
   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld hl,__stdio_closed_file_list
   call asm_p_forward_list_alt_pop_front

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push af                     ; save error status
   push hl                     ; save & FILE.link
   
   EXTERN __stdio_unlock_file_list
   call __stdio_unlock_file_list
   
   pop hl                      ; hl = & FILE.link
   pop af                      ; carry = error

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   inc hl
   inc hl                      ; hl = FILE *
   
   ret nc
   jp error_emfile_zc          ; if no FILE available
