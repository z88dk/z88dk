; unsigned char zxn_page_from_addr_2mb(uint32_t addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_page_from_addr_2mb

EXTERN _zxn_page_from_addr_2mb_fastcall

_zxn_page_from_addr_2mb:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp _zxn_page_from_addr_2mb_fastcall
