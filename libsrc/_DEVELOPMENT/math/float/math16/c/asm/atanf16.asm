;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 16557-c8c1932a6-20200617
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sun Jun 21 19:23:37 2020


	C_LINE	0,"atanf16.c"

	MODULE	atanf16_c


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
	C_LINE	2,"atanf16.c"
	C_LINE	21,"atanf16.c"
	C_LINE	23,"atanf16.c"
	SECTION	code_compiler

; Function atanf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tatanf16(_Float16 f)
; parameter '_Float16 f' at 2 size(2)
	C_LINE	24,"atanf16.c::atanf16"
.atanf16
	GLOBAL	_atanf16
._atanf16
	push	hl
	push	bc
	dec	sp
	ld	hl,3	;const
	call	l_gintsp	;
	call	fabsf16
	pop	bc
	push	hl
	push	hl
	ld	hl,0	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_2
	ld	hl,0	;const
	inc	sp
	pop	bc
	pop	bc
	ret


.i_2
	ld	hl,2	;const
	add	hl,sp
	push	hl
	ld	hl,2	;const
	call	l_gintspsp	;
	ld	hl,15360	;const
	call	l_f16_gt
	pop	de
	ld	a,l
	ld	(de),a
	and	a
	jp	z,i_3
	pop	hl
	push	hl
	call	invf16
	pop	bc
	push	hl
.i_3
	pop	hl
	push	hl
	push	hl
	ld	hl,_f16_coeff_atan
	push	hl
	ld	hl,7	;const
	push	hl
	call	polyf16
	pop	bc
	push	hl
	ld	hl,2	;const
	add	hl,sp
	ld	a,(hl)
	and	a
	jp	z,i_4
	ld	hl,0	;const
	add	hl,sp
	call	l_gint
	ld	bc,15944	;const
	push	bc
	call	l_f16_sub
	pop	bc
	push	hl
.i_4
	ld	hl,3	;const
	call	l_gintspsp	;
	ld	hl,0	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_6
	pop	hl
	push	hl
	ld	a,h
	xor	128
	ld	h,a
	jp	i_7
.i_6
	pop	hl
	push	hl
.i_7
	inc	sp
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
	GLOBAL	_f16_coeff_atan


; --- End of Scope Defns ---


; --- End of Compilation ---
