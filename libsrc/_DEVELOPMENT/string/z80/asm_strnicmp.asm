
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int strnicmp(const char *s1, const char *s2, size_t n)
;
; Perform caseless compare of string s1 to string s2, examining
; no more than n chars.  Return when the first differing char is
; found with *s1 - *s2.
;
; ===============================================================

XLIB asm_strnicmp

LIB asm_strncasecmp

asm_strnicmp:

   jp asm_strncasecmp

;defc asm_strnicmp = asm_strncasecmp

   ; enter : hl = char *s2
   ;         de = char *s1
   ;         bc = size_t n
   ;
   ; exit  :  a = h = *s1-*s2 of first differing caseless char
   ;         de = ptr in s1 to byte after last char compared or NUL
   ;
   ;         if s1==s2 : hl=0, nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flag set
   ;
   ; uses  : af, bc, de, hl, ixl
