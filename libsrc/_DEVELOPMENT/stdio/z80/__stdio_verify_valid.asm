
INCLUDE "clib_cfg.asm"

XLIB __stdio_verify_valid

LIB __p_forward_list_locate_item

XREF __stdio_file_list_open

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

LIB __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__stdio_verify_valid:

   ; Verify that FILE is on the open list
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if problem
   ;
   ; uses  : none

   push hl
   push af
   push bc
   push de

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld c,ixl
   ld b,ixh
   
   ld a,b
   or c
   jr z, invalid_file
   
   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_file_list_open
   call __p_forward_list_locate_item
   
   jr c, invalid_file

valid_file:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de
   pop bc
   pop af
   pop hl
   
   or a
   ret

invalid_file:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de
   pop bc
   pop af
   pop hl
   
   scf
   ret
