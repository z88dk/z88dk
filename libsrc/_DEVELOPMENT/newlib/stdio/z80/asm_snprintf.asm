
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int snprintf(char *s, size_t n, const char *format, ...)
;
; As fprintf but output is directed to a string.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_snprintf

EXTERN asm_vsnprintf, __stdio_varg_2, __stdio_nextarg_de

asm_snprintf:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;         hl' = char *s (address of terminating '\0')
   ;         bc' = space remaining in s
   ;
   ;         success
   ;
   ;            hl = number of chars output to string not including '\0'
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = - (chars output + 1) < 0
   ;            carry set, errno set as below
   ;
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;            
   ; uses  : all

   call __stdio_varg_2
   push de                     ; save char *s

   call __stdio_nextarg_de
   push de                     ; save size_t n

   exx

   pop bc
   pop de

   exx

   call __stdio_nextarg_de     ; de = char *format

   ld c,l
   ld b,h                      ; bc = void *arg

   jp asm_vsnprintf
