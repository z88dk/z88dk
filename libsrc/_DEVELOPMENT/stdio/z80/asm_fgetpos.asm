
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fgetpos(FILE *stream, fpos_t *pos)
;
; Write current file position to pos.
;
; This implementation does not support multibyte character sets
; so the value written to pos is the same as returned by ftell().
;
; ===============================================================

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_fgetpos

LIB asm_fgetpos_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fgetpos:

   ; enter :   ix = FILE *
   ;           hl = fpos_t *pos
   ;
   ; exit  :   ix = FILE *
   ;
   ;         success
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = -1
   ;           carry set
   ;
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fgetpos_unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB asm_fgetpos

LIB asm_fgetpos_unlocked

asm_fgetpos:

   jp asm_fgetpos_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
