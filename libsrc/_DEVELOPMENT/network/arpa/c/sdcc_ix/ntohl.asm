
; uint32_t ntohl(uint32_t)

SECTION code_clib
SECTION code_network

PUBLIC _ntohl

EXTERN _htonl

defc _ntohl = _htonl
