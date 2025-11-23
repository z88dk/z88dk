; void esx_m_geterr(uint16_t error,unsigned char *msg)

SECTION code_esxdos

PUBLIC esx_m_geterr

EXTERN asm_esx_m_geterr

esx_m_geterr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_esx_m_geterr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_m_geterr
defc _esx_m_geterr = esx_m_geterr
ENDIF

