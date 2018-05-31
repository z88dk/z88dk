; unsigned char esx_m_drvapi(struct esx_drvapi *)

SECTION code_esxdos

PUBLIC esx_m_drvapi

EXTERN asm_esx_m_drvapi

defc esx_m_drvapi = asm_esx_m_drvapi
