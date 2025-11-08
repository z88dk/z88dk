; void zxn_read_mmu_state(uint8_t *dst)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_read_mmu_state

EXTERN asm_zxn_read_mmu_state

defc zxn_read_mmu_state = asm_zxn_read_mmu_state

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zxn_read_mmu_state
defc _zxn_read_mmu_state = zxn_read_mmu_state
ENDIF

