;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25461-415806f08c-20260813
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Tue Sep  8 20:53:13 2026

	C_LINE	0,"atanf16.c"

	MODULE	atanf16_c


	INCLUDE "z80_crt0.hdr"


	C_LINE	0,"math16.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/sys/compiler.h"
	C_LINE	8,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	10,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	11,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	12,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	14,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	15,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	16,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	18,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	19,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	20,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	22,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	23,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	24,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	26,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	27,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	28,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	30,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	31,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	32,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	62,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	63,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	65,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	66,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	68,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	69,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	75,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	78,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	96,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	97,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/stdint.h"
	C_LINE	34,"math16.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	25,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	42,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	54,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	199,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	208,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	217,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	229,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	230,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	237,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	246,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	255,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	265,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	274,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	283,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	293,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	302,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	311,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	321,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	330,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	339,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	347,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	348,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	352,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	353,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	357,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	358,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	362,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	363,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	369,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	379,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	388,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	397,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	406,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	415,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	425,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	433,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	434,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	438,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	439,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	445,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	454,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	464,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	473,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	482,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	491,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	501,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	510,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	519,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	528,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	537,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	546,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	555,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	564,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	579,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	580,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	584,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	585,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	591,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	592,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	596,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	597,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	602,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	603,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	608,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	617,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	618,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	622,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	623,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	628,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	629,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	633,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	634,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	638,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	639,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	644,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	645,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	650,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	651,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	655,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	656,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	660,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	661,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	665,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	666,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	670,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	671,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	675,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	676,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	925,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	934,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	944,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	953,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	963,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	972,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	981,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	990,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1000,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1009,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1018,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1027,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1036,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1045,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1054,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1055,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1059,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1060,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1064,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1065,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1069,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1070,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1075,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1076,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1080,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1081,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1085,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1086,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1092,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1101,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1111,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1121,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1130,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1139,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1147,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1148,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1152,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1153,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1159,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1168,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1177,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1185,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1186,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1192,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1201,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1210,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1220,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1229,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1238,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1247,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1256,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1265,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1273,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1274,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1280,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1289,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1298,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1307,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1316,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1317,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1321,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1322,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1326,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1327,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1331,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1332,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1336,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1337,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1341,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1342,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1346,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	1347,"/data/z88dk/lib/config/../..//include/_DEVELOPMENT/common/math.h"
	C_LINE	35,"math16.h"
	C_LINE	37,"math16.h"
	C_LINE	2,"atanf16.c"
	C_LINE	21,"atanf16.c"
	C_LINE	23,"atanf16.c"
	SECTION	code_compiler

; Function atanf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tatanf16(_Float16 f)
; parameter '_Float16 f' at sp+2 size(2)
	C_LINE	24,"atanf16.c::atanf16::0::0"
.atanf16
	GLOBAL	_atanf16
._atanf16
	GLOBAL	___atanf16
.___atanf16
	push	hl
	push	bc
	dec	sp
	call	l_gint3sp	;
	call	fabsf16
	pop	bc
	push	hl
	push	hl
	ld	hl,0	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_2	;
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
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,15360	;const
	call	l_f16_gt
	pop	de
	ld	a,l
	ld	(de),a
	and	a
	jp	z,i_4	;
	ld	hl,0	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	bc,15360	;const
	push	bc
	call	l_f16_div
	pop	bc
	push	hl
.i_4
	pop	hl
	push	hl
	push	hl
	ld	hl,_f16_coeff_atan
	push	hl
	ld	hl,7	;const
	push	hl
	call	polyf16_callee
	pop	bc
	push	hl
	ld	hl,2	;const
	add	hl,sp
	ld	a,(hl)
	and	a
	jp	z,i_6	;
	ld	hl,0	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	bc,15944	;const
	push	bc
	call	l_f16_sub
	pop	bc
	push	hl
.i_6
	ld	hl,3	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_8	;
	pop	hl
	push	hl
	ld	a,h
	xor	128
	ld	h,a
	jp	i_9	;
.i_8
	pop	hl
	push	hl
.i_9
	inc	sp
	pop	bc
	pop	bc
	ret


	SECTION	bss_compiler
	SECTION	code_compiler
; --- Start of Optimiser additions ---


; --- Start of Static Variables ---

	SECTION	bss_compiler
	SECTION	code_compiler


; --- Start of Scope Defns ---

	GLOBAL	acos
	GLOBAL	asin
	GLOBAL	atan
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	cos
	GLOBAL	sin
	GLOBAL	tan
	GLOBAL	acosh
	GLOBAL	asinh
	GLOBAL	atanh
	GLOBAL	cosh
	GLOBAL	sinh
	GLOBAL	tanh
	GLOBAL	exp
	GLOBAL	exp2
	GLOBAL	expm1
	GLOBAL	frexp
	GLOBAL	frexp_callee
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	scalbn
	GLOBAL	scalbn_callee
	GLOBAL	scalbln
	GLOBAL	scalbln_callee
	GLOBAL	ilogb
	GLOBAL	log
	GLOBAL	log10
	GLOBAL	log1p
	GLOBAL	log2
	GLOBAL	logb
	GLOBAL	fabs
	GLOBAL	hypot
	GLOBAL	hypot_callee
	GLOBAL	pow
	GLOBAL	pow_callee
	GLOBAL	sqrt
	GLOBAL	cbrt
	GLOBAL	erf
	GLOBAL	erfc
	GLOBAL	lgamma
	GLOBAL	tgamma
	GLOBAL	ceil
	GLOBAL	floor
	GLOBAL	nearbyint
	GLOBAL	rint
	GLOBAL	lrint
	GLOBAL	round
	GLOBAL	lround
	GLOBAL	trunc
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	remainder
	GLOBAL	remainder_callee
	GLOBAL	remquo
	GLOBAL	remquo_callee
	GLOBAL	copysign
	GLOBAL	copysign_callee
	GLOBAL	nan
	GLOBAL	nextafter
	GLOBAL	nextafter_callee
	GLOBAL	nexttoward
	GLOBAL	nexttoward_callee
	GLOBAL	fdim
	GLOBAL	fdim_callee
	GLOBAL	fmax
	GLOBAL	fmax_callee
	GLOBAL	fmin
	GLOBAL	fmin_callee
	GLOBAL	fma
	GLOBAL	fma_callee
	GLOBAL	isgreater
	GLOBAL	isgreater_callee
	GLOBAL	isgreaterequal
	GLOBAL	isgreaterequal_callee
	GLOBAL	isless
	GLOBAL	isless_callee
	GLOBAL	islessequal
	GLOBAL	islessequal_callee
	GLOBAL	islessgreater
	GLOBAL	islessgreater_callee
	GLOBAL	isunordered
	GLOBAL	isunordered_callee
	GLOBAL	f16_f48
	GLOBAL	f48_f16
	GLOBAL	f16_f32
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
	GLOBAL	addf16_callee
	GLOBAL	subf16
	GLOBAL	subf16_callee
	GLOBAL	mulf16
	GLOBAL	mulf16_callee
	GLOBAL	divf16
	GLOBAL	divf16_callee
	GLOBAL	fmaf16
	GLOBAL	fmaf16_callee
	GLOBAL	polyf16
	GLOBAL	polyf16_callee
	GLOBAL	hypotf16
	GLOBAL	hypotf16_callee
	GLOBAL	invf16
	GLOBAL	invsqrtf16
	GLOBAL	sqrtf16
	GLOBAL	div2f16
	GLOBAL	mul2f16
	GLOBAL	mul10f16
	GLOBAL	frexpf16
	GLOBAL	frexpf16_callee
	GLOBAL	ldexpf16
	GLOBAL	ldexpf16_callee
	GLOBAL	acosf16
	GLOBAL	asinf16
	GLOBAL	atanf16
	GLOBAL	atan2f16
	GLOBAL	atan2f16_callee
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
	GLOBAL	powf16_callee
	GLOBAL	fabsf16
	GLOBAL	negf16
	GLOBAL	ceilf16
	GLOBAL	floorf16
	GLOBAL	isgreaterf16
	GLOBAL	isgreaterf16_callee
	GLOBAL	isgreaterequalf16
	GLOBAL	isgreaterequalf16_callee
	GLOBAL	islessf16
	GLOBAL	islessf16_callee
	GLOBAL	islessequalf16
	GLOBAL	islessequalf16_callee
	GLOBAL	islessgreaterf16
	GLOBAL	islessgreaterf16_callee
	GLOBAL	isnotequalf16
	GLOBAL	isnotequalf16_callee
	GLOBAL	isunorderedf16
	GLOBAL	isunorderedf16_callee
	GLOBAL	_f16_coeff_atan


; --- End of Scope Defns ---


; --- End of Compilation ---
