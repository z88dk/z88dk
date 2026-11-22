; unsigned char zxn_page_from_addr(uint32_t addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_page_from_addr

EXTERN asm_zxn_page_from_addr

_zxn_page_from_addr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_zxn_page_from_addr
