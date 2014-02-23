
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t getline(char **lineptr, size_t *n, FILE *stream)
;
; As getdelim with delimiter = '\n'
;
; ===============================================================

XLIB asm_getline

LIB asm_getdelim

asm_getline:

   ; enter : ix = FILE *
   ;         de = size_t *n
   ;         hl = char **lineptr
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            *lineptr = address of buffer
   ;            *n       = size of buffer in bytes, including '\0'
   ;
   ;            hl = number of chars written to buffer (not including '\0')
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   ld bc,'\n'
   jp asm_getdelim
