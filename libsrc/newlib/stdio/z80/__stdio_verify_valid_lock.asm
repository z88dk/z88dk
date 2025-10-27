
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_verify_valid_lock

EXTERN __p_forward_list_locate_item, __stdio_lock_acquire
EXTERN error_ebadf_mc, error_enolck_mc

EXTERN __stdio_open_file_list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__stdio_verify_valid_lock:

   ; Verify that FILE is on the open list and then lock it
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set, errno set if error
   ;
   ; uses  : none, except hl=-1 on error

   push hl
   push af
   push bc
   push de

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push ix
   pop bc

   ld a,b
   or c
   jr z, exit_error_ebadf

   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_open_file_list
   call __p_forward_list_locate_item

   jr c, exit_error_ebadf

   call __stdio_lock_acquire

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push af
   
   call __stdio_unlock_file_list
   
   pop af

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de
   pop bc
   jr c, exit_error_enolck

exit_success:

   pop af
   pop hl
   
   or a
   ret

exit_error_ebadf:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04
   
   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de
   pop bc
   pop af

   jp error_ebadf_mc - 1
   
exit_error_enolck:

   pop af
   jp error_enolck_mc - 1
