
; ===============================================================
; October 2014
; ===============================================================
; 
; ssize_t read(int fd, void *buf, size_t nbyte)
;
; Read a maximum of nbytes bytes from the stream.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_read

EXTERN __fcntl_fdstruct_from_fd_2, l_jpix
EXTERN error_znc, error_mc, error_eacces_mc

asm_read:

   ; enter : hl = int fd
   ;         de = void *buf
   ;         bc = size_t nbyte
   ;
   ; exit  : success
   ;
   ;            hl = number of bytes read
   ;            de'= void *buf + num bytes read
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
   jp z, error_znc             ; if nbyte == 0 indicate no bytes read

   push bc                     ; save nbyte
   push hl                     ; save fd
   
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
   ; de'= void *buf
   ; bc'= nbyte > 0
   
   bit 0,(ix+8)
   jp z, error_eacces_mc       ; if reads not allowed
   
   ld a,STDIO_MSG_READ
   call l_jpix                 ; deliver message to driver

   jr c, fail

success:

   ld l,c
   ld h,b                      ; hl = num bytes read
   
   ret

fail:

   ld a,b
   or c
   jr nz, success              ; success if num bytes read != 0
   
   inc l
   jp z, error_znc             ; if at eof return num bytes read == 0
   
   jp error_mc                 ; indicate error
