
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int sprintf(char *s, const char *format, ...)
;
; As fprintf but output is directed to a string.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_sprintf

EXTERN asm_vsprintf, __stdio_varg_2, __stdio_nextarg_de

asm_sprintf:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;         hl' = char *s (address of terminating '\0')
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
   ; note  : High level stdio uses hl' to track number of chars
   ;         written to the stream but modifies no other exx registers
   ;            
   ; uses  : all

   call __stdio_varg_2         ; de = char *s
   
   push hl
   exx
   pop hl
   
   call __stdio_nextarg_de     ; de = char *format
   
   ld c,l
   ld b,h                      ; bc = void *arg

   jp asm_vsprintf
