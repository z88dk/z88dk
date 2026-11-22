
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int obstack_printf(struct obstack *obstack, const char *format, ...)
;
; Similar to snprintf but attempts to append the output
; string to the currently growing object in the obstack.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_obstack_printf

EXTERN asm_obstack_vprintf, __stdio_varg_2, __stdio_nextarg_de

asm_obstack_printf:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            hl   = strlen(generated s)
   ;            hl'  = address of terminating '\0' in obstack
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl   = -1
   ;            carry set, errno as below
   ;
   ;            enomem = insufficient memory for buffer
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;            
   ; uses  : all

   call __stdio_varg_2          ; de = obstack
   push de

   call __stdio_nextarg_de       ; de = format

   ld c,l
   ld b,h                       ; bc = arg

   pop hl                       ; hl = obstack

   jp asm_obstack_vprintf
