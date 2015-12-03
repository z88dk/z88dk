
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strrstrip(char *s)
;
; Remove trailing whitespace from s by writing 0 into s to
; terminate the string early.
;
; If s consists entirely of whitespace then s[0] = 0.
;
; See also _strrstrip() that does not modify s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strrstrip

EXTERN asm__strrstrip

asm_strrstrip:

   ; enter : hl = char *s
   ;
   ; exit  : hl = char *s
   ;         carry reset if s is entirely whitespace
   ;
   ; uses  : af, bc, de
   
   call asm__strrstrip         ; hl = ptr to ws char
   ld (hl),0                   ; terminate s early
   
   ex de,hl
   ret
