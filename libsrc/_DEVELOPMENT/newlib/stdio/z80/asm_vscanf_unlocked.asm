
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vscanf_unlocked(const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_vscanf_unlocked

EXTERN _stdin
EXTERN asm_vfscanf_unlocked

asm_vscanf_unlocked:

   ; enter : de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *stdin
   ;         de = char *format (next unexamined char)
   ;         hl = number of items assigned
   ;         de'= number of chars consumed from the stream
   ;         hl'= number of items assigned
   ;
   ;         success
   ;
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl will be -1 on enolck, eof and stream in error state
   ;            carry set, errno set as below
   ;
   ;            enolck = stream lock could not be acquired
   ;            eacces = stream not open for reading
   ;            eacces = stream is in an error state
   ;            einval = unknown conversion specifier
   ;            einval = error during scanf conversion
   ;            erange = width out of range
   ;
   ;            more errors may be set by underlying driver
   ;            
   ; uses  : all except ix

   ld ix,(_stdin)
   jp asm_vfscanf_unlocked
