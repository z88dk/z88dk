; uchar esxdos_m_gethandle(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_ram_m_gethandle

EXTERN asm_esxdos_m_gethandle

_esxdos_ram_m_gethandle:

   push iy
   
   call asm_esxdos_m_gethandle
   
   pop iy
   ret
