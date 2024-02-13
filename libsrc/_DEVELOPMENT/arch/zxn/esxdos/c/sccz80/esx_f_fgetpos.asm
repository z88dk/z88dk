; uint32_t esx_f_fgetpos(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_fgetpos

EXTERN asm_esx_f_fgetpos

defc esx_f_fgetpos = asm_esx_f_fgetpos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_fgetpos
defc _esx_f_fgetpos = esx_f_fgetpos
ENDIF

