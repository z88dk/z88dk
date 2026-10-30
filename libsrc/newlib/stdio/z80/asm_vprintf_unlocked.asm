
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vprintf_unlocked(const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_vprintf_unlocked

EXTERN _stdout
EXTERN asm_vfprintf_unlocked

asm_vprintf_unlocked:

   ; enter : de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix unchanged
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
   ; uses  : all except ix

   push ix
   ld ix,(_stdout)
   call asm_vfprintf_unlocked
   pop ix
   ret
