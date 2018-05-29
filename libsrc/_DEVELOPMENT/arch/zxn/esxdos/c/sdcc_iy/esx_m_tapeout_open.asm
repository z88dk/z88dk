; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_open

EXTERN asm_esx_m_tapeout_open

_esx_m_tapeout_open:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_tapeout_open
