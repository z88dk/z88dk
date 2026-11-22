
; ===============================================================
; October 2014
; ===============================================================
; 
; int close(int fd)
;
; Flush and then close the file.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_close, asm0_close

EXTERN __fcntl_fdstruct_from_fd_2, __fcntl_fdchain_descend
EXTERN error_mc, error_znc, __stdio_heap, asm_heap_free
EXTERN l_jpix

asm_close:

   ; enter : hl = int fd
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except iy
   
   ; clear fd table entry
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl
   call __fcntl_lock_fdbtl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __fcntl_fdstruct_from_fd_2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   jr c, exit_ebdfd            ; if fd invalid
   
   ld (hl),0
   dec hl
   ld (hl),0                   ; clear fd entry

exit_ebdfd:

   EXTERN __fcntl_unlock_fdtbl
   call __fcntl_unlock_fdbtl
   
   jp c, error_mc              ; if fd invalid

ELSE

   jp c, error_mc              ; if fd invalid
   
   ld (hl),0
   dec hl
   ld (hl),0                   ; clear fd entry

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; adjust reference count

   ld c,1

asm0_close:
   
   ; ix = FDSTRUCT *
   ;  c = ref_count_adj
   
   ld a,(ix+7)
   sub c
   ld (ix+7),a                 ; store adjusted reference count
   
   jr z, close_fdstruct        ; if ref_count reached zero
   jr c, close_fdstruct        ; if ref_count < 0
   
   ; fdstructs further in chain need to be adjusted too
   ; if their reference counts reach zero, it is a bug so attempt fix
   
   ld b,a                      ; b = current max ref_count after adjust
   
ref_count_loop:

   ; ix = FDSTRUCT *
   ;  b = current max ref_count after adjust
   ;  c = ref_count_adj

   call __fcntl_fdchain_descend
   jp z, error_znc             ; return success if end of chain reached
   
   ld a,(ix+7)
   sub c
   jr c, bugged                ; if adjusted ref_count < 0
   
   cp b
   jr c, bugged                ; if adjusted ref_count < parent ref_count
   
   ld b,a                      ; b = possibly larger child ref_count

rejoin_loop:
   
   ld (ix+7),a                 ; store adjusted ref_count
   jr ref_count_loop

bugged:

   ld a,b                      ; inherit parent ref_count to fix
   jr rejoin_loop

close_fdstruct:

   ; fdstruct is being closed
   
   ; ix = FDSTRUCT *
   ;  c = ref_count_adj
   
   push bc                     ; save ref_count_adj

   ld a,STDIO_MSG_FLSH
   call l_jpix

   ld a,STDIO_MSG_CLOS
   call l_jpix
   
   push af                     ; save close flag
   
   push ix
   pop hl                      ; hl = FDSTRUCT *
   
   call __fcntl_fdchain_descend
   push af                     ; save descend flag
   
   ld de,__stdio_heap
   call asm_heap_free          ; free(FDSTRUCT)
   
   pop af                      ; descend flag
   pop de                      ; close flag
   pop bc                      ; c = ref_count_adj
   
   jr nz, asm0_close           ; if chain continues
   
   bit 0,e                     ; check carry flag (close flag)
   jp z, error_znc             ; if close successful   
   
   jp error_mc                 ; if close failed
