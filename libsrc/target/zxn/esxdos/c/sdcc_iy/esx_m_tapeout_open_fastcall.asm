; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_open_fastcall

EXTERN asm_esx_m_tapeout_open

_esx_m_tapeout_open_fastcall:

   push iy
   
   call asm_esx_m_tapeout_open

   pop iy
   ret
