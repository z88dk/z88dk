; unsigned char esx_ide_browser(uint8_t browsercaps, void *filetypes, char *help, char *dst_sfn, char *dst_lfn)

SECTION code_esxdos

PUBLIC _esx_ide_browser

EXTERN l0_esx_ide_browser_callee

_esx_ide_browser:

   exx
   pop bc
   exx
   dec sp
   pop af
   pop ix
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push hl
   push af
   inc sp
   exx
   push bc
   exx
   
   jp l0_esx_ide_browser_callee
