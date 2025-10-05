
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getchar(void)
;
; Read char from stdin.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_getchar

EXTERN _stdin

EXTERN asm_fgetc

asm_getchar:

   ; enter : none
   ;
   ; exit  : ix = FILE *stdin
   ;
   ;         if success
   ;
   ;            hl = char
   ;            carry reset
   ;
   ;         if fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all

   ld ix,(_stdin)
   jp asm_fgetc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_getchar

EXTERN asm_getchar_unlocked

defc asm_getchar = asm_getchar_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
