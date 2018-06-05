; unsigned char esx_m_tapein_info(uint8_t *drive,unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapein_info_callee

EXTERN asm_esx_m_tapein_info

_esx_m_tapein_info_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_esx_m_tapein_info
