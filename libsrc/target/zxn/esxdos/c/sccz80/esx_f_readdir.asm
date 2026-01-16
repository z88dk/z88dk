; unsigned char esx_f_readdir(unsigned char handle,struct esx_dirent *dirent)

SECTION code_esxdos

PUBLIC esx_f_readdir

EXTERN asm_esx_f_readdir

esx_f_readdir:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,e
   jp asm_esx_f_readdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_readdir
defc _esx_f_readdir = esx_f_readdir
ENDIF

