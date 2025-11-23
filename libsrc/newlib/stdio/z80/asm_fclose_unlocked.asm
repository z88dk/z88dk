
; ===============================================================
; Apr 2014
; ===============================================================
; 
; int fclose_unlocked(FILE *stream)
;
; Close the file.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fclose_unlocked, asm0_fclose_unlocked, asm1_fclose_unlocked

EXTERN __stdio_open_file_list, asm_p_forward_list_remove, error_ebadf_mc
EXTERN l_jpix, __fcntl_fd_from_fdstruct
EXTERN asm0_close, __stdio_file_destructor, error_znc, asm_heap_free, __stdio_heap
EXTERN __stdio_closed_file_list, asm_p_forward_list_alt_push_back

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
   ;         fail if invalid FILE
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix, iy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   EXTERN __stdio_lock_file_list
   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_fclose_unlocked:

   ; remove FILE from open list
   
   push ix
   pop bc                      ; bc = FILE *
   
   dec bc
   dec bc                      ; bc = & FILE.link
   
   ld hl,__stdio_open_file_list
   call asm_p_forward_list_remove
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   push af
   
   EXTERN __stdio_unlock_file_list
   call __stdio_unlock_file_list
   
   pop af

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp c, error_ebadf_mc        ; if FILE* is invalid

   ; close FILE and underlying fd
   
   call asm1_fclose_unlocked

   ; append FILE to closed list
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_lock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push ix
   pop de                      ; de = FILE *
   
   dec de
   dec de                      ; de = & FILE.link
   
   ld bc,__stdio_closed_file_list
   call asm_p_forward_list_alt_push_back

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   call __stdio_unlock_file_list

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp error_znc                ; indicate success


asm1_fclose_unlocked:

   ; ix = FILE *

   ; close FILE
   
   ld a,STDIO_MSG_FLSH
   call l_jpix
   
   ld a,STDIO_MSG_CLOS
   call l_jpix
   
   ; memstreams do not have an underlying fd
   
   ld a,(ix+3)
   inc a
   and $07
   
   jr z, close_memstream
   
   ; close any underlying fd
   
   ; ix = FILE *
   
   ld e,(ix+1)
   ld d,(ix+2)                 ; de = FDSTRUCT *
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl
   call __fcntl_lock_fdbtl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __fcntl_fd_from_fdstruct
   jr c, no_underlying_fd

   ld (hl),0
   dec hl
   ld (hl),0                   ; clear fd entry

no_underlying_fd:

   ; de = FDSTRUCT *
   ; ix = FILE *

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_unlock_fdtbl
   call __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push de
   ex (sp),ix                  ; ix = FDSTRUCT *
   
   ; ix = FDSTRUCT *
   ; stack = FILE *

   ld c,2                      ; ref_count_adj = 2
   call asm0_close             ; close underlying fd
   
   pop ix                      ; ix = FILE *

   ; disassociate FILE
   
   jp __stdio_file_destructor

close_memstream:

   ; ix = FILE *
   
   push ix
   pop hl                      ; hl = FILE *
   
   dec hl
   dec hl                      ; hl = & FILE.link
   
   ld de,(__stdio_heap)
   call asm_heap_free          ; memstream FILE allocated from stdio heap
   
   jp error_znc                ; indicate success
