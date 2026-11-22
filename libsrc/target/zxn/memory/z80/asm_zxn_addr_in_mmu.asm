; ===============================================================
; 2018
; ===============================================================
; 
; unsigned int zxn_addr_in_mmu(unsigned char mmu, unsigned int addr)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_addr_in_mmu

asm_zxn_addr_in_mmu:

   ; return address at the same offset in another mmu slot
   ;
   ; enter :  a = new mmu slot
   ;         hl = address
   ;
   ; exit  : hl = address at same offset in new mmu slot
   ;
   ; uses  : af, e, hl

   rrca
   rrca
   rrca
   and $e0
   ld e,a
   
   ld a,h
   and $1f
   or e
   ld h,a
   
   ret
