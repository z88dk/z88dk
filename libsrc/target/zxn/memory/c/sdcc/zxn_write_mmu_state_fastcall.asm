; void zxn_write_mmu_state(uint8_t *src)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_write_mmu_state_fastcall

EXTERN asm_zxn_write_mmu_state

defc _zxn_write_mmu_state_fastcall = asm_zxn_write_mmu_state
