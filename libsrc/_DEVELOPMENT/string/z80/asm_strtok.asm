
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strtok(char * restrict s1, const char * restrict s2)
;
; Return the next token from the string being traversed.
; s2 is a string of delimiters used to identify where the next
; token ends.
;
; (1) If s1 != NULL, make s1 the new string to traverse.  Else
;     use the internally stored string position.
; (2) Skip over any delimiting chars at the head of the current
;     string.  This position becomes the start of the next token.
; (3) Find the end of the next token by searching for the first
;     delimiter char.
; (4) Terminate the next token by overwriting the delimiter char
;     with 0.
; (5) Update internal variable to search the string beginning
;     after this terminating 0 on next call to strtok().
; (6) Return pointer to the found token.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_strtok

LIB asm_strtok_r

asm_strtok:

   ; enter : de = char *s2 = delimiters
   ;         hl = char *s1 = string to tokenize
   ;
   ; exit  : 
   ;         found
   ; 
   ;           carry set
   ;           hl = ptr to token
   ;
   ;         not found
   ;
   ;           carry reset
   ;           hl = 0
   ;
   ; uses  : af, bc, hl

   ld bc,__strtok_ptr
   jp asm_strtok_r
