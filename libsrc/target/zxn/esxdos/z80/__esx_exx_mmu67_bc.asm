INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC __esx_exx_mmu67_bc

IF __ZXNEXT

__esx_exx_mmu67_bc:

   ; enter : c = new mmu6 page
   ;         b = new mmu7 page
   ;
   ; exit  : c = old mmu6 page
   ;         b = old mmu7 page
   ;
   ;         mmu6 and mmu7 set to new page numbers
   ;
   ; uses  : af, bc

   push hl
   
   ld l,c
   ld h,b
   
   ld bc,__IO_NEXTREG_REG
   ld a,__REG_MMU6
   
   out (c),a
   inc b
   
   in a,(c)
   out (c),l
   
   ld l,a
   
   dec b
   ld a,__REG_MMU7
   
   out (c),a
   inc b
   
   in a,(c)
   out (c),h
   
   ld b,a
   ld c,l
   
   pop hl
   ret

ELSE

EXTERN l_ret
defc __esx_exx_mmu67_bc = l_ret

ENDIF
