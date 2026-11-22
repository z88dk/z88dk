; unsigned char esx_ide_browser(uint8_t browsercaps, void *filetypes, char *help, char *dst_sfn, char *dst_lfn)

SECTION code_esxdos

PUBLIC _esx_ide_browser_callee
PUBLIC l0_esx_ide_browser_callee

EXTERN asm_esx_ide_browser

_esx_ide_browser_callee:

   pop hl
   dec sp
   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   ex (sp),hl
   ex de,hl
   
l0_esx_ide_browser_callee:

   exx
   push bc
   exx
   
   ex (sp),ix
   push iy
   
   call asm_esx_ide_browser
   
   pop iy
   pop ix
   
   ret
