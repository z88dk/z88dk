; void closeall(void)
; 06.2008 aralbrec

XLIB closeall

LIB close
XREF LIBDISP_CLOSE

INCLUDE "stdio.def"

.closeall

   ; close all open files, typically called before program exit
   ; does not deallocate FILE* but does deallocate low-level fdstructs
   
   ld hl,_fdtbl
   ld b,MAXFILES

.loop

   ld e,(hl)
   ld (hl),0
   inc hl
   ld d,(hl)
   ld (hl),0
   inc hl
   
   push hl
   push bc
   ld a,d
   or e
   call nz, close + LIBDISP_CLOSE
   pop bc
   pop hl
   
   djnz loop
   ret
