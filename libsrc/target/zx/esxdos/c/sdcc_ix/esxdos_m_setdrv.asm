; uchar esxdos_m_setdrv(uchar drive)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_m_setdrv

EXTERN _esxdos_m_setdrv_fastcall

_esxdos_m_setdrv:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esxdos_m_setdrv_fastcall
