
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

XREF STDIO_MSG_CLOS
XREF __stdio_file_list_avail, __stdio_file_list_open

LIB l_jpix, asm_free, __stdio_file_destroy
LIB asm_p_forward_list_remove, asm_p_forward_list_alt_push_back
LIB error_znc, error_mc, error_ebadf_mc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

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
   
   ld a,STDIO_MSG_CLOS         ; deliver close message
   call l_jpix
   
   push af                     ; save error status
   
   ld a,(ix+3)                 ; examine FILE type
   and $07
   
   jr nz, memstream            ; if FILE type == memstream
   
   call __stdio_file_destroy   ; FILE structure is disassociated

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

   call __stdio_lock_file_list   ; acquire stdio lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld c,ixl
   ld b,ixh
   
   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_file_list_open
   call asm_p_forward_list_remove  ; remove FILE from open list
   
   jr c, file_invalid          ; if FILE is not in open list
   
   ld e,c
   ld d,b                      ; de = & FILE.link
   
   ld bc,__stdio_file_list_avail
   call asm_p_forward_list_alt_push_back  ; add FILE to end of available list

file_invalid:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD

   call __stdio_unlock_file_list  ; release stdio lock

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   pop af                      ; error status
   
   jp nc, error_znc
   jp error_mc

memstream:

   pop af                      ; error status
   jp c, error_mc              ; if this is an invalid FILE

   push ix
   pop hl
   
   call asm_free
   jp error_znc

