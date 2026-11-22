; unsigned char esx_m_tapeout_info(uint8_t *drive,unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_m_tapeout_info_callee

EXTERN asm_esx_m_tapeout_info

esx_m_tapeout_info_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_esx_m_tapeout_info

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapeout_info_callee
defc _esx_m_tapeout_info_callee = esx_m_tapeout_info_callee
ENDIF

