
; ===============================================================
; October 2014
; ===============================================================
; 
; ssize_t write(int fd, const void *buf, size_t nbyte)
;
; Write nbyte bytes to the stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_write

EXTERN __fcntl_fdstruct_from_fd_2, l_jpix
EXTERN error_znc, error_mc, error_eacces_mc

asm_write:

   ; enter : hl = int fd
   ;         de = void *buf
   ;         bc = size_t nbyte
   ;
   ; exit  : success
   ;
   ;            hl = number of bytes written
   ;            hl'= void *buf + num bytes written
   ;            carry reset
   ;
   ;         fail on stream error
   ;
   ;            hl = -1
   ;            carry set, errno set
   ; 
   ; uses  : af, bc, de, hl, exx, ix
   
   ld a,b
   or c
   jp z, error_znc             ; if nbyte == 0 indicate no bytes written

   push bc                     ; save nbyte
   push hl                     ; save fd
   
   ex de,hl                    ; hl = void *buf
   
   exx
   
   pop hl                      ; hl = fd
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl
   call __fcntl_lock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __fcntl_fdstruct_from_fd_2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_unlock_fdtbl
   call __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop hl                      ; hl = nbyte
   jp c, error_mc              ; if fd is invalid
   
   ; ix = FDSTRUCT *
   ; hl = nbyte > 0
   ; hl'= void *buf
   ; bc'= nbyte > 0
   
   bit 1,(ix+8)
   jp z, error_eacces_mc       ; if write not allowed
   
   ld a,STDIO_MSG_WRIT
   call l_jpix                 ; deliver message to driver
   
   ret nc                      ; if successful, hl = num bytes written

   ld a,h
   or l
   ret nz                      ; if num bytes written > 0, indicate success
   
   jp error_mc                 ; indicate failure
