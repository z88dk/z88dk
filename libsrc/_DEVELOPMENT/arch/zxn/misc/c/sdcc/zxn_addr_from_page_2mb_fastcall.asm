; uint32_t zxn_addr_from_page_2mb(uint8_t page)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_from_page_2mb_fastcall

EXTERN error_lmc
EXTERN asm_zxn_addr_from_page_nocheck

_zxn_addr_from_page_2mb_fastcall:

   ld a,l
   cp 224
   jp c, asm_zxn_addr_from_page_nocheck

   jp error_lmc
