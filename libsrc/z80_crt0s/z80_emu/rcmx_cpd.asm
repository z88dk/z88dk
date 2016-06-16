
; Substitute for z80 cpd instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_cpd

.rcmx_cpd

   jr c, cpdwcarry
   
   cp (hl)
   dec hl
   dec bc
   
   push af
   ex (sp),hl
   res 0,l

.rejoin

   set 2,l

   ld a,b
   or c
   jr nz, exitcpd
   res 2,l

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
   set 0,l
   jr rejoin
