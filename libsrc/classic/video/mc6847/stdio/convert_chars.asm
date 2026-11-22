; Conversion from ASCII to the MC6847 64 char character set
;
;
;   0	1	2	3	4	5	6	7	8	9	A	B	C	D	E	F
;----------------------------------------------------------------
;0x	@	A	B	C	D	E	F	G	H	I	J	K	L	M	N	O
;1x	P	Q	R	S	T	U	V	W	X	Y	Z	[	\	]	↑	←
;2x		!	"	#	$	%	&	'	(	)	*	+	,	-	.	/
;3x	0	1	2	3	4	5	6	7	8	9	:	;	<	=	>	?


SECTION code_driver

PUBLIC mc6847_from_ascii
PUBLIC mc6847_to_ascii


mc6847_from_ascii:
    cp      64  ;Codes 32 - 63 are already in the right place
    ret     c
    sub     64  ;Upper case -> code 0 - 31, Lower case -> code 32 -> 63
    cp      32
    ret     c
    sub     32
    ret

mc6847_to_ascii:
    cp      32
    ret     nc
    add     64
    ret
