
; ===============================================================
; October 2014
; ===============================================================
; 
; int dup(int fd)
;
; Duplicates the file descriptor into another available fd and
; returns the duplicated fd.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_dup, asm0_dup

EXTERN __fcntl_first_available_fd, __fcntl_fdstruct_from_fd_2
EXTERN __fcntl_fdtbl_size, __fcntl_inc_refcount
EXTERN error_enfile_mc, error_ebdfd_mc

asm_dup:

   ; enter : hl = int fd
   ;
   ; exit  : success
   ;
   ;            ix = FDSTRUCT*
   ;            hl = dup fd
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
   
   call asm0_dup
   
   jp __fcntl_unlock_fdbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_dup:

   push hl                     ; save fd

   call __fcntl_first_available_fd
   
   jp nz, error_enfile_mc - 1  ; if free spot unavailable

   ld a,__fcntl_fdtbl_size
   sub b
 
   ex (sp),hl
   push af
   
   ; hl = int fd
   ; stack = & fdtbl[fd] + 1b, available fd
   
   call __fcntl_fdstruct_from_fd_2
   
   jp c, error_ebdfd_mc - 2    ; if fd is invalid
   
   ; ix = de = FDSTRUCT *
   ; stack = & fdtbl[fd] + 1b, available fd

   pop af                      ; a = available fd, carry reset
   pop hl                      ; hl = & fdtbl[fd] + 1b
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; duplicate FDSTRUCT* into new fd
   
   ld l,a
   ld h,0                      ; hl = new fd
   
   ld c,1                      ; ref_count += 1
   jp __fcntl_inc_refcount
