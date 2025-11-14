; unsigned char esx_m_tapein_info(uint8_t *drive,unsigned char *filename)

SECTION code_esxdos

PUBLIC esx_m_tapein_info

EXTERN asm_esx_m_tapein_info

esx_m_tapein_info:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_esx_m_tapein_info

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_tapein_info
defc _esx_m_tapein_info = esx_m_tapein_info
ENDIF

