
; ===============================================================
; Apr 2014
; ===============================================================
; 
; int fclose(FILE *stream)
;
; Close the file.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fclose

EXTERN asm0_fclose_unlocked
EXTERN __stdio_lock_acquire, error_enolck_mc

asm_fclose:

   ; enter : ix = FILE *
   ; 
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $04

   EXTERN __stdio_lock_file_list
   call __stdio_lock_file_list
   
   call __stdio_lock_acquire
   jp nc, asm0_fclose_unlocked
   
   EXTERN __stdio_unlock_file_list
   call __stdio_unlock_file_list
   
   jp error_enolck_mc

ELSE

   call __stdio_lock_acquire
   jp nc, asm0_fclose_unlocked
   
   jp error_enolck_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_fclose

EXTERN asm_fclose_unlocked

defc asm_fclose = asm_fclose_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
