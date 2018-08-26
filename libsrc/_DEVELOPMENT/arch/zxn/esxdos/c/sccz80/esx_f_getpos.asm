; uint32_t esx_f_fgetpos(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_getpos

EXTERN asm_esx_f_fgetpos

defc esx_f_getpos = asm_esx_f_fgetpos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_getpos
defc _esx_f_getpos = esx_f_getpos
ENDIF

