
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

XLIB asm_fclose_unlocked

LIB asm_p_forward_list_remove, asm_p_forward_list_alt_push_back
LIB error_ebadf_mc, error_znc, __stdio_file_destroy, asm_free, l_jpix

XREF STDIO_MSG_CLOS
XREF __stdio_file_list_open, __stdio_file_list_avail

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

LIB __stdio_lock_file_list, __stdio_unlock_file_list

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

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld c,ixl
   ld b,ixh
   
   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_remove

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push af                     ; save error state
   
   call __stdio_unlock_file_list

   pop af

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp c, error_ebadf_mc        ; if FILE is not in open list
   
   ; close FILE
   
   ld a,STDIO_MSG_CLOS
   call l_jpix                 ; deliver close message
   
   ld a,(ix+3)                 ; examine FILE type
   and $07
   jr nz, close_memstream      ; if FILE type == memstream
   
   ; disassociate FILE
   
   call __stdio_file_destroy   ; FILE returns ebadf errors
   
   ; append FILE to available list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

   push ix
   pop hl
   
   dec hl
   dec hl                      ; hl = & FILE.link
   
   call asm_free
   jp error_znc
