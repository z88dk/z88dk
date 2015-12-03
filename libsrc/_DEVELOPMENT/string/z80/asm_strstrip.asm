
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strstrip(const char *s)
;
; Return a ptr to the first non-whitespace char in s.
;
; If s consists entirely of whitespace, return a ptr to the
; terminating NUL char in s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strstrip

EXTERN asm_isspace

asm_strstrip:

   ; enter : hl = char *s
   ;
   ; exit  : hl = ptr to first non-whitespace char in s
   ;         carry reset = entire string is whitespace
   ;
   ; uses  : af, hl
      
loop:

   ld a,(hl)
   or a                        ; reached end of s?
   ret z
   
   inc hl
   
   call asm_isspace
   jr nc, loop

   dec hl
   ret
