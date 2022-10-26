
SECTION code_clib
SECTION code_l

PUBLIC l_call_ix

IF __SDCC_IY

   EXTERN l_jpiy

   defc l_call_ix = l_jpiy

ELSE

   EXTERN l_jpix

   defc l_call_ix = l_jpix

ENDIF

; use for compile time user code
; the library entries l_jpix / l_jpiy can have IX/IY swapped
