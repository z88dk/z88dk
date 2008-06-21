; fd_findslot
; 06.2008 aralbrec

XLIB fd_findslot
XREF _fdtbl

INCLUDE "stdio.def"

.fd_findslot

   ; find the first available slot in fdtbl for a new file
   ;
   ; exit :  b = MAXFILES - fd
   ;        hl = MSB of fdtbl entry
   ;        carry set if no available slot
   ; uses : af, b, hl

   ld b,MAXFILES
   ld hl,_fdtbl

.loop

   ld a,(hl)
   inc hl
   or (hl)
   ret z

   inc hl
   djnz loop
   
   scf
   ret
