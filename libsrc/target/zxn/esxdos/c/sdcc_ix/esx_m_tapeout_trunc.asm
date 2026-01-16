; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_trunc

EXTERN _esx_m_tapeout_trunc_fastcall

_esx_m_tapeout_trunc:

   pop af
   pop hl
   
   push hl
   push af

   jp _esx_m_tapeout_trunc_fastcall
