; Substitute for z80 rld instruction
; aralbrec 06.2007

IF !__CPU_8080__
SECTION code_crt0_sccz80
PUBLIC __z80asm__rld

.__z80asm__rld

   jr nc, dorld
   
   call dorld
   scf
   ret

.dorld
   
   rlca
   rlca
   rlca
   rlca                        ; a = bits 32107654
   
   sla a
   rl (hl)
   adc a,0
   
   rla
   rl (hl)
   adc a,0
   
   rla
   rl (hl)
   adc a,0
   
   rla
   rl (hl)
   adc a,0
   
   or a
   ret
ENDIF
