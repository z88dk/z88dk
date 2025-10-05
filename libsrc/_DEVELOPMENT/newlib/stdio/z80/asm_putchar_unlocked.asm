
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putchar_unlocked(int c)
;
; Write char to stdout.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_putchar_unlocked
PUBLIC asm0_putchar_unlocked

EXTERN _stdout
EXTERN asm0_fputc_unlocked

asm_putchar_unlocked:

   ; enter :  l = char c
   ;
   ; exit  : ix = FILE *stdout
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
   ; uses  : all

   ld ix,(_stdout)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_putchar_unlocked:
   
   ld e,l
   jp asm0_fputc_unlocked
