; unsigned char zxn_mmu_from_addr(unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_mmu_from_addr

EXTERN asm_zxn_mmu_from_addr

defc zxn_mmu_from_addr = asm_zxn_mmu_from_addr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zxn_mmu_from_addr
defc _zxn_mmu_from_addr = zxn_mmu_from_addr
ENDIF

