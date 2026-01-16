
; uint16_t ntohs(uint16_t)

SECTION code_clib
SECTION code_network

PUBLIC ntohs

EXTERN htons

defc ntohs = htons
