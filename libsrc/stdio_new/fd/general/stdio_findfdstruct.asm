; stdio_findfdstruct
; 07.2009 aralbrec

PUBLIC stdio_findfdstruct
PUBLIC LIBDISP_STDIO_FINDFDSTRUCT
EXTERN _stdio_fdtbl

; return address of table entry holding fdstruct address
;
; enter : ix = fdstruct *
; exit  : hl = & stdio_fdtbl[fd] + 1, b = STDIO_NUMFD - fd, carry reset
;         carry set if fdstruct not in fdtbl
; uses  : af, b, hl

INCLUDE "../../stdio.def"

.stdio_findfdstruct

   ld b,STDIO_NUMFD
   ld hl,_stdio_fdtbl

.libentry
.loop0

   ld a,(hl)
   cp ixl
   inc hl
   jr nz, loop1
   
   ld a,(hl)
   cp ixh
   ret z                       ; found!
   
.loop1

   inc hl
   djnz loop0
   
   scf
   ret

defc LIBDISP_STDIO_FINDFDSTRUCT = # libentry - stdio_findfdstruct
