; unsigned char esx_m_tapeout_open(unsigned char *appendname)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_open_fastcall

EXTERN asm_esx_m_tapeout_open

_esx_m_tapeout_open_fastcall:

   push ix
   
   call asm_esx_m_tapeout_open

   pop ix
   ret
