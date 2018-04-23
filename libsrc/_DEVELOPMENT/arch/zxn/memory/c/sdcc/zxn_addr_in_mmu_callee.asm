; unsigned int zxn_addr_in_mmu(unsigned char mmu, unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_in_mmu_callee

EXTERN asm_zxn_addr_in_mmu

_zxn_addr_in_mmu_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl
   
   jp asm_zxn_addr_in_mmu
