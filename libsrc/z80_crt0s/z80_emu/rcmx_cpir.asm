
; Substitute for z80 cpir instruction
; aralbrec 06.2007

XLIB rcmx_cpir

.rcmx_cpir
 
   inc b
   jr nc, enterloop
 
   call enterloop
   scf
   ret

.loop

   inc hl
   
.enterloop
 
   cp (hl)
   jr z, match
   
   dec c
   jp nz, loop
   djnz loop
 
.nomatch
 
   cp (hl)
   inc hl
   push af
 
.joinbc0
 
   ex (sp),hl
   res 0,l
   res 2,l
   ex (sp),hl
   pop af
   ret
 
.match

   inc hl
   push af
   
   dec b
   dec bc
   ld a,b
   or c
   jr z, joinbc0
 
   ex (sp),hl
   res 0,l 
   set 2,l
   ex (sp),hl
   pop af
   ret
