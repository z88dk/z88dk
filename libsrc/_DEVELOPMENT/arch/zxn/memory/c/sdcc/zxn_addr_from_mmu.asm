; unsigned int zxn_addr_from_mmu(unsigned char mmu)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_from_mmu

EXTERN asm_zxn_addr_from_mmu

_zxn_addr_from_mmu:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zxn_addr_from_mmu
