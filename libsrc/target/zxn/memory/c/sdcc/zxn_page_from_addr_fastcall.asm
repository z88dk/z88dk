; unsigned char zxn_page_from_addr(uint32_t addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_page_from_addr_fastcall

EXTERN asm_zxn_page_from_addr

defc _zxn_page_from_addr_fastcall = asm_zxn_page_from_addr
