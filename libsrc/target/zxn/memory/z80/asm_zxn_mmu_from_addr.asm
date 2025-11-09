; ===============================================================
; 2017
; ===============================================================
; 
; unsigned char zxn_mmu_from_addr(unsigned int addr)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_mmu_from_addr

asm_zxn_mmu_from_addr:

   ; return mmu slot the address belongs to
   ;
   ; enter : hl = unsigned int addr
   ;
   ; exit  : a = l = mmu slot 0-7
   ;
   ; uses  : af, hl

   ld a,h
   rlca
   rlca
   rlca
   and $07
   ld l,a
IF __SCCZ80
   ld h,0
ENDIF
   ret
