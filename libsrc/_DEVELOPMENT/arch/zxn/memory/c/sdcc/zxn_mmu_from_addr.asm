; unsigned char zxn_mmu_from_addr(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_mmu_from_addr

EXTERN asm_zxn_mmu_from_addr

_zxn_mmu_from_addr:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zxn_mmu_from_addr
