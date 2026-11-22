; void zxn_read_mmu_state(uint8_t *dst)

SECTION code_clib
SECTION code_arch

PUBLIC _zxn_read_mmu_state

EXTERN asm_zxn_read_mmu_state

_zxn_read_mmu_state:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_zxn_read_mmu_state
