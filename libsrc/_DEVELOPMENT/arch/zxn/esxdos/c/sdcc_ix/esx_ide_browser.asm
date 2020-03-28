; unsigned char esx_ide_browser(uint8_t browsercaps, void *filetypes, char *help, char *dst_sfn, char *dst_lfn)

SECTION code_esxdos

PUBLIC _esx_ide_browser

EXTERN l0_esx_ide_browser_callee

_esx_ide_browser:

   pop af
   ex af,af'
   dec sp
   pop af
   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push bc
   push af
   inc sp
   ex af,af'
   push af
   
   ex af,af'
   jp l0_esx_ide_browser_callee
