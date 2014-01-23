
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int printf(const char *format, ...)
;
; See C11 specification.
;
; ===============================================================

XLIB asm_printf

LIB asm_vprintf, __stdio_varg_2, __stdio_nextarg_de

asm_printf:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
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

   call __stdio_varg_2         ; de = char *format
   
   ld c,l
   ld b,h                      ; bc = void *arg
   
   jp asm_vprintf
