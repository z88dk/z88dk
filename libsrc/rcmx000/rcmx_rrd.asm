
; rcm substitute for z80 rrd instruction
; aralbrec 06.2007

XLIB rcmx_rrd

.rcmx_rrd

   jr c, withcarry
   
   srl a
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rra
   rra
   rra
   rra
   
   or a
   ret

.withcarry

   srl a
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rra
   rra
   rra
   rra
   
   or a
   scf
   ret
