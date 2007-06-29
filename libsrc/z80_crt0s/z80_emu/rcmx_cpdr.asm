
; Substitute for z80 cpdr instruction
; aralbrec 06.2007

XLIB rcmx_cpdr

.rcmx_cpdr

   jr nc, enterloop
 
   call enterloop
   scf
   ret

.loop

   dec hl

.enterloop

   cp (hl)
   dec bc
   jr z, match
   
   ld a,b
   or c
   jp nz, loop
 
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
