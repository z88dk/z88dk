
; BSD
; int bcmp (const void *b1, const void *b2, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC asm_bcmp

EXTERN asm_memcmp

defc asm_bcmp = asm_memcmp

   ; enter : bc = len
   ;         hl = void *b2 = s2
   ;         de = void *b1 = s1
   ;
   ; exit  :  a = h = *s1-*s2 of last char compared
   ;         de = ptr in s1 to first differing char
   ;
   ;         if s1==s2 : hl=0, bc=0,  nc+z flags set
   ;         if s1<<s2 : hl<0, c+nz flags set
   ;         if s1>>s2 : hl>0, nc+nz flags set
   ;
   ; uses  : af, bc, de, hl
