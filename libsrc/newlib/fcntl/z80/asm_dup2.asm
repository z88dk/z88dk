
; ===============================================================
; October 2014
; ===============================================================
; 
; int dup2(int fd, int fd2)
;
; Duplicates the file descriptor into fd2.
; If fd2 is an open file, close it first.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_dup2, asm0_dup2

EXTERN __fcntl_fdstruct_from_fd_1, __fcntl_fdstruct_from_fd_2, asm0_close
EXTERN error_ebdfd_mc, __fcntl_inc_refcount

asm_dup2:

   ; enter : hl = int fd
   ;         de = int fd2
   ;
   ; exit  : success
   ;
   ;            hl = fd2
   ;            ix = FDSTRUCT*
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl, __fcntl_unlock_fdtbl
   
   call __fcntl_lock_fdtbl
   call asm0_dup2
   jp __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_dup2:

   push de                     ; save fd2

   call __fcntl_fdstruct_from_fd_2
   jp c, error_ebdfd_mc - 1    ; if fd is invalid

   ; de = FDSTRUCT* (fd)
   ; stack = fd2

   pop hl                      ; hl = fd2
   
   push hl                     ; save fd2
   push de                     ; save FDSTRUCT* (fd)
   
   call __fcntl_fdstruct_from_fd_1
   jp c, error_ebdfd_mc - 2    ; if fd2 is out of range

   ; de = FDSTRUCT* (fd2)
   ; hl = & fdtbl[fd2] + 1b
   ; z flag set if de = 0
   ; stack = fd2, FDSTRUCT* (fd)

   jr z, fd2_vacant            ; if fd2 is vacant
   
   push hl                     ; save & fdtbl[fd2] + 1b
   
   push de
   pop ix                      ; ix = FDSTRUCT* (fd2)
   
   ld c,1
   call asm0_close             ; close(fd2)
   
   pop hl

fd2_vacant:

   ; hl = & fdtbl[fd2] + 1b
   ; stack = fd2, FDSTRUCT* (fd)

   pop de                      ; de = FDSTRUCT* (fd)
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; dup FDSTRUCT into fd2
   
   push de
   pop ix                      ; ix = FDSTRUCT* (fd)
   
   pop hl                      ; hl = fd2
   
   ld c,1                      ; ref_count += 1
   jp __fcntl_inc_refcount
