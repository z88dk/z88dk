
; Substitute for z80 rrd instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_rrd

.rcmx_rrd

   jr nc, dorrd

   call dorrd
   scf
   ret

.dorrd
   
   srl a
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rr (hl)
   
   rra
   rr (hl)                     ; a = [bits(HL):210, 0, bits(A):7654], carry = bit 3 of (HL)
   
   rra
   rra
   rra
   rra
   rra
   
   or a
   ret
