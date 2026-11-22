
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *freopen(char *filename, char *mode, FILE *stream)
;
; Reassigns the stream to a different file.
;
; ===============================================================

INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_freopen

EXTERN asm0_freopen_unlocked, __stdio_lock_release
EXTERN __stdio_verify_valid_lock, error_zc

asm_freopen:

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

   call __stdio_verify_valid_lock
   jp c, error_zc              ; if FILE invalid

   push hl                     ; save filename

   call asm0_freopen_unlocked
   
   pop bc                      ; bc = filename
   ret c                       ; if error, FILE is closed
   
   ld a,b
   or c
   ret nz                      ; if FILE was replaced
   
   jp __stdio_lock_release     ; if FILE was modified (mode change)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_freopen

EXTERN asm_freopen_unlocked

defc asm_freopen = asm_freopen_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
