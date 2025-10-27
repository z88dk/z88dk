; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_open

EXTERN _esx_m_tapeout_open_fastcall

_esx_m_tapeout_open:

   pop af
   pop hl
   
   push hl
   push af

   jp _esx_m_tapeout_open_fastcall
