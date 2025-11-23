
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int sscanf(const char *s, const char *format, ...)
;
; See C11 specification.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_sscanf

EXTERN asm_vsscanf, __stdio_varg_2, __stdio_nextarg_de

asm_sscanf:

   ; enter : none
   ;
   ; exit  : bc = char *s (next unexamined char)
   ;         de = char *format (next unexamined char, '\0' on success)
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
   ;            carry set, errno set as below
   ;
   ;            einval = s is NULL
   ;            einval = unknown conversion specifier
   ;            einval = error during scanf conversion
   ;            erange = width out of range
   ;            
   ; uses  : all

   call __stdio_varg_2
   
   push de                     ; save char *s
   
   call __stdio_nextarg_de     ; de = char *format
   
   ld c,l
   ld b,h                      ; bc = void *arg
   
   pop hl                      ; hl = char *s
   
   jp asm_vsscanf
