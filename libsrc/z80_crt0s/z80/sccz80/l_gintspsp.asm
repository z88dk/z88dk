;       Z88 Small C+ Run time Library
;       l_gint variant to be used sometimes by the peephole optimizer
;

                SECTION   code_crt0_sccz80
PUBLIC l_gintspsp
.l_gintspsp
	add	hl,sp
	inc hl
	inc hl
   
IF EZ80
	defb	0xed, 0x27	;ld hl,(hl)
ELSE
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
ENDIF

	ex	(sp),hl
	jp (hl)
