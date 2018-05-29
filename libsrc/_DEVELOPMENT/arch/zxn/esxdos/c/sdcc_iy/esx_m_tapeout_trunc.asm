; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_trunc

EXTERN asm_esx_m_tapeout_trunc

_esx_m_tapeout_trunc:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_tapeout_trunc
