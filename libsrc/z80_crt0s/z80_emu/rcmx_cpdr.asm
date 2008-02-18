
; Substitute for z80 cpdr instruction
; aralbrec 02.2008
; flag-perfect emulation of cpdr

XLIB rcmx_cpdr

.rcmx_cpdr
 
   jr nc, enterloop
 
   call enterloop
   scf
   ret

.loop1

   dec c

.loop2

   dec hl

.enterloop

   cp (hl)
   jr z, match
   
   dec c
   inc c
   jp nz, loop1

   dec c
   djnz loop2
   
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
   dec bc
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
