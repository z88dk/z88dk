
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vprintf(const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_vprintf

EXTERN _stdout

EXTERN asm_vfprintf

asm_vprintf:

   ; enter : de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *stdout
   ;         de = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            hl = number of chars output on stream
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = - (chars output + 1) < 0
   ;            carry set, errno set as below
   ;
   ;            enolck = stream lock could not be acquired
   ;            eacces = stream not open for writing
   ;            eacces = stream is in an error state
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;
   ;            more errors may be set by underlying driver
   ;            
   ; uses  : all

   ld ix,(_stdout)
   jp asm_vfprintf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_vprintf

EXTERN asm_vprintf_unlocked

defc asm_vprintf = asm_vprintf_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
