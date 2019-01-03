;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                SECTION   code_crt0_sccz80
                PUBLIC    l_pint

; store int from HL into (DE)
.l_pint   
IF EZ80
	ex	de,hl
	defb	0xed, 0x1f	;ld (hl),de
	ex	de,hl
ELSE
        ld a,l
        ld (de),a
        inc   de
        ld a,h
        ld (de),a
ENDIF
        ret
