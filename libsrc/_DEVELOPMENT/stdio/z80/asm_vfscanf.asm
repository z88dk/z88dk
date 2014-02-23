
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vfscanf(FILE *stream, const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

XLIB asm_vfscanf

LIB asm_vfscanf_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_vfscanf:

   ; enter : ix = FILE *
   ;         de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *
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

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_vfscanf_unlocked
   jp __stdio_lock_release
