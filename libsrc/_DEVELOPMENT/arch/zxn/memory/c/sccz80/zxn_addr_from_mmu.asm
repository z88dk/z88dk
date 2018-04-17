; unsigned int zxn_addr_from_mmu(unsigned char mmu)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_addr_from_mmu

EXTERN asm_zxn_addr_from_mmu

defc zxn_addr_from_mmu = asm_zxn_addr_from_mmu
