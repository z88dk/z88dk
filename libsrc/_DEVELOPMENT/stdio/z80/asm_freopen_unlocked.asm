
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
XDEF asm0_freopen_unlocked

LIB __stdio_verify_valid, l_jpix, __stdio_file_destroy
LIB __stdio_parse_permission, asm_open, asm0_fopen_unlocked
LIB error_ebadf_zc, error_eacces_zc, error_einval_zc, error_zc

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

   ; TODO:
   ; * change mode when filename == NULL
   ; * freopen on memstreams

   call __stdio_verify_valid
   jp c, error_ebadf_zc        ; if FILE is not valid

asm0_freopen_unlocked:

   push hl                     ; save filename
   push de                     ; save mode
   
   ld a,STDIO_MSG_CLOS         ; deliver close message
   call l_jpix
   
   ld a,(ix+3)
   and $07                     ; af = FILE type

   push af
   
   call __stdio_file_destroy   ; FILE now reports as bad
   
   pop af
   ld (ix+3),a                 ; FILE type is preserved
   
   pop de                      ; de = mode
   jp nz, error_eacces_zc - 1  ; freopen on memstream not currenty supported

   call __stdio_parse_permission
   
   pop de                      ; de = filename
   jp c, error_einval_zc       ; if mode string is invalid

   ld a,d
   or e
   jp z, error_eacces_zc       ; changing mode not yet supported

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
