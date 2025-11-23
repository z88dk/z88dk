; char *p3dos_dosname_from_catname(char *dosname, char *catname)

SECTION code_esxdos

PUBLIC _p3dos_dosname_from_catname

EXTERN asm_p3dos_dosname_from_catname

_p3dos_dosname_from_catname:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_p3dos_dosname_from_catname
