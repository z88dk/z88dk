; char *p3dos_dosname_from_catname(char *dosname, char *catname)

SECTION code_esxdos

PUBLIC p3dos_dosname_from_catname_callee

EXTERN asm_p3dos_dosname_from_catname

p3dos_dosname_from_catname_callee:

   pop hl
	pop de
	ex (sp),hl

   jp asm_p3dos_dosname_from_catname
