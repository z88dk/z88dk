
; uint32_t ntohl(uint32_t)

SECTION code_clib
SECTION code_network

PUBLIC ntohl

EXTERN htonl

defc ntohl = htonl
