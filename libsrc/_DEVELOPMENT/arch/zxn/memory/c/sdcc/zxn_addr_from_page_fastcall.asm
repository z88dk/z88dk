; uint32_t zxn_addr_from_page(uint8_t page)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_from_page_fastcall

EXTERN asm_zxn_addr_from_page

defc _zxn_addr_from_page_fastcall = asm_zxn_addr_from_page
