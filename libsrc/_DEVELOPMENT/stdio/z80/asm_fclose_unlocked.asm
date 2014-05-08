
; ===============================================================
; Apr 2014
; ===============================================================
; 
; int fclose_unlocked(FILE *stream)
;
; Close the file.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm_fclose_unlocked
PUBLIC asm0_fclose_unlocked

EXTERN asm_p_forward_list_remove, asm_p_forward_list_alt_push_back
EXTERN error_ebadf_mc, error_znc, __stdio_file_destroy, asm_free, l_jpix

EXTERN STDIO_MSG_CLOS
EXTERN __stdio_file_list_open, __stdio_file_list_avail

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

EXTERN __stdio_lock_file_list, __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_fclose_unlocked:

   ; enter : ix = FILE *
   ; 
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix

   ; attempt to remove FILE from open list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

   ; must hang onto this lock until done
   ; to avoid deadlock problems

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_fclose_unlocked:

   ld c,ixl
   ld b,ixh
   
   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_remove

   jr c, exit_error_ebadf
   
   ; close FILE

   ld a,STDIO_MSG_CLOS
   call l_jpix                 ; deliver close message
   
   ld a,(ix+3)                 ; examine FILE type
   and $07
   jr nz, close_memstream      ; if FILE type == memstream
   
   ; disassociate FILE
   
   call __stdio_file_destroy   ; FILE returns ebadf errors
   
   ; append FILE to available list

   ld e,ixl
   ld d,ixh
   
   dec de
   dec de                      ; de = & FILE.link
   
   ld bc,__stdio_file_list_avail
   call asm_p_forward_list_alt_push_back

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; success
   
   jp error_znc

close_memstream:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push ix
   pop hl
   
   dec hl
   dec hl                      ; hl = & FILE.link
   
   call asm_free
   jp error_znc

exit_error_ebadf:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp error_ebadf_mc
