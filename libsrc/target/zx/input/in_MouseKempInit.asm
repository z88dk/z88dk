; void in_MouseKempInit(void)
; 09.2005 aralbrec

; mainly for symmetry with AMX mouse functions

SECTION code_clib
PUBLIC in_MouseKempInit
PUBLIC _in_MouseKempInit

EXTERN INMouseKemp
EXTERN _in_KempcoordX, _in_KempcoordY

; just set initial coordinates to (0,0)
; uses : AF

.in_MouseKempInit
._in_MouseKempInit

   call INMouseKemp          ; to zero out current delta
   
   xor a
   ld (_in_KempcoordX),a
   ld (_in_KempcoordY),a
   
   ret
