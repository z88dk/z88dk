
; Substitute for z80 cpdr instruction
; aralbrec 02.2008
; flag-perfect emulation of cpdr

SECTION code_crt0_sccz80
PUBLIC rcmx_cpdr

.rcmx_cpdr
 
   jr nc, enterloop
 
   call enterloop
   scf
   ret

.loop

   dec hl

.enterloop

   dec bc
   cp (hl)
   jr z, match
   
   inc c
   dec c
   jr nz, loop

   inc b
   djnz loop
   
.nomatch

   cp (hl)
   dec hl
   push af
 
.joinbc0
 
   ex (sp),hl
   res 0,l
   res 2,l
   ex (sp),hl
   pop af
   ret

.match

   dec hl
   push af

   ld a,b
   or c
   jr z, joinbc0
  
   ex (sp),hl
   res 0,l 
   set 2,l
   ex (sp),hl
   pop af
   ret
