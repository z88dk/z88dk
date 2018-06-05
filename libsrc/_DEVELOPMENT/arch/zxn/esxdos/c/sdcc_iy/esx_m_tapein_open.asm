; unsigned char esx_m_tapein_open(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapein_open

EXTERN asm_esx_m_tapein_open

_esx_m_tapein_open:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_m_tapein_open
