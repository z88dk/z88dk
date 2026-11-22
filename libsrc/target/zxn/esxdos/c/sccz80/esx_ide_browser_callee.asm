; unsigned char esx_ide_browser(uint8_t browsercaps, void *filetypes, char *help, char *dst_sfn, char *dst_lfn)

SECTION code_esxdos

PUBLIC esx_ide_browser_callee

EXTERN asm_esx_ide_browser

esx_ide_browser_callee:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   exx
   pop bc
   push af
   ld a,c
   exx
   
   jp asm_esx_ide_browser
