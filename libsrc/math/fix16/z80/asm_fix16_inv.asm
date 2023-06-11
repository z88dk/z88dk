;
; Z80 fixed Q8.8 maths routines
;
; These routines have been adapted from two sources:
;
; https://learn.cemetech.net/index.php/Z80:Advanced_Math
; 
; and
; 
; https://github.com/Zeda/Z80-Optimized-Routines/tree/master/math
;
;

    SECTION code_math
    PUBLIC  asm_fix16_inv

; Entry: h.l = number
;        h.l = 1 / number
asm_fix16_inv:
    ex      de,hl

DEgt1_Inv:
   ;1/D.E->B.C
   ; 470 to 518 t-states
   	ld hl,256
   	ld b,8
   InvLoop:
   	add hl,hl
   	sbc hl,de
   	jr nc,skip_add
   	add hl,de
skip_add:
   	rla
   	djnz InvLoop
   	cpl
   	ld c,a
    ld      hl,bc       ;Get value into hl for our abi
   	ret
