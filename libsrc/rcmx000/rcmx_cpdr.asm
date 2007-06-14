
; rcm substitute for z80 cpdr instruction
; aralbrec 06.2007

XLIB rcmx_cpdr

.rcmx_cpdr

   inc hl
   dec bc
   inc b
   inc c
   jr nc, loopmsbnc

.loopmsbc

   dec b

.looplsbc

   dec c
   
   dec hl
   cp (hl)
   jr z, matchc
   dec bc
   
   inc c
   jr nz, looplsbc
   
   inc b
   jr nz, loopmsbc

.nomatchc

   cp (hl)
   dec hl
   push af

.joinc

   ex (sp),hl
   res 2,l
   ex (sp),hl
   pop af
   scf
   ret

.matchc

   dec hl
   push af
   ld a,b
   or c
   jr z, joinc
   ex (sp),hl
   set 2,l
   ex (sp),hl
   pop af
   scf
   ret

;;; and again for carry reset case

.loopmsbnc

   dec b

.looplsbnc

   dec c
   
   dec hl
   cp (hl)
   jr z, matchnc
   dec bc
   
   inc c
   jr nz, looplsbnc
   
   inc b
   jr nz, loopmsbnc

.nomatchnc

   cp (hl)
   dec hl
   push af

.joinnc

   ex (sp),hl
   res 0,l
   res 2,l
   ex (sp),hl
   pop af
   ret

.matchnc

   dec hl
   push af
   ld a,b
   or c
   jr z, joinnc
   ex (sp),hl
   res 0,l
   set 2,l
   ex (sp),hl
   pop af
   ret
