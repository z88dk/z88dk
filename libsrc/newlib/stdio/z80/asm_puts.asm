
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int puts(const char *s)
;
; Write string to stdout followed by a '\n'.
; Return number of bytes written.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_puts

EXTERN _stdout
EXTERN asm0_puts_unlocked, __stdio_lock_release

asm_puts:

   ; enter : hl = char *s
   ;
   ; exit  : ix unchanged
   ;
   ;         success
   ;
   ;            hl = strlen(s) + 1
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
   jr c, puts_exit

ELSE

   EXTERN __stdio_lock_acquire, error_enolck_mc

   call __stdio_lock_acquire
   jr c, puts_enolck

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call asm0_puts_unlocked
   call __stdio_lock_release

puts_exit:

   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF !(__CLIB_OPT_STDIO & $01)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

puts_enolck:

   pop ix
   jp error_enolck_mc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_puts

EXTERN asm_puts_unlocked

defc asm_puts = asm_puts_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
