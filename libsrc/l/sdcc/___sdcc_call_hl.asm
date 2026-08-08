
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___sdcc_call_hl
PUBLIC __sdcc_call_hl

EXTERN l_jphl

defc ___sdcc_call_hl = l_jphl
defc __sdcc_call_hl = ___sdcc_call_hl
