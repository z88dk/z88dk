
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)
;
; Reassigns the stream to a different file.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

XLIB asm_freopen_unlocked

LIB l_jpix, __stdio_file_destroy, __stdio_parse_permission, asm0_fopen_unlocked
LIB asm_open, error_ebadf_zc, error_enotsup_zc, error_einval_zc, error_zc

XREF STDIO_MSG_CLOS

asm_freopen_unlocked:

   ; enter : ix = FILE *
   ;         de = char *mode
   ;         hl = char *filename
   ; 
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : all except ix

   push hl                     ; save filename
   push de                     ; save mode
   
   ld a,STDIO_MSG_CLOS         ; deliver close message
   call l_jpix
   
   jp c, error_ebadf_zc - 2    ; if FILE is not valid
   
   ld a,(ix+3)
   and $07                     ; af = FILE type
   
   push af
   
   call __stdio_file_destroy   ; FILE now reports as bad
   
   pop af
   ld (ix+3),a                 ; FILE type is preserved
   
   pop de                      ; de = mode
   jp nz, error_enotsup_zc - 1 ; freopen on memstream not currenty supported

   call __stdio_parse_permission
   
   pop de                      ; de = filename
   jp c, error_einval_zc       ; if mode string is invalid
   
   ld a,d
   or e
   jp z, error_enotsup_zc      ; filename == NULL not currently supported
   
   ;  c = mode byte
   ; de = filename
   
   push bc                     ; save mode byte
   
   call asm_open               ; pass details to target open()
   
   pop bc                      ; c = mode byte
   jp c, error_zc              ; if open failed
   
   ;  c = mode byte
   ; de = driver_function
   
   push ix
   pop hl
   
   jp asm0_fopen_unlocked      ; fill out the FILE struct
