
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int asprintf (char **ptr, const char *format, ...)
;
; Similar to snprintf but attempts to dynamically allocate
; a buffer using malloc to store the output string.
;
; ===============================================================

XLIB asm_asprintf

LIB asm_vasprintf, asm_sprintf_common

asm_asprintf:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            *ptr = char *s (address of allocated buffer)
   ;            hl   = strlen(s)
   ;            hl'  = char *s (address of terminating '\0' in allocated buffer)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            *ptr = 0 (if ptr != 0)
   ;            hl   = -1
   ;            carry set, errno as below
   ;
   ;            enomem = insufficient memory for buffer
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;            einval = ptr is NULL
   ;            
   ; uses  : all

   call asm_sprintf_common
   
   jp asm_vasprintf
