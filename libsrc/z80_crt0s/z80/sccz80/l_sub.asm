;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_sub

; HL = DE - HL

.l_sub 
	ex	de,hl
	and	a
	sbc	hl,de	
	ret
IF 0
        ld a,e
        sub   l
        ld l,a
        ld a,d
        sbc   a,h
        ld h,a
        ret
ENDIF

