; unsigned char esx_f_readdir(unsigned char handle,struct esx_dirent *dirent)

SECTION code_esxdos

PUBLIC esx_f_readdir_callee

EXTERN asm_esx_f_readdir

esx_f_readdir_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esx_f_readdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_readdir_callee
defc _esx_f_readdir_callee = esx_f_readdir_callee
ENDIF

