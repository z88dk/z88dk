
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fscanf_unlocked(FILE *stream, const char *format, ...)
;
; See C11 specification.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_fscanf_unlocked

EXTERN asm_vfscanf_unlocked, __stdio_varg_2, __stdio_nextarg_de

asm_fscanf_unlocked:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
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
   ;            hl will be -1 on eof and stream in error state
   ;            carry set, errno set as below
   ;
   ;            eacces = stream not open for reading
   ;            eacces = stream is in an error state
   ;            einval = unknown conversion specifier
   ;            einval = error during scanf conversion
   ;            erange = width out of range
   ;
   ;            more errors may be set by underlying driver
   ;
   ; uses  : all

   call __stdio_varg_2
   
   push de
   pop ix                      ; ix = FILE *
   
   call __stdio_nextarg_de     ; de = char *format
   
   ld c,l
   ld b,h                      ; bc = void *arg
   
   jp asm_vfscanf_unlocked
