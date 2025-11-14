
; uint32_t htonl(uint32_t)

SECTION code_clib
SECTION code_network

PUBLIC _htonl

EXTERN asm_htonl

_htonl:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_htonl
