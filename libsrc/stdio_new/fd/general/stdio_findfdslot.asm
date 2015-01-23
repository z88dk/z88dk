; stdio_findfdslot
; 06.2008 aralbrec

PUBLIC stdio_findfdslot
PUBLIC LIBDISP_STDIO_FINDFDSLOT
EXTERN _stdio_fdtbl

INCLUDE "../../stdio.def"

.stdio_findfdslot

   ; find the first available slot in fdtbl for a new file
   ;
   ; exit :  b = STDIO_NUMFD - fd
   ;        hl = MSB of fdtbl entry
   ;        carry set if no available slot
   ; uses : af, b, hl

   ld b,STDIO_NUMFD
   ld hl,_stdio_fdtbl

.libentry
.loop

   ld a,(hl)
   inc hl
   or (hl)
   ret z

   inc hl
   djnz loop
   
   scf
   ret

defc LIBDISP_STDIO_FINDFDSLOT = # libentry - stdio_findfdslot
