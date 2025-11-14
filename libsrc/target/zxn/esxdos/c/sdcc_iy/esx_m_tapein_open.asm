; unsigned char esx_m_tapein_open(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapein_open

EXTERN _esx_m_tapein_open_fastcall

_esx_m_tapein_open:

   pop af
   pop hl
   
   push hl
   push af

   jp _esx_m_tapein_open_fastcall
