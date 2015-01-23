; void closeall(void)
; 07.2009 aralbrec

PUBLIC closeall

EXTERN close
EXTERN LIBDISP2_CLOSE

INCLUDE "../stdio.def"

; close all open fds
; does not close any open FILEs -- for that see fcloseall
; fcloseall should always be called before closeall
; running closeall without first running fcloseall can
; orphan open FILEs with bad consequences.

.closeall

   ld hl,_stdio_fdtbl
   ld b,STDIO_NUMFD
   
.loop

   ld e,(hl)
   ld ixl,e
   inc hl
   ld a,(hl)
   ld ixh,a                    ; ix = fdstruct*
   
   push hl
   push bc
   
   or e
   call nz, close + LIBDISP2_CLOSE
   
   pop bc
   pop hl
   
   inc hl
   djnz loop
   
   ret
