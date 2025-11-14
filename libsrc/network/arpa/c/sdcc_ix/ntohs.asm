
; uint16_t ntohs(uint16_t)

SECTION code_clib
SECTION code_network

PUBLIC _ntohs

EXTERN _htons

defc _ntohs = _htons
