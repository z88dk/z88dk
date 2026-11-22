; unsigned int zxn_addr_from_mmu(unsigned char mmu)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_addr_from_mmu_fastcall

EXTERN asm_zxn_addr_from_mmu

defc _zxn_addr_from_mmu_fastcall = asm_zxn_addr_from_mmu
