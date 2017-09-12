; Substitute for z80 cpi instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC __z80asm__cpi

.__z80asm__cpi

   jr c, cpiwcarry
   
   cp (hl)
   inc hl
   dec bc
   
   push af
   ex (sp),hl
   res 0,l 			; clear carry

.rejoin

   set 2,l			; set P/V -> BC != 0

   ld a,b
   or c
   jr nz, exitcpi
   res 2,l			; clear P/V -> BC == 0

.exitcpi

   ex (sp),hl
   pop af
   ret

.cpiwcarry

   cp (hl)
   inc hl
   dec bc
   
   push af
   ex (sp),hl
   set 0,l 			; set carry
   jr rejoin
