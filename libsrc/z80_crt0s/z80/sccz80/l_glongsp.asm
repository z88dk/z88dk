;       Z88 Small C+ Run Time Library 
;       l_glong variant to be used sometimes by the peephole optimizer


                SECTION   code_crt0_sccz80
PUBLIC    l_glongsp


;;Fetch long dehl from (hl)
;	add	hl,sp
;	call	l_glong
;	push	de
;	push	hl

.l_glongsp

   add	hl,sp
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
IF EZ80
	defb	0xed, 0x27	;ld hl,(hl)
ELSE
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
ENDIF

   ex de,hl
   pop bc
   push de
   push hl
   push bc
   ret
