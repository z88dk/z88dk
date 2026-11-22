
SECTION code_clib
SECTION code_l

PUBLIC l_call_iy

IF __SDCC_IY

   EXTERN l_jpix

   defc l_call_iy = l_jpix

ELSE

   EXTERN l_jpiy

   defc l_call_iy = l_jpiy

ENDIF

; use for compile time user code
; the library entries l_jpix / l_jpiy can have IX/IY swapped
