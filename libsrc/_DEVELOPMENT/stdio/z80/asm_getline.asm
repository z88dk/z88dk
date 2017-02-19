
; ===============================================================
; Jan 2014
; ===============================================================
; 
; size_t getline(char **lineptr, size_t *n, FILE *stream)
;
; As getdelim with delimiter = '\n'
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_getline

EXTERN asm_getdelim

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

   ld bc,ASCII_EOL
   jp asm_getdelim

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_getline

EXTERN asm_getline_unlocked

defc asm_getline = asm_getline_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
