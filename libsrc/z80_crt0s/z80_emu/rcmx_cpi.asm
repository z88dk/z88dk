
; Substitute for z80 cpi instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_cpi

.rcmx_cpi

   jr c, cpiwcarry
   
   cp (hl)
   inc hl
   dec bc
   
   push af
   ex (sp),hl
   res 0,l

.rejoin

   set 2,l

   ld a,b
   or c
   jr nz, exitcpi
   res 2,l

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
   set 0,l
   jr rejoin
