; unsigned char esx_m_tapein_flags(uint8_t flags)

SECTION code_esxdos

PUBLIC _esx_m_tapein_flags_fastcall

EXTERN asm_esx_m_tapein_flags

defc _esx_m_tapein_flags_fastcall = asm_esx_m_tapein_flags
