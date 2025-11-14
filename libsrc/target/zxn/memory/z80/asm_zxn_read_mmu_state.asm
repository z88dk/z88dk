; ===============================================================
; 2017
; ===============================================================
; 
; void zxn_read_mmu_state(uint8_t *dst)
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_read_mmu_state

asm_zxn_read_mmu_state:

   ; read current memory configuration from mmu registers
   ;
   ; enter : hl = uint8_t dst[8]
   ;
   ; exit  : hl = &dst[8] (past the array)
   ;
   ; exit  : mmu state written to dst[]
   ;
   ; uses  : f, bc, de, hl
   
   ld bc,__IO_NEXTREG_REG
   ld de,0x0800 + __REG_MMU0

loop:

   out (c),e
   inc b
   ini
   inc e
   
   dec d
   jr nz, loop
   
   ret
