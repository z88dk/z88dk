; unsigned char esx_m_tapeout_trunc(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapeout_trunc_fastcall

EXTERN asm_esx_m_tapeout_trunc

_esx_m_tapeout_trunc_fastcall:

   push iy
   
   call asm_esx_m_tapeout_trunc

   pop iy
   ret
