;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 16557-c8c1932a6-20200617
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sun Jun 21 19:23:37 2020


	C_LINE	0,"logf16.c"

	MODULE	logf16_c


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
	C_LINE	44,"logf16.c"
	C_LINE	48,"logf16.c"
	C_LINE	50,"logf16.c"
	SECTION	code_compiler

; Function logf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tlogf16(_Float16 x)
; parameter '_Float16 x' at 2 size(2)
	C_LINE	51,"logf16.c::logf16"
.logf16
	GLOBAL	_logf16
._logf16
	push	hl
	push	bc
	push	bc
	push	bc
	push	bc
	ld	hl,8	;const
	call	l_gintspsp	;
	ld	hl,0	;const
	call	l_f16_le
	ld	a,h
	or	l
	jp	z,i_2
	ld	hl,64511	;const
	call	l_f16_sint2f
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret


.i_2
	ld	hl,8	;const
	add	hl,sp
	push	hl
	ld	hl,10	;const
	call	l_gintspsp	;
	ld	hl,4	;const
	add	hl,sp
	push	hl
	call	frexpf16
	call	l_pint_pop
	ld	hl,8	;const
	call	l_gintspsp	;
	ld	hl,14760	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_3
	pop	hl
	dec	hl
	push	hl
	ld	hl,8	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	call	mul2f16
	push	hl
	ld	hl,15360	;const
	call	l_f16_sub
	call	l_pint_pop
	jp	i_5
.i_3
	ld	hl,8	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,15360	;const
	call	l_f16_sub
	call	l_pint_pop
.i_5
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	hl,10	;const
	call	l_gintspsp	;
	ld	hl,12	;const
	call	l_gintsp	;
	call	l_f16_mul
	call	l_pint_pop
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,10	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,(_f16_coeff_log)
	push	hl
	ld	hl,9	;const
	push	hl
	call	polyf16
	push	hl
	ld	hl,8	;const
	call	l_gintsp	;
	call	l_f16_mul
	call	l_pint_pop
	pop	hl
	push	hl
	call	l_f16_sint2f
	pop	de
	pop	bc
	push	hl
	push	de
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,6	;const
	call	l_gintspsp	;
	ld	hl,35572	;const
	call	l_f16_mul
	call	l_f16_add
	call	l_pint_pop
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,8	;const
	call	l_gintsp	;
	call	div2f16
	call	l_f16_sub
	call	l_pint_pop
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	hl,10	;const
	call	l_gintspsp	;
	ld	hl,10	;const
	call	l_gintsp	;
	call	l_f16_add
	call	l_pint_pop
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,6	;const
	call	l_gintspsp	;
	ld	hl,14732	;const
	call	l_f16_mul
	call	l_f16_add
	call	l_pint_pop
	ld	hl,4	;const
	call	l_gintsp	;
	pop	bc
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
	GLOBAL	_f16_coeff_log


; --- End of Scope Defns ---


; --- End of Compilation ---
