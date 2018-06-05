; unsigned char esx_m_tapeout_info(uint8_t *drive,unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_info_callee

EXTERN asm_esx_m_tapeout_info

_esx_m_tapeout_info_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_esx_m_tapeout_info
