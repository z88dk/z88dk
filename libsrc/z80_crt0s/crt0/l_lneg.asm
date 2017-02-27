;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
PUBLIC    l_lneg


; HL = !HL
; set carry if result true

.l_lneg

   ld a,h
   or l
	ld hl,0
   ret nz
   scf
	inc l
   ret
   

;        ld a,h
;        or l
;        jr z,l_lneg1
;        ld hl,0
;	and	a	;reset c (already done by or l)
;        ret
;.l_lneg1  
;        inc   l
;	scf
;        ret
