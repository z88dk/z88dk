; uchar esxdos_m_setdrv(uchar drive)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_m_setdrv_fastcall

EXTERN asm_esxdos_m_getsetdrv

_esxdos_m_setdrv_fastcall:

   push iy

   call asm_esxdos_m_getsetdrv
   
   pop iy
   ret
