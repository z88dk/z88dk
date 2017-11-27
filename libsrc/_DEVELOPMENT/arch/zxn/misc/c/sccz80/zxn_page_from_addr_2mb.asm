; unsigned char zxn_page_from_addr_2mb(uint32_t addr)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_page_from_addr_2mb

EXTERN error_mc
EXTERN asm_zxn_page_from_addr_nocheck

zxn_page_from_addr_2mb:

   inc d
   dec d
   jp nz, error_mc
   
   ld a,e
   cp 224/8
   jp c, asm_zxn_page_from_addr_nocheck

   jp error_mc
