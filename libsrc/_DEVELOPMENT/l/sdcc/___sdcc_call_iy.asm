
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___sdcc_call_iy

IF __SDCC_IX

   EXTERN l_jpiy

   defc ___sdcc_call_iy = l_jpiy

ELSE

   EXTERN l_jpix

   defc ___sdcc_call_iy = l_jpix

ENDIF
