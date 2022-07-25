;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 19569-078eaec31-20220528
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Mon Jul 25 16:47:05 2022


	C_LINE	0,"m32_atan2f.c"

	MODULE	m32_atan2f_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	EXTERN	saved_de
	C_LINE	0,"m32_math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	10,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	45,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	50,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	60,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	70,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	75,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	80,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	85,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	89,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	90,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	91,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	93,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	94,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	95,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	101,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	106,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	11,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	13,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	14,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	15,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	18,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	19,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	21,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	22,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	23,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	25,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	27,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	29,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	30,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	31,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	33,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	44,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	52,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"m32_math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/limits.h"
	C_LINE	7,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/float.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	6,"/home/phillip/Z80/z88dk/lib/config/../..//include/float.h"
	C_LINE	8,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	27,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	28,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	30,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	31,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	33,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	36,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	119,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	120,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	121,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	122,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	124,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	125,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	126,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	129,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	130,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	131,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	132,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	135,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	136,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	137,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	138,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	140,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	141,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	142,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	145,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	146,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	147,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	148,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	149,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	150,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	151,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	154,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	155,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	161,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	162,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	166,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	167,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	170,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	171,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	36,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	46,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	47,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	48,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	50,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	51,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	56,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	57,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	58,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	59,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	64,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	66,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	67,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	68,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	69,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	74,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	75,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	76,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	82,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	83,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	84,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	85,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	86,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	89,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	90,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	92,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	93,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	97,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	98,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	99,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	102,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	103,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	107,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	108,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	109,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	201,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"m32_math.h"
	C_LINE	37,"m32_math.h"
	C_LINE	48,"m32_math.h"
	C_LINE	49,"m32_math.h"
	C_LINE	50,"m32_math.h"
	C_LINE	51,"m32_math.h"
	C_LINE	52,"m32_math.h"
	C_LINE	53,"m32_math.h"
	C_LINE	54,"m32_math.h"
	C_LINE	57,"m32_math.h"
	C_LINE	58,"m32_math.h"
	C_LINE	59,"m32_math.h"
	C_LINE	60,"m32_math.h"
	C_LINE	61,"m32_math.h"
	C_LINE	62,"m32_math.h"
	C_LINE	65,"m32_math.h"
	C_LINE	66,"m32_math.h"
	C_LINE	67,"m32_math.h"
	C_LINE	68,"m32_math.h"
	C_LINE	69,"m32_math.h"
	C_LINE	70,"m32_math.h"
	C_LINE	71,"m32_math.h"
	C_LINE	74,"m32_math.h"
	C_LINE	75,"m32_math.h"
	C_LINE	76,"m32_math.h"
	C_LINE	77,"m32_math.h"
	C_LINE	78,"m32_math.h"
	C_LINE	79,"m32_math.h"
	C_LINE	82,"m32_math.h"
	C_LINE	83,"m32_math.h"
	C_LINE	84,"m32_math.h"
	C_LINE	85,"m32_math.h"
	C_LINE	86,"m32_math.h"
	C_LINE	87,"m32_math.h"
	C_LINE	88,"m32_math.h"
	C_LINE	89,"m32_math.h"
	C_LINE	90,"m32_math.h"
	C_LINE	91,"m32_math.h"
	C_LINE	2,"m32_atan2f.c"
	C_LINE	4,"m32_atan2f.c"
	SECTION	code_compiler

; Function m32_atan2f flags 0x00000200 __smallc 
; double m32_atan2f(double y, double x)
; parameter 'double x' at sp+2 size(4)
; parameter 'double y' at sp+6 size(4)
	C_LINE	5,"m32_atan2f.c::m32_atan2f::0::0"
._m32_atan2f
	push	bc
	push	bc
	ld	hl,6	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_ne
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	hl,6	;const
	add	hl,sp
	call	l_glong
	call	_m32_fabsf
	push	de
	push	hl
	ld	hl,14	;const
	add	hl,sp
	call	l_glong
	call	_m32_fabsf
	call	l_f32_ge
	ld	a,h
	or	l
	jp	z,i_3	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	hl,12	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,12	;const
	add	hl,sp
	call	l_glong
	call	l_f32_div
	call	_m32_atanf
	pop	bc
	call	l_plong
	ld	hl,6	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_4	;
	ld	hl,10	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_ge
	ld	a,h
	or	l
	jp	z,i_5	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,4059	;const
	ld	de,16457
	call	l_f32_add
	pop	bc
	call	l_plong
	jp	i_6	;EOS
.i_5
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,4059	;const
	ld	de,16457
	call	l_f32_sub
	pop	bc
	call	l_plong
	jp	i_7	;EOS
.i_3
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	hl,8	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,16	;const
	add	hl,sp
	call	l_glong
	call	l_f32_div
	call	_m32_atanf
	ld	a,d
	xor	128
	ld	d,a
	pop	bc
	call	l_plong
	ld	hl,10	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_8	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,4058	;const
	ld	de,16329
	call	l_f32_sub
	pop	bc
	call	l_plong
	jp	i_9	;EOS
.i_8
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,4058	;const
	ld	de,16329
	call	l_f32_add
	pop	bc
	call	l_plong
.i_7
	ld	hl,0	;const
	add	hl,sp
	call	l_glong
	pop	bc
	pop	bc
	ret


.i_2
	ld	hl,10	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_gt
	ld	a,h
	or	l
	jp	z,i_11	;
	ld	hl,4058	;const
	ld	de,16329
	pop	bc
	pop	bc
	ret


.i_11
	ld	hl,10	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_13	;
	ld	hl,4058	;const
	ld	de,49097
	pop	bc
	pop	bc
	ret


.i_10
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	pop	bc
	pop	bc
	ret


; --- Start of Optimiser additions ---
	defc	i_6 = i_4
	defc	i_9 = i_7
	defc	i_13 = i_12
	defc	i_12 = i_10
	defc	i_4 = i_7


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
	GLOBAL	asin
	GLOBAL	acos
	GLOBAL	atan
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	sinh
	GLOBAL	cosh
	GLOBAL	tanh
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	inv
	GLOBAL	invsqrt
	GLOBAL	sqr
	GLOBAL	sqrt
	GLOBAL	pow
	GLOBAL	pow_callee
	GLOBAL	exp
	GLOBAL	exp2
	GLOBAL	exp10
	GLOBAL	log
	GLOBAL	log2
	GLOBAL	log10
	GLOBAL	ceil
	GLOBAL	floor
	GLOBAL	round
	GLOBAL	div2
	GLOBAL	mul2
	GLOBAL	mul10u
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	frexp
	GLOBAL	frexp_callee
	GLOBAL	fabs
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	hypot
	GLOBAL	hypot_callee
	GLOBAL	atof
	GLOBAL	ftoa
	GLOBAL	ftoe
	GLOBAL	_fpclassify
	GLOBAL	_m32_sinf
	GLOBAL	_m32_cosf
	GLOBAL	_m32_tanf
	GLOBAL	_m32_asinf
	GLOBAL	_m32_acosf
	GLOBAL	_m32_atanf
	GLOBAL	_m32_atan2f
	GLOBAL	_m32_sinhf
	GLOBAL	_m32_coshf
	GLOBAL	_m32_tanhf
	GLOBAL	_m32_asinhf
	GLOBAL	_m32_acoshf
	GLOBAL	_m32_atanhf
	GLOBAL	_m32_expf
	GLOBAL	_m32_exp2f
	GLOBAL	_m32_exp10f
	GLOBAL	_m32_logf
	GLOBAL	_m32_log2f
	GLOBAL	_m32_log10f
	GLOBAL	_m32_powf
	GLOBAL	_m32_ceilf
	GLOBAL	_m32_fabsf
	GLOBAL	_m32_floorf
	GLOBAL	_m32_roundf
	GLOBAL	_m32_fmodf
	GLOBAL	_m32_modff
	GLOBAL	_m32_mul2f
	GLOBAL	_m32_div2f
	GLOBAL	_m32_sqrf
	GLOBAL	_m32_invf
	GLOBAL	_m32_sqrtf
	GLOBAL	_m32_invsqrtf
	GLOBAL	_m32_frexpf
	GLOBAL	_m32_ldexpf
	GLOBAL	_m32_hypotf
	GLOBAL	_m32_polyf


; --- End of Scope Defns ---


; --- End of Compilation ---
