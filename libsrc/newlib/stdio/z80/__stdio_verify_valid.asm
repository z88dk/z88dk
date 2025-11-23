
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_verify_valid

EXTERN __p_forward_list_locate_item, error_ebadf_mc
EXTERN __stdio_open_file_list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__stdio_verify_valid:

   ; Verify that FILE is on the open list
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set, errno = ebadf if invalid FILE
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
   scf
   jr z, invalid_file_0

   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_open_file_list
   call __p_forward_list_locate_item

invalid_file_0:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push af
   
   call __stdio_unlock_file_list
   
   pop af

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de
   pop bc
   jr c, invalid_file_1

valid_file:

   pop af
   pop hl
   
   or a
   ret
   
invalid_file_1:

   pop af
   jp error_ebadf_mc - 1
