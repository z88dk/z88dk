*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF STRCASECMP()

asm_stricmp:

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
