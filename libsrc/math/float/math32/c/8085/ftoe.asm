;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25884-473c5c9c7b-20260914
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Tue Sep 15 09:27:05 2026


	C_LINE	0,"ftoe.c"

	MODULE	ftoe_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	C_LINE	6,"ftoe.c"
	C_LINE	8,"ftoe.c"
	C_LINE	11,"ftoe.c"
	SECTION	rodata_compiler
._pow10f_tab
	defb	221,199,89,0
	defb	234,28,8,2
	defb	37,36,170,3
	defb	46,173,84,5
	defb	61,236,4,7
	defb	76,39,166,8
	defb	31,177,79,10
	defb	179,206,1,12
	defb	96,66,162,13
	defb	248,210,74,15
	defb	182,135,253,16
	defb	210,116,158,18
	defb	6,18,70,20
	defb	136,150,247,21
	defb	21,190,154,23
	defb	154,109,65,25
	defb	1,201,241,26
	defb	160,29,151,28
	defb	8,229,60,30
	defb	74,30,236,31
	defb	239,146,147,33
	defb	170,119,56,35
	defb	149,149,230,36
	defb	125,29,144,38
	defb	220,36,52,40
	defb	19,46,225,41
	defb	204,188,140,43
	defb	255,235,47,45
	defb	255,230,219,46
	defb	95,112,137,48
	defb	119,204,43,50
	defb	149,191,214,51
	defb	189,55,134,53
	defb	172,197,39,55
	defb	23,183,209,56
	defb	111,18,131,58
	defb	10,215,35,60
	defb	205,204,204,61
	defb	0,0,128,63
	defb	0,0,32,65
	defb	0,0,200,66
	defb	0,0,122,68
	defb	0,64,28,70
	defb	0,80,195,71
	defb	0,36,116,73
	defb	128,150,24,75
	defb	32,188,190,76
	defb	40,107,110,78
	defb	249,2,21,80
	defb	183,67,186,81
	defb	165,212,104,83
	defb	231,132,17,85
	defb	33,230,181,86
	defb	169,95,99,88
	defb	202,27,14,90
	defb	188,162,177,91
	defb	107,11,94,93
	defb	35,199,10,95
	defb	236,120,173,96
	defb	39,215,88,98
	defb	120,134,7,100
	defb	22,104,169,101
	defb	28,194,83,103
	defb	81,89,4,105
	defb	166,111,165,106
	defb	143,203,78,108
	defb	57,63,1,110
	defb	8,143,161,111
	defb	202,242,73,113
	defb	124,111,252,114
	defb	174,197,157,116
	defb	25,55,69,118
	defb	223,132,246,119
	defb	12,19,154,121
	defb	206,151,64,123
	defb	194,189,240,124
	defb	153,118,150,126
	SECTION	code_compiler
	C_LINE	26,"ftoe.c"

; Function pow10_int flags 0x00000200 __smallc 
; unsigned long pow10_int(int n)
; parameter 'int n' at sp+2 size(2)
	C_LINE	27,"ftoe.c::pow10_int::0::0"
._pow10_int
	ld	hl,1	;const
	ld	de,0
	push	de
	push	hl
	ld	hl,10	;const
	ld	de,0
	push	de
	push	hl
.i_3
	ld	de,sp+10
	ld	hl,(de)	;l_gint
	ld	bc,hl
	ld	hl,0
	call	l_gt_hlbc	;bc>hl
	jp	nc,i_4	;
	ld	de,sp+10
	ld	hl,(de)	;l_gint
	ld	a,l
	and	1
	jp	z,i_5	;
	ld	de,sp+4
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	de,sp+6
	ex	de,hl
	call	l_glong
	call	l_long_mult_u
	pop	bc
	call	l_plong
.i_5
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	de,sp+6
	ex	de,hl
	call	l_glong
	call	l_long_mult_u
	pop	bc
	call	l_plong
	ld	de,sp+10
	push	de
	ld	hl,(de)	;l_gint
	sra	hl
	pop	de
	ld	(de),hl	;l_pint
	jp	i_3	;EOS
.i_4
	ld	de,sp+4
	ex	de,hl
	call	l_glong
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret


	C_LINE	41,"ftoe.c::pow10_int::0::2"

; Function find_expon flags 0x00000200 __smallc 
; int find_expon(double x)
; parameter 'double x' at sp+2 size(4)
	C_LINE	42,"ftoe.c::find_expon::0::2"
._find_expon
	ld	hl,65498	;const
	push	hl
	ld	de,38	;const
	push	de
	push	hl
.i_6
	ld	de,sp+4
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+4
	ld	hl,(de)	;l_gint
	pop	bc
	call	l_le_hlbc	;bc<=hl
	jp	nc,i_7	;
	ld	de,sp+4
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+4
	ld	hl,(de)	;l_gint
	pop	de
	add	hl,de
	sra	hl
	push	hl
	ld	de,sp+10
	ex	de,hl
	call	l_glong2sp
	ld	hl,_pow10f_tab
	push	hl
	ld	de,sp+6
	ld	hl,(de)	;l_gint
	ld	bc,38
	add	hl,bc
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	call	l_glong
	call	l_f32_ge
	ld	a,h
	or	l
	jp	z,i_8	;
	pop	hl
	ld	d,h
	ld	e,l
	pop	bc
	push	hl
	push	de
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	inc	hl
	pop	de
	ld	(de),hl	;l_pint
	jp	i_9	;EOS
.i_8
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	dec	hl
	pop	de
	ld	(de),hl	;l_pint
.i_9
	pop	bc
	jp	i_6	;EOS
.i_7
	pop	hl
	push	hl
	pop	bc
	pop	bc
	pop	bc
	ret


	C_LINE	59,"ftoe.c::find_expon::0::6"

; Function ftoe flags 0x00000280 __smallc 
; void ftoe(double x, int prec, char * str)
; parameter 'char * str' at sp+2 size(2)
; parameter 'int prec' at sp+4 size(2)
; parameter 'double x' at sp+6 size(4)
	C_LINE	63,"ftoe.c::ftoe::0::6"
.ftoe
	GLOBAL	_ftoe
._ftoe
	GLOBAL	___ftoe
.___ftoe
	ld	hl,65508	;const
	add	hl,sp
	ld	sp,hl
	ld	de,sp+32
	ld	hl,(de)	;l_gint
	ld	a,h
	rla
	jp	nc,i_10	;
	ld	de,sp+32
	ld	hl,6	;const
	ld	(de),hl
.i_10
	ld	de,sp+32
	ld	hl,(de)	;l_gint
	ld	bc,hl
	ld	hl,7
	call	l_gt_hlbc	;bc>hl
	jp	nc,i_11	;
	ld	de,sp+32
	ld	hl,7	;const
	ld	(de),hl
.i_11
	push	bc
	push	bc
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	de,sp+40
	ex	de,hl
	call	l_glong
	pop	bc
	call	l_plong
	ld	hl,8	;const
	add	hl,sp
	push	hl
	ld	de,sp+2
	ex	de,hl
	call	l_glong
	pop	bc
	call	l_plong
	pop	bc
	pop	bc
	ld	de,sp+34
	ex	de,hl
	call	l_glong2sp
	ld	de,sp+38
	ex	de,hl
	call	l_glong
	call	l_f32_ne
	ld	a,h
	or	l
	jp	z,i_12	;
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,110
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,97
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,110
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	ld	(hl),0
	ld	e,(hl)
	ld	d,0
	ld	hl,28	;const
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	ret


.i_12
	ld	de,sp+4
	ex	de,hl
	call	l_glong
	ld	a,d
	and	127
	ld	d,a
	ld	bc,0
	sub	hl,bc
	jp	nz,ASMPC+12
	ex	de,hl
	ld	bc,32640
	sub	hl,bc
	scf
	jp	z,ASMPC+4
	and	a
	jp	nc,i_13	;
	ld	de,sp+4
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,32768
	call	l_long_and
	ld	a,h
	or	l
	or	d
	or	e
	jp	z,i_14	;
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	(hl),45
.i_14
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,105
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,110
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,102
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	ld	(hl),0
	ld	e,(hl)
	ld	d,0
	ld	hl,28	;const
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	ret


.i_13
	ld	de,sp+34
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_15	;
	ld	hl,20	;const
	add	hl,sp
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,48
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,46
	ld	(de),a
	ld	de,sp+18
	ld	hl,0	;const
	ld	(de),hl
	jp	i_18	;EOS
.i_16
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
.i_18
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+34
	ld	hl,(de)	;l_gint
	pop	bc
	call	l_lt_hlbc	;bc<hl
	jp	nc,i_17	;
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	(hl),48
	jp	i_16	;EOS
.i_15
	ld	hl,22	;const
	add	hl,sp
	push	hl
	ld	de,sp+36
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	ld	a,h
	or	l
	jp	z,i_20	;
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,45
	ld	(de),a
	ld	de,sp+34
	ex	de,hl
	push	hl
	call	l_glong
	ld	a,d
	xor	128
	ld	d,a
	pop	bc
	call	l_plong
.i_20
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	de,sp+36
	ex	de,hl
	call	l_glong
	pop	bc
	call	l_plong
	ld	de,sp+0
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_eq
	ld	a,h
	or	l
	jp	nz,i_22	;
	ld	de,sp+4
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,32640
	call	l_long_and
	ld	a,d
	or	e
	or	h
	or	l
	jp	nz,ASMPC+4
	scf
	jp	nc,i_23	;
	ld	de,sp+4
	ex	de,hl
	call	l_glong2sp
	ld	hl,65535	;const
	ld	de,127
	call	l_long_and
	ld	a,d
	or	e
	or	h
	or	l
	jp	z,ASMPC+4
	scf
	jp	nc,i_23	;
.i_22
	ld	hl,20	;const
	add	hl,sp
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,48
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,46
	ld	(de),a
	ld	de,sp+18
	ld	hl,0	;const
	ld	(de),hl
	jp	i_28	;EOS
.i_26
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
.i_28
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+34
	ld	hl,(de)	;l_gint
	pop	bc
	call	l_lt_hlbc	;bc<hl
	jp	nc,i_27	;
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	(hl),48
	jp	i_26	;EOS
.i_21
	ld	hl,20	;const
	add	hl,sp
	push	hl
	ld	de,sp+2
	ex	de,hl
	call	l_glong
	push	de
	push	hl
	call	_find_expon
	pop	bc
	pop	bc
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+32
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	pop	de
	ex	de,hl
	ld	bc,de
	sub	hl,bc
	ld	a,h
	rla
	ccf
	jp	nc,i_29	;
	ld	de,sp+32
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	pop	de
	ex	de,hl
	ld	bc,de
	sub	hl,bc
	push	hl
	ld	bc,hl
	ld	hl,38
	call	l_gt_hlbc	;bc>hl
	jp	nc,i_30	;
	pop	hl
	push	hl
	ld	bc,-38
	add	hl,bc
	jp	i_31	;
.i_30
	ld	hl,0	;const
.i_31
	push	hl
	ld	hl,28	;const
	add	hl,sp
	push	hl
	ld	de,sp+6
	ex	de,hl
	call	l_glong2sp
	ld	hl,_pow10f_tab
	push	hl
	ld	de,sp+10
	ld	hl,(de)	;l_gint
	ld	bc,hl
	ld	hl,38
	call	l_gt_hlbc	;bc>hl
	jp	nc,i_32	;
	ld	hl,38	;const
	jp	i_33	;
.i_32
	ld	de,sp+10
	ld	hl,(de)	;l_gint
.i_33
	ld	bc,38
	add	hl,bc
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	call	l_glong
	call	l_f32_mul
	pop	bc
	call	l_plong
.i_34
	pop	hl
	dec	hl
	push	hl
	inc	hl
	ld	a,h
	or	l
	jp	z,i_35	;
	ld	de,sp+28
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16672
	call	l_f32_mul
	pop	bc
	call	l_plong
	jp	i_34	;EOS
.i_35
	pop	bc
	pop	bc
	jp	i_36	;EOS
.i_29
	ld	hl,24	;const
	add	hl,sp
	push	hl
	ld	de,sp+2
	ex	de,hl
	call	l_glong2sp
	ld	hl,_pow10f_tab
	push	hl
	ld	de,sp+28
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+42
	ld	hl,(de)	;l_gint
	pop	de
	ex	de,hl
	ld	bc,de
	sub	hl,bc
	ld	bc,38
	add	hl,bc
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	call	l_glong
	call	l_f32_div
	pop	bc
	call	l_plong
.i_36
	ld	hl,12	;const
	add	hl,sp
	push	hl
	ld	de,sp+26
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16128
	call	l_f32_add
	call	l_f32_f2ulong
	pop	bc
	call	l_plong
	ld	hl,8	;const
	add	hl,sp
	push	hl
	ld	de,sp+34
	ld	hl,(de)	;l_gint
	inc	hl
	push	hl
	call	_pow10_int
	pop	bc
	pop	bc
	call	l_plong
	ld	de,sp+12
	ex	de,hl
	call	l_glong2sp
	ld	de,sp+12
	ex	de,hl
	call	l_glong
	call	l_long_uge
	jp	nc,i_37	;
	ld	de,sp+12
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	hl,10	;const
	ld	de,0
	call	l_long_div_u
	pop	bc
	call	l_plong
	ld	de,sp+20
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
.i_37
	ld	hl,18	;const
	add	hl,sp
	push	hl
	ld	de,sp+34
	ld	hl,(de)	;l_gint
	pop	de
	ld	(de),hl	;l_pint
	jp	i_40	;EOS
.i_38
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	dec	hl
	ld	(de),hl	;l_pint
.i_40
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	ld	a,h
	rla
	ccf
	jp	nc,i_39	;
	ld	de,sp+18
	ld	hl,(de)	;l_gint
	push	hl
	call	_pow10_int
	pop	bc
	push	de
	push	hl
	ld	hl,20	;const
	add	hl,sp
	push	hl
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	de,sp+6
	ex	de,hl
	call	l_glong
	call	l_long_div_u
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+34
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	push	hl
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	ld	bc,48
	add	hl,bc
	ld	a,l
	pop	de
	ld	(de),a
	ld	de,sp+16
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	de,sp+26
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+8
	ex	de,hl
	call	l_glong
	ld	b,h
	ld	c,l
	ld	hl,0
	ex	(sp),hl
	ld	a,h
	rlca
	jr	nc,i_41
	ex	(sp),hl
	dec	hl
	ex	(sp),hl
.i_41
	push	hl
	ld	h,b
	ld	l,c
	call	l_long_mult_u
	ld	bc,hl
	pop	hl
	sub	hl,bc
	pop	bc
	ld	a,c
	sbc	e
	ld	e,a
	ld	a,b
	sbc	d
	ld	d,a
	pop	bc
	call	l_plong
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+38
	ld	hl,(de)	;l_gint
	pop	bc
	call	l_eq_hlbc	;bc==hl
	jp	nc,i_42	;
	ld	de,sp+34
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	(hl),46
	ld	l,(hl)
	ld	h,0
.i_42
	pop	bc
	pop	bc
	jp	i_38	;EOS
.i_39
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,101
	ld	(de),a
	ld	de,sp+20
	ld	hl,(de)	;l_gint
	ld	a,h
	rla
	jp	nc,i_44	;
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	d,h
	ld	e,l
	ld	a,45
	ld	(de),a
	ld	de,sp+20
	push	de
	ld	hl,(de)	;l_gint
	ld	a,l		;l_neg
	cpl
	ld	l,a
	ld	a,h
	cpl
	ld	h,a
	inc	hl
	pop	de
	ld	(de),hl	;l_pint
	jp	i_45	;EOS
.i_44
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	ld	(hl),43
.i_45
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	push	hl
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	ld	de,10
	ex	de,hl
	call	l_div
	ld	bc,48
	add	hl,bc
	ld	a,l
	pop	de
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	inc	hl
	ld	(de),hl	;l_pint
	dec	hl
	push	hl
	ld	de,sp+22
	ld	hl,(de)	;l_gint
	ld	de,10
	ex	de,hl
	call	l_div
	ex	de,hl
	ld	bc,48
	add	hl,bc
	ld	a,l
	pop	de
	ld	(de),a
	ld	de,sp+30
	ld	hl,(de)	;l_gint
	ld	d,h
	ld	e,l
	xor	a
	ld	(de),a
	ld	hl,28	;const
	add	hl,sp
	ld	sp,hl
	ret


	SECTION	bss_compiler
	SECTION	code_compiler
; --- Start of Optimiser additions ---
	defc	i_17 = i_19
	defc	i_23 = i_21
	defc	i_27 = i_19
	defc	i_25_i_23 = i_22
	defc	i_19 = i_39
	defc	i_43 = i_39


; --- Start of Static Variables ---

	SECTION	bss_compiler
	SECTION	code_compiler


; --- Start of Scope Defns ---

	GLOBAL	f16_f48
	GLOBAL	f16_f32
	GLOBAL	f48_f16
	GLOBAL	f32_f16
	GLOBAL	i16_f16
	GLOBAL	u16_f16
	GLOBAL	i32_f16
	GLOBAL	u32_f16
	GLOBAL	f16_i8
	GLOBAL	f16_i16
	GLOBAL	f16_i32
	GLOBAL	f16_u8
	GLOBAL	f16_u16
	GLOBAL	f16_u32
	GLOBAL	addf16
	GLOBAL	subf16
	GLOBAL	mulf16
	GLOBAL	divf16
	GLOBAL	fmaf16
	GLOBAL	polyf16
	GLOBAL	hypotf16
	GLOBAL	sqrtf16
	GLOBAL	sqrf16
	GLOBAL	div2f16
	GLOBAL	mul2f16
	GLOBAL	mul10f16
	GLOBAL	acosf16
	GLOBAL	asinf16
	GLOBAL	atanf16
	GLOBAL	atan2f16
	GLOBAL	cosf16
	GLOBAL	sinf16
	GLOBAL	tanf16
	GLOBAL	expf16
	GLOBAL	exp2f16
	GLOBAL	exp10f16
	GLOBAL	logf16
	GLOBAL	log2f16
	GLOBAL	log10f16
	GLOBAL	powf16
	GLOBAL	ceilf16
	GLOBAL	floorf16
	GLOBAL	frexpf16
	GLOBAL	ldexpf16
	GLOBAL	invf16
	GLOBAL	invsqrtf16
	GLOBAL	fabsf16
	GLOBAL	negf16
	GLOBAL	sin
	GLOBAL	cos
	GLOBAL	tan
	GLOBAL	sin_fastcall
	GLOBAL	cos_fastcall
	GLOBAL	tan_fastcall
	GLOBAL	asin
	GLOBAL	acos
	GLOBAL	atan
	GLOBAL	asin_fastcall
	GLOBAL	acos_fastcall
	GLOBAL	atan_fastcall
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	sinh
	GLOBAL	cosh
	GLOBAL	tanh
	GLOBAL	sinh_fastcall
	GLOBAL	cosh_fastcall
	GLOBAL	tanh_fastcall
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	asinh_fastcall
	GLOBAL	acosh_fastcall
	GLOBAL	atanh_fastcall
	GLOBAL	inv
	GLOBAL	invsqrt
	GLOBAL	sqr
	GLOBAL	sqrt
	GLOBAL	pow
	GLOBAL	inv_fastcall
	GLOBAL	invsqrt_fastcall
	GLOBAL	sqr_fastcall
	GLOBAL	sqrt_fastcall
	GLOBAL	pow_callee
	GLOBAL	exp
	GLOBAL	exp2
	GLOBAL	exp10
	GLOBAL	log
	GLOBAL	log2
	GLOBAL	log10
	GLOBAL	exp_fastcall
	GLOBAL	exp2_fastcall
	GLOBAL	exp10_fastcall
	GLOBAL	log_fastcall
	GLOBAL	log2_fastcall
	GLOBAL	log10_fastcall
	GLOBAL	ceil
	GLOBAL	floor
	GLOBAL	round
	GLOBAL	ceil_fastcall
	GLOBAL	floor_fastcall
	GLOBAL	round_fastcall
	GLOBAL	fmin
	GLOBAL	fmin_callee
	GLOBAL	fmax
	GLOBAL	fmax_callee
	GLOBAL	div2
	GLOBAL	mul2
	GLOBAL	mul10u
	GLOBAL	div2_fastcall
	GLOBAL	mul2_fastcall
	GLOBAL	mul10u_fastcall
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	frexp
	GLOBAL	frexp_callee
	GLOBAL	fabs
	GLOBAL	fabs_fastcall
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	hypot
	GLOBAL	hypot_callee
	GLOBAL	poly
	GLOBAL	poly_callee
	GLOBAL	atof
	GLOBAL	ftoa
	GLOBAL	ftoe
	GLOBAL	fpclassify
	GLOBAL	open
	GLOBAL	creat
	GLOBAL	close
	GLOBAL	read
	GLOBAL	write
	GLOBAL	lseek
	GLOBAL	readbyte
	GLOBAL	writebyte
	GLOBAL	fsync
	GLOBAL	getcwd
	GLOBAL	chdir
	GLOBAL	getwd
	GLOBAL	rmdir
	GLOBAL	__RND_BLOCKSIZE
	GLOBAL	rnd_loadblock
	GLOBAL	rnd_saveblock
	GLOBAL	rnd_erase
	GLOBAL	rnd_erase_fastcall
	GLOBAL	__FOPEN_MAX
	GLOBAL	__sgoioblk
	GLOBAL	__sgoioblk_end
	GLOBAL	fopen_zsock
	GLOBAL	fileno
	GLOBAL	fopen
	GLOBAL	freopen
	GLOBAL	fdopen
	GLOBAL	_freopen1
	GLOBAL	fmemopen
	GLOBAL	funopen
	GLOBAL	fclose
	GLOBAL	fflush
	GLOBAL	closeall
	GLOBAL	fgets
	GLOBAL	fputs
	GLOBAL	fputs_callee
	GLOBAL	fputc
	GLOBAL	fputc_callee
	GLOBAL	fgetc
	GLOBAL	ungetc
	GLOBAL	feof
	GLOBAL	feof_fastcall
	GLOBAL	ferror
	GLOBAL	ferror_fastcall
	GLOBAL	puts
	GLOBAL	ftell
	GLOBAL	fgetpos
	GLOBAL	fseek
	GLOBAL	fread
	GLOBAL	fwrite
	GLOBAL	gets
	GLOBAL	printf
	GLOBAL	fprintf
	GLOBAL	sprintf
	GLOBAL	snprintf
	GLOBAL	vfprintf
	GLOBAL	vsnprintf
	GLOBAL	sprintff
	GLOBAL	snprintff
	GLOBAL	vsnprintff
	GLOBAL	printn
	GLOBAL	scanf
	GLOBAL	fscanf
	GLOBAL	sscanf
	GLOBAL	vfscanf
	GLOBAL	vsscanf
	GLOBAL	getarg
	GLOBAL	fchkstd
	GLOBAL	fgetc_cons
	GLOBAL	fgetc_cons_inkey
	GLOBAL	fputc_cons
	GLOBAL	fgets_cons
	GLOBAL	puts_cons
	GLOBAL	fabandon
	GLOBAL	fdtell
	GLOBAL	fdgetpos
	GLOBAL	rename
	GLOBAL	remove
	GLOBAL	getk
	GLOBAL	getk_inkey
	GLOBAL	printk
	GLOBAL	perror
	GLOBAL	set_fputc_cons
	GLOBAL	fputc_cons_native
	GLOBAL	fputc_cons_generic
	GLOBAL	fputc_cons_ansi


; --- End of Scope Defns ---


; --- End of Compilation ---
