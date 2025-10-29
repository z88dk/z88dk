; void zxn_read_mmu_state(uint8_t *dst)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_read_mmu_state_fastcall

EXTERN asm_zxn_read_mmu_state

defc _zxn_read_mmu_state_fastcall = asm_zxn_read_mmu_state
