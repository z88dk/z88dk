; uchar esxdos_m_getdrv(void)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_m_getdrv

EXTERN asm_esxdos_m_getsetdrv

_esxdos_m_getdrv:

   ld l,0

   push ix
   push iy
   
   call asm_esxdos_m_getsetdrv
   
   pop iy
   pop ix
   ret
