; void zxn_write_mmu_state(uint8_t *src)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_write_mmu_state

EXTERN asm_zxn_write_mmu_state

defc zxn_write_mmu_state = asm_zxn_write_mmu_state
