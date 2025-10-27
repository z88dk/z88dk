; unsigned char esx_m_tapein_open(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_m_tapein_open_fastcall

EXTERN asm_esx_m_tapein_open

_esx_m_tapein_open_fastcall:

   push ix
   
   call asm_esx_m_tapein_open

   pop ix
   ret
