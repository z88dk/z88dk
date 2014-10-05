
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; int fzx_setat(uchar y, uchar x)
;
; Set print position to indicated (x,y) pixel coordinate.
;
; ===============================================================

SECTION seg_code_fzx

PUBLIC asm_fzx_setat

EXTERN _fzx

DEFC MARGIN = 2
DEFC P_COL = 4
DEFC P_LIN = 5

asm_fzx_setat:

   ; enter : h = y coord
   ;         l = x coord
   ; exit  : carry reset if coords are out of range
   ;         else set current print position  
   ; uses  : af

   ld a,h
   cp 192
   ret nc
   
   ld a,(_fzx + MARGIN)
   cp l
   jr c, no_change
   ld l,a                      ; set x coord to left margin

no_change:

   ld (_fzx + P_COL),hl
  
   scf
   ret
