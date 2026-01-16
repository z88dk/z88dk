; unsigned char esx_ide_browser(uint8_t browsercaps, void *filetypes, char *help, char *dst_sfn, char *dst_lfn)

SECTION code_esxdos

PUBLIC esx_ide_browser

EXTERN asm_esx_ide_browser

esx_ide_browser:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   exx
   pop bc
   
   push bc
   exx
   push hl
   push hl
   push bc
   push de
   push af
   
   exx
   ld a,c
   exx
   
   jp asm_esx_ide_browser
