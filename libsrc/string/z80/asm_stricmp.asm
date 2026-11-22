
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int stricmp(const char *s1, const char *s2)
;
; Perform caseless compare of string s1 to string s2.  Return
; when the first differing char is found with *s1 - *s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_stricmp

EXTERN asm_strcasecmp

defc asm_stricmp = asm_strcasecmp

   ; enter : hl = char *s2
   ;         de = char *s1
   ;
   ; exit  :  a = h = *s1-*s2 of first differing caseless char
   ;         de = ptr in s1 to first differing char or NUL if equal
   ;
   ;         if s1==s2 : hl=0, nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flag set
   ;
   ; uses  : af, c, de, hl
