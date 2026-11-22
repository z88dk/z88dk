; unsigned char esx_m_drvapi(struct esx_drvapi *)

SECTION code_esxdos

PUBLIC _esx_m_drvapi_fastcall

EXTERN asm_esx_m_drvapi

defc _esx_m_drvapi_fastcall = asm_esx_m_drvapi
