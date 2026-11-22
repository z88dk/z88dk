; unsigned char zxn_mmu_from_addr(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_mmu_from_addr_fastcall

EXTERN asm_zxn_mmu_from_addr

defc _zxn_mmu_from_addr_fastcall = asm_zxn_mmu_from_addr
