
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putchar(int c)
;
; Write char to stdout.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_putchar

EXTERN _stdout
EXTERN asm0_putchar_unlocked, __stdio_lock_release

asm_putchar:

   ; enter :  l = char c
   ;
   ; exit  : ix unchanged
   ;
   ;         success
   ;
   ;            hl = char c
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except ix

   push ix
   ld ix,(_stdout)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid_lock

   call __stdio_verify_valid_lock
   jr c, putchar_exit

ELSE

   EXTERN __stdio_lock_acquire, error_enolck_mc

   call __stdio_lock_acquire
   jr c, putchar_enolck

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call asm0_putchar_unlocked
   call __stdio_lock_release

putchar_exit:

   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF !(__CLIB_OPT_STDIO & $01)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

putchar_enolck:

   pop ix
   jp error_enolck_mc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_putchar

EXTERN asm_putchar_unlocked

defc asm_putchar = asm_putchar_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
