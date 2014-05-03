
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *freopen(char *filename, char *mode, FILE *stream)
;
; Reassigns the stream to a different file.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_freopen

LIB asm0_freopen_unlocked, __stdio_verify_valid
LIB __stdio_lock_acquire, error_enolck_zc, error_ebadf_zc

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

   call __stdio_verify_valid
   jp c, error_ebadf_zc        ; if FILE is not valid

   call __stdio_lock_acquire
   jp nc, asm0_freopen_unlocked
   
   jp error_enolck_mc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_freopen

LIB asm_freopen_unlocked

asm_freopen:

   jp asm_freopen_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
