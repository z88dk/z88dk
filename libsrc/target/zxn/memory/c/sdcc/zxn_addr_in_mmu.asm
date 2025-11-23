; unsigned int zxn_addr_in_mmu(unsigned char mmu, unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_in_mmu

EXTERN asm_zxn_addr_in_mmu

_zxn_addr_in_mmu:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de

   jp asm_zxn_addr_in_mmu
