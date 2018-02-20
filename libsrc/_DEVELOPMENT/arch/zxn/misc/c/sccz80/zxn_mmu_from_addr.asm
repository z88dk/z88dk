; unsigned char zxn_mmu_from_addr(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_mmu_from_addr

EXTERN asm_zxn_mmu_from_addr

defc zxn_mmu_from_addr = asm_zxn_mmu_from_addr
