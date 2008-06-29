; void closeall(void)
; 06.2008 aralbrec

XLIB closeall

LIB close, fclose
XREF LIBDISP_CLOSE, _filelist

INCLUDE "stdio.def"

.closeall

   ; close all open files, typically called before program exit

   ; 1. close open FILE*
   
   ld hl,(_filelist)
   
.loop0

   ld a,h                      ; done with open FILEs?
   or l
   jr z, closefds
   
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   push de
   call fclose
   pop hl
   
   jr loop0
      
   ; 2. close any remaining open fds

.closefds

   ld hl,_fdtbl
   ld b,MAXFILES

.loop1

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
   
   djnz loop1
   ret
