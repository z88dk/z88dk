
; uint16_t htons(uint16_t)

SECTION code_clib
SECTION code_network

PUBLIC _htons

EXTERN asm_htons

_htons:

   pop af
   pop hl

   push hl
   push af
   
   jp asm_htons
