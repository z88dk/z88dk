
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)
;
; As getdelim_unlocked with delimiter = '\n'
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_getline_unlocked

EXTERN asm_getdelim_unlocked

asm_getline_unlocked:

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

   ld bc,CHAR_LF
   jp asm_getdelim_unlocked
