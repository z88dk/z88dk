; uint32_t zxn_addr_from_page(uint8_t page)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_from_page

EXTERN asm_zxn_addr_from_page

_zxn_addr_from_page:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zxn_addr_from_page
