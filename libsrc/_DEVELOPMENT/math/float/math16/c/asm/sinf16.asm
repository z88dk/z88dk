;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 16557-c8c1932a6-20200617
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sun Jun 21 19:23:37 2020


	C_LINE	0,"sinf16.c"

	MODULE	sinf16_c


	INCLUDE "z80_crt0.hdr"


	C_LINE	0,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	8,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	9,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	10,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	12,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	13,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	14,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	16,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	18,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	20,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	21,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	22,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	24,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	25,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	28,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	29,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	30,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	60,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	63,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	81,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	82,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	34,"math16.h"
	C_LINE	41,"math16.h"
	C_LINE	66,"math16.h"
	C_LINE	67,"math16.h"
	C_LINE	70,"math16.h"
	C_LINE	71,"math16.h"
	C_LINE	72,"math16.h"
	C_LINE	73,"math16.h"
	C_LINE	76,"math16.h"
	C_LINE	77,"math16.h"
	C_LINE	78,"math16.h"
	C_LINE	79,"math16.h"
	C_LINE	80,"math16.h"
	C_LINE	81,"math16.h"
	C_LINE	84,"math16.h"
	C_LINE	85,"math16.h"
	C_LINE	86,"math16.h"
	C_LINE	87,"math16.h"
	C_LINE	88,"math16.h"
	C_LINE	89,"math16.h"
	C_LINE	90,"math16.h"
	C_LINE	93,"math16.h"
	C_LINE	94,"math16.h"
	C_LINE	97,"math16.h"
	C_LINE	98,"math16.h"
	C_LINE	101,"math16.h"
	C_LINE	102,"math16.h"
	C_LINE	105,"math16.h"
	C_LINE	106,"math16.h"
	C_LINE	2,"sinf16.c"
	C_LINE	4,"sinf16.c"
	C_LINE	5,"sinf16.c"
	C_LINE	7,"sinf16.c"
	SECTION	code_compiler

; Function m32_sinf flags 0x00000200 __smallc 
; _Float16 half_tm32_sinf(_Float16 f)
; parameter '_Float16 f' at 2 size(2)
	C_LINE	8,"sinf16.c::m32_sinf"
._m32_sinf
	push	bc
	push	bc
	push	bc
	push	bc
	ld	hl,10	;const
	call	l_gintspsp	;
	ld	hl,0	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_2
	ld	hl,10	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	ld	a,h
	xor	128
	ld	h,a
	call	l_pint_pop
	ld	hl,2	;const
	pop	de
	pop	bc
	push	hl
	push	de
	jp	i_3
.i_2
	ld	hl,0	;const
	pop	de
	pop	bc
	push	hl
	push	de
.i_3
	ld	hl,10	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,14615	;const
	call	l_f16_mul
	call	l_pint_pop
	ld	hl,10	;const
	call	l_gintspsp	;
	ld	hl,17408	;const
	call	l_f16_gt
	ld	a,h
	or	l
	jp	z,i_5
	ld	hl,10	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,14	;const
	call	l_gintsp	;
	call	div2f16
	call	div2f16
	call	floorf16
	call	mul2f16
	call	mul2f16
	call	l_f16_sub
	call	l_pint_pop
.i_5
	ld	hl,10	;const
	call	l_gintspsp	;
	ld	hl,16384	;const
	call	l_f16_gt
	ld	a,h
	or	l
	jp	z,i_6
	ld	hl,10	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,16384	;const
	call	l_f16_sub
	call	l_pint_pop
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl,2
	and	a
	sbc	hl,de
	pop	de
	pop	bc
	push	hl
	push	de
.i_6
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,12	;const
	call	l_gintspsp	;
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	hl,16	;const
	call	l_gintsp	;
	call	l_f16_f2sint
	call	l_pint_pop
	call	l_f16_sint2f
	call	l_f16_sub
	call	l_pint_pop
	ld	hl,0	;const
	call	l_gintspsp	;
	ld	hl,4	;const
	call	l_gintsp	;
	pop	de
	add	hl,de
	bit	7,h
	jr	z,i_7
	ld	a,l
	cpl
	inc	a
	ld	l,a
.i_7
	ld	a,l
	and	+(3 % 256)
	ld	l,a
	ld	h,0
	pop	de
	pop	bc
	push	hl
	push	de
	ld	a,l
	and	+(1 % 256)
	jp	z,i_8
	ld	hl,6	;const
	add	hl,sp
	push	hl
	call	l_gint
	ld	bc,15360	;const
	push	bc
	call	l_f16_sub
	call	l_pint_pop
.i_8
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a,l
	and	+(2 % 256)
	jp	z,i_9
	ld	hl,6	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	ld	a,h
	xor	128
	ld	h,a
	call	l_pint_pop
.i_9
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	hl,8	;const
	call	l_gintspsp	;
	ld	hl,10	;const
	call	l_gintsp	;
	call	l_f16_mul
	call	l_pint_pop
	ld	hl,6	;const
	call	l_gintspsp	;
	ld	hl,6	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_f16_coeff_sin_a
	push	hl
	ld	hl,4	;const
	push	hl
	call	polyf16
	call	l_f16_mul
	push	hl
	ld	hl,6	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_f16_coeff_sin_b
	push	hl
	ld	hl,4	;const
	push	hl
	call	polyf16
	call	l_f16_div
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret



; --- Start of Static Variables ---

	SECTION	bss_compiler
	SECTION	code_compiler


; --- Start of Scope Defns ---

	GLOBAL	fmaf16
	GLOBAL	polyf16
	GLOBAL	sqrtf16
	GLOBAL	div2f16
	GLOBAL	mul2f16
	GLOBAL	mul10f16
	GLOBAL	sinf16
	GLOBAL	cosf16
	GLOBAL	tanf16
	GLOBAL	asinf16
	GLOBAL	acosf16
	GLOBAL	atanf16
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
	GLOBAL	_f16_coeff_sin_a
	GLOBAL	_f16_coeff_sin_b
	GLOBAL	_m32_sinf


; --- End of Scope Defns ---


; --- End of Compilation ---
