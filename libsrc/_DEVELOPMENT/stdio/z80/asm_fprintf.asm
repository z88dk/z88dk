
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fprintf(FILE *stream, const char *format, ...)
;
; See C11 specification.
;
; ===============================================================

XLIB asm_fprintf

LIB asm_vfprintf, asm_fprintf_common

asm_fprintf:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : ix = FILE *
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
   
   call asm_fprintf_common     ; collect parameters
   
   jp asm_vfprintf
