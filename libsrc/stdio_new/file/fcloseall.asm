; void fcloseall(void)
; 07.2009 aralbrec

PUBLIC fcloseall

EXTERN fclose
EXTERN _stdio_filetbl, LIBDISP2_FCLOSE

INCLUDE "../stdio.def"

; close all open high level FILEs, including stdin / stdout / stderr
; does not necessarily close all open fds -- for that see closeall
; fcloseall should always be called before closeall

.fcloseall
 
   ld hl,_stdio_filetbl - 6    ; include stdin / stdout / stderr
   ld b,STDIO_NUMFILE + 3

.loop

   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                    ; ix = FILE*
   
   push hl
   push bc
   call closefile
   pop bc
   pop hl
   
   inc hl
   djnz loop
   
   ret

.closefile

   ld a,ixl
   or ixh
   call nz, fclose + LIBDISP2_FCLOSE
   ret
