;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 19569-078eaec31-20220528
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Thu Jun 16 20:23:14 2022


	C_LINE	0,"am9511_round.c"

	MODULE	am9511_round_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	EXTERN	saved_de
	C_LINE	0,"am9511_math.h"
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
	C_LINE	34,"am9511_math.h"
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
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	36,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	46,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	47,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	48,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	50,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	51,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	56,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	57,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	62,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	63,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	64,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	66,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	67,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	72,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	73,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	74,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	80,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	81,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	82,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	83,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	84,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	87,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	88,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	90,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	91,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	95,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	96,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	97,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	100,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	101,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	105,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	106,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	107,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	109,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	110,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	203,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	47,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"am9511_math.h"
	C_LINE	37,"am9511_math.h"
	C_LINE	100,"am9511_math.h"
	C_LINE	101,"am9511_math.h"
	C_LINE	102,"am9511_math.h"
	C_LINE	103,"am9511_math.h"
	C_LINE	104,"am9511_math.h"
	C_LINE	105,"am9511_math.h"
	C_LINE	107,"am9511_math.h"
	C_LINE	110,"am9511_math.h"
	C_LINE	111,"am9511_math.h"
	C_LINE	112,"am9511_math.h"
	C_LINE	113,"am9511_math.h"
	C_LINE	114,"am9511_math.h"
	C_LINE	115,"am9511_math.h"
	C_LINE	118,"am9511_math.h"
	C_LINE	119,"am9511_math.h"
	C_LINE	120,"am9511_math.h"
	C_LINE	121,"am9511_math.h"
	C_LINE	123,"am9511_math.h"
	C_LINE	124,"am9511_math.h"
	C_LINE	125,"am9511_math.h"
	C_LINE	128,"am9511_math.h"
	C_LINE	129,"am9511_math.h"
	C_LINE	130,"am9511_math.h"
	C_LINE	132,"am9511_math.h"
	C_LINE	133,"am9511_math.h"
	C_LINE	134,"am9511_math.h"
	C_LINE	137,"am9511_math.h"
	C_LINE	138,"am9511_math.h"
	C_LINE	139,"am9511_math.h"
	C_LINE	140,"am9511_math.h"
	C_LINE	141,"am9511_math.h"
	C_LINE	142,"am9511_math.h"
	C_LINE	143,"am9511_math.h"
	C_LINE	12,"am9511_round.c"
	C_LINE	15,"am9511_round.c"
	SECTION	code_compiler

; Function am9511_round flags 0x00000208 __smallc __z88dk_fastcall 
; double am9511_round(double x)
; parameter 'double x' at sp+2 size(4)
	C_LINE	16,"am9511_round.c::am9511_round::0::0"
._am9511_round
	push	de
	push	hl
	ld	hl,65524	;const
	add	hl,sp
	ld	sp,hl
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,14	;const
	add	hl,sp
	call	l_glong
	pop	bc
	call	l_plong
	ld	hl,2	;const
	add	hl,sp
	push	hl
	ld	hl,8	;const
	add	hl,sp
	call	l_glong
	pop	bc
	call	l_plong
	ld	hl,10	;const
	add	hl,sp
	push	hl
	ld	hl,4	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,32768
	call	l_long_and
	pop	de
	ld	(de),hl
	ld	hl,2	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,32640
	call	l_long_and
	ld	hl,7
	call	l_asr_u
	inc	e
	ld	bc,-127
	add	hl,bc
	pop	bc
	push	hl
	ld	a,l
	sub	23
	ld	a,h
	rla
	ccf
	rra
	sbc	128
	jp	nc,i_2	;
	pop	hl
	push	hl
	ld	a,h
	rla
	jp	nc,i_3	;
	ld	hl,2	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,32768
	call	l_long_and
	pop	bc
	call	l_plong
	pop	hl
	push	hl
	ld	de,65535
	call	l_eq
	jp	nc,i_4	;
	ld	hl,2	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16256
	call	l_long_or
	pop	bc
	call	l_plong
	jp	i_5	;EOS
.i_3
	pop	hl
	push	hl
	call	l_int2long_s
	ld	bc,127
	push	bc
	ld	bc,65535
	push	bc
	call	l_long_asr
	push	hl
	ld	hl,4	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	de,0
	call	l_long_and
	ld	a,d
	or	e
	or	h
	or	l
	jp	nz,ASMPC+4
	scf
	jp	nc,i_6	;
	ld	hl,14	;const
	add	hl,sp
	call	l_glong
	ld	c,l
	ld	b,h
	ld	hl,18	;const
	add	hl,sp
	ld	sp,hl
	ld	l,c
	ld	h,b
	ret


.i_6
	ld	hl,4	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,8	;const
	add	hl,sp
	call	l_gint	;
	call	l_int2long_s
	ld	bc,64
	push	bc
	ld	bc,0
	push	bc
	call	l_long_asr
	call	l_long_add
	pop	bc
	call	l_plong
	ld	hl,4	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,6	;const
	add	hl,sp
	call	l_gint	;
	call	l_com
	ld	de,0
	call	l_long_and
	pop	bc
	call	l_plong
	pop	bc
	jp	i_7	;EOS
.i_2
	pop	hl
	push	hl
	ld	de,128
	call	l_eq
	jp	nc,i_8	;
	ld	hl,12	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,16	;const
	add	hl,sp
	call	l_glong
	call	l_f32_add
	ld	c,l
	ld	b,h
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	l,c
	ld	h,b
	ret


.i_8
	ld	hl,12	;const
	add	hl,sp
	call	l_glong
	ld	c,l
	ld	b,h
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	l,c
	ld	h,b
	ret


.i_7
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,4	;const
	add	hl,sp
	call	l_glong
	pop	bc
	call	l_plong
	ld	hl,6	;const
	add	hl,sp
	call	l_glong
	ld	c,l
	ld	b,h
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	l,c
	ld	h,b
	ret


; --- Start of Optimiser additions ---
	defc	i_9 = i_7
	defc	i_4 = i_5
	defc	i_5 = i_7


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
	GLOBAL	_sin
	GLOBAL	_cos
	GLOBAL	_tan
	GLOBAL	_asin
	GLOBAL	_acos
	GLOBAL	_atan
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	sinh
	GLOBAL	cosh
	GLOBAL	tanh
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	_sqr
	GLOBAL	_sqrt
	GLOBAL	pow
	GLOBAL	_pow_callee
	GLOBAL	_exp
	GLOBAL	exp2
	GLOBAL	exp10
	GLOBAL	_log
	GLOBAL	log2
	GLOBAL	_log10
	GLOBAL	_ceil
	GLOBAL	_floor
	GLOBAL	round
	GLOBAL	_div2
	GLOBAL	_mul2
	GLOBAL	mul10u
	GLOBAL	ldexp
	GLOBAL	_ldexp_callee
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	frexp
	GLOBAL	_frexp_callee
	GLOBAL	_fabs
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	hypot
	GLOBAL	_hypot_callee
	GLOBAL	atof
	GLOBAL	ftoa
	GLOBAL	ftoe
	GLOBAL	f32_fam9511
	GLOBAL	fam9511_f32
	GLOBAL	_fpclassify
	GLOBAL	_am9511_atan2
	GLOBAL	_am9511_sinh
	GLOBAL	_am9511_cosh
	GLOBAL	_am9511_tanh
	GLOBAL	_am9511_asinh
	GLOBAL	_am9511_acosh
	GLOBAL	_am9511_atanh
	GLOBAL	_am9511_log2
	GLOBAL	_am9511_exp2
	GLOBAL	_am9511_exp10
	GLOBAL	_am9511_round
	GLOBAL	_am9511_fmod
	GLOBAL	_am9511_modf


; --- End of Scope Defns ---


; --- End of Compilation ---
