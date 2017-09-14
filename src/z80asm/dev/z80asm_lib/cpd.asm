; Substitute for z80 cpd instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC __z80asm__cpd

.__z80asm__cpd

   jr c, cpdwcarry
   
   cp (hl)
   dec hl
   dec bc
   
   push af
   ex (sp),hl
   res 0,l 			; clear carry

.rejoin

   set 2,l			; set P/V -> BC != 0

   ld a,b
   or c
   jr nz, exitcpd
   res 2,l			; clear P/V -> BC == 0

.exitcpd

   ex (sp),hl
   pop af
   ret

.cpdwcarry

   cp (hl)
   dec hl
   dec bc
   
   push af
   ex (sp),hl
   set 0,l 			; set carry
   jr rejoin
