; ===============================================================
; 2017
; ===============================================================
; 
; unsigned int zxn_addr_from_mmu(unsigned char mmu)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_addr_from_mmu

asm_zxn_addr_from_mmu:

   ; return start address of mmu slot
   ;
   ; enter : l = mmu 0-7
   ;
   ; exit  : hl = address
   ;
   ; uses  : af, hl

   ld a,l
   rrca
   rrca
   rrca
   and $e0
   ld h,a
   ld l,0
   ret
