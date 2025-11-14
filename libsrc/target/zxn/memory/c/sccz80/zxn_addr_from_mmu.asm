; unsigned int zxn_addr_from_mmu(unsigned char mmu)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_addr_from_mmu

EXTERN asm_zxn_addr_from_mmu

defc zxn_addr_from_mmu = asm_zxn_addr_from_mmu

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zxn_addr_from_mmu
defc _zxn_addr_from_mmu = zxn_addr_from_mmu
ENDIF

