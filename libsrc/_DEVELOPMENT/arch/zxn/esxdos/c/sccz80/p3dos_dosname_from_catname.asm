; char *p3dos_dosname_from_catname(char *dosname, char *catname)

SECTION code_esxdos

PUBLIC p3dos_dosname_from_catname

EXTERN asm_p3dos_dosname_from_catname

p3dos_dosname_from_catname:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_p3dos_dosname_from_catname
