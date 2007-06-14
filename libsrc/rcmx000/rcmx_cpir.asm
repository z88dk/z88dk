
; rcm substitute for z80 cpir instruction
; aralbrec 06.2007

XLIB rcmx_cpir

.rcmx_cpir

   dec hl
   dec bc
   inc b
   inc c
   jr nc, loopmsbnc

.loopmsbc

   dec b

.looplsbc

   dec c
   
   inc hl
   cp (hl)
   jr z, matchc
   dec bc
   
   inc c
   jr nz, looplsbc
   
   inc b
   jr nz, loopmsbc

.nomatchc

   cp (hl)
   inc hl
   push af

.joinc

   ex (sp),hl
   res 2,l
   ex (sp),hl
   pop af
   scf
   ret

.matchc

   inc hl
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
   
   inc hl
   cp (hl)
   jr z, matchnc
   dec bc
   
   inc c
   jr nz, looplsbnc
   
   inc b
   jr nz, loopmsbnc

.nomatchnc

   cp (hl)
   inc hl
   push af

.joinnc

   ex (sp),hl
   res 0,l
   res 2,l
   ex (sp),hl
   pop af
   ret

.matchnc

   inc hl
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
