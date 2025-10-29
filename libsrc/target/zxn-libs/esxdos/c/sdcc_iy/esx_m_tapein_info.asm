; unsigned char esx_m_tapein_info(uint8_t *drive,unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapein_info

EXTERN l0_esx_m_tapein_info_callee

_esx_m_tapein_info:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp l0_esx_m_tapein_info_callee
