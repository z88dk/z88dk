
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vprintf(const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

XLIB asm_vprintf

LIB asm_vfprintf

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

   ld ix,(__stdio_file_stdout)
   jp asm_vfprintf
