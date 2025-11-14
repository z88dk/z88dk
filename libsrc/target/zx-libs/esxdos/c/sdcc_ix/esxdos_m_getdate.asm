; ulong esxdos_m_getdate(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_m_getdate

EXTERN asm_esxdos_m_getdate

_esxdos_m_getdate:

   push ix
   push iy
   
   call asm_esxdos_m_getdate
   
   pop iy
   pop ix
   ret
