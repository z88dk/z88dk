
; rcm substitute for z80 rld instruction
; aralbrec 06.2007

XLIB rcmx_rld

.rcmx_rld

   jr c, withcarry
   
   rlca
   rlca
   rlca
   rlca
   
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

.withcarry

   rlca
   rlca
   rlca
   rlca
   
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
   scf
   ret
