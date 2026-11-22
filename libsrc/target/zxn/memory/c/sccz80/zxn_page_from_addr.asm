; unsigned char zxn_page_from_addr(uint32_t addr)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_page_from_addr

EXTERN asm_zxn_page_from_addr

defc zxn_page_from_addr = asm_zxn_page_from_addr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zxn_page_from_addr
defc _zxn_page_from_addr = zxn_page_from_addr
ENDIF

