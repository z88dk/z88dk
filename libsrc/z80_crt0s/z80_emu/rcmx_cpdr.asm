
; Substitute for z80 cpdr instruction
; aralbrec 06.2007

XLIB rcmx_cpdr

.rcmx_cpdr

   inc b
   jr nc, enterloop
 
   call enterloop
   scf
   ret

.loop

   dec hl
   
.enterloop
 
   cp (hl)
   jr z, match
   
   dec c
   jp nz, loop
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
