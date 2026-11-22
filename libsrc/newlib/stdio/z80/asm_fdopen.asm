
; ===============================================================
; Jan 2014
; ===============================================================
; 
; FILE *fdopen(int fd, const char *mode)
;
; Attach a stream to an underlying file descriptor.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fdopen

EXTERN __stdio_parse_mode, __fcntl_fdstruct_from_fd_2
EXTERN error_einval_zc, error_zc, __stdio_file_allocate
EXTERN __fcntl_fdchain_descend, __stdio_file_init
EXTERN __stdio_file_add_list, __stdio_file_deallocate

asm_fdopen:

   ; enter : hl = int fd
   ;         de = char *mode
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix
   
   ; check mode string
   
   push hl                     ; save fd
   
   call __stdio_parse_mode
   jp c, error_einval_zc - 1   ; if mode string is invalid
   
   pop hl
   
   ; allocate a FILE struct
   
   push bc                     ; save mode byte
   push hl                     ; save fd
   
   call __stdio_file_allocate
   jp c, error_zc - 2          ; if FILE not available

   ; look up FDSTRUCT attached to fd

   ex (sp),hl                  ; hl = fd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_lock_fdtbl
   call __fcntl_lock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call __fcntl_fdstruct_from_fd_2
   
   pop hl                      ; hl = FILE *
   pop bc                      ; c = mode byte
   
   jr c, deallocate_file       ; if bad fd

   ; ix = de = FDSTRUCT *
   ; hl = FILE *
   ;  c = mode byte = 0TXC BAWR

   ; check compatibility of requested mode

   ld a,c
   and $07
   ld c,a                      ; only interested in RWA bits

   and (ix+8)                  ; compare to fd mode bits
   cp c
   
   jr nz, exit_einval          ; if requested mode cannot be supported
   
   ; increase fdstruct chain reference count
   
   ld a,(ix+6)
   and $27
   ld b,a
   
   push bc                     ; save FILE type
   push de                     ; save FDSTRUCT *

chain_loop:
   
   ld a,(ix+7)                 ; a = reference count
   dec a
   
   jr z, ref_count_1           ; if ref_count == 1, set ref_count = 2
   inc a                       ; otherwise increase ref_count by 2
   
ref_count_1:

   inc a
   inc a                       ; increase reference count by 2

   ld (ix+7),a
   
   call __fcntl_fdchain_descend
   jr nz, chain_loop           ; visit all FDTSRUCTs in chain

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_unlock_fdtbl
   call __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop de                      ; de = FDSTRUCT *
   pop bc                      ;  b = FILE type

   ; de = FDSTRUCT *
   ; hl = FILE *
   ;  c = mode byte (RWA only)
   ;  b = FILE type
   
   ; initialize FILE struct
   
   call __stdio_file_init
   
   ; add FILE to open list
   
   push hl                     ; save FILE *
   
   call __stdio_file_add_list
   
   pop hl                      ; hl = FILE *
   
   or a
   ret

exit_einval:

   call deallocate_file
   jp error_einval_zc

deallocate_file:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $08

   EXTERN __fcntl_unlock_fdtbl
   call __fcntl_unlock_fdtbl

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; hl = FILE *
   
   ex de,hl
   call __stdio_file_deallocate
   
   jp error_zc
