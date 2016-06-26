;
;	ZX81 Stdio
;
;	ASCII-ZX81 conversion Table
;	used by fgetc_cons and fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: cnvtab.asm,v 1.10 2016-06-26 20:32:08 dom Exp $
;

	SECTION rodata_clib
	PUBLIC	zx81_cnvtab


.zx81_cnvtab
IF FORzx81
	defb	114	; cursor-left
	defb	8
	defb	115	; cursor-right
	defb	9
	defb	112	; cursor-up
	defb	11
	defb	113	; cursor-down
	defb	10
	defb	119	; Rubout
	defb	12
	defb	118	; Newline
	defb	13
	defb    116     ; Graphics
	defb    6
	defb	11
	defb	'"'
	defb	9
	defb	'_'
	defb	12
	defb	'£'
	defb	13
	defb	'$'
	defb	14
	defb	':'
	defb	155		; Reverse dot
	defb	'!'
	defb	15
	defb	'?'
	defb	16
	defb	'('
	defb	17
	defb	')'
	defb	18
	defb	'>'
	defb	19
	defb	'<'
	defb	20
	defb	'='
	defb	21
	defb	'+'
	defb	22
	defb	'-'
	defb	23
	defb	'*'
	defb	24
	defb	'/'
	defb	25
	defb	';'
	defb	26
	defb	','
	defb	27
	defb	'.'
	defb	1
	defb	39 ;"'"
	defb	152 ; inverse "/"
	defb	'%'
	defb	149 ; inverse "+"
	defb	'&'
	defb	5
	defb	'['
	defb	133
	defb	']'
	defb	128
	defb	'@'
	defb	8
	defb	'#'
	defb	2
	defb	96	; reversed "'"
	defb	151	; inverse "*"
	defb	'^'
	defb	147
	defb	'{'
	defb	146
	defb	'}'
	defw	0
ENDIF

IF FORlambda
	defb	114	; cursor-left
	defb	8
	defb	115	; cursor-right
	defb	9
	defb	112	; cursor-up
	defb	11
	defb	113	; cursor-down
	defb	10
	defb	119	; Rubout
	defb	12
	defb	118	; Newline
	defb	13
	defb    116     ; Graphics
	defb    6
	defb	11
	defb	'"'
	defb	131
	defb	'_'
	defb	12		; spider
	defb	'£'
	defb	13
	defb	'$'
	defb	6		; "battemberg"
	defb	':'
	defb	142		; Reverse butterfly
	defb	'!'
	defb	132
	defb	'?'
	defb	16
	defb	'('
	defb	17
	defb	')'
	defb	18
	defb	'>'
	defb	19
	defb	'<'
	defb	20
	defb	'='
	defb	21
	defb	'+'
	defb	22
	defb	'-'
	defb	23
	defb	'*'
	defb	24
	defb	'/'
	defb	25
	defb	';'
	defb	26
	defb	','
	defb	27
	defb	'.'
	defb	1
	defb	39 ;"'"
	defb	152 ; inverse "/"
	defb	'%'
	defb	14	; butterfly
	defb	'&'
	defb	5
	defb	'['
	defb	133
	defb	']'
	defb	15	; "ghost"
	defb	'@'
	defb	136	; reversed "car"
	defb	'#'
	defb	2
	defb	96	; reversed "'"
	defb	10	; top-right triangle
	defb	'^'
	defb	147
	defb	'{'
	defb	146
	defb	'}'
	defw	0
ENDIF

IF FORzx80
	defb	114	; cursor-left
	defb	8
	defb	115	; cursor-right
	defb	9
	defb	112	; cursor-up
	defb	11
	defb	113	; cursor-down
	defb	10
	defb	119	; Rubout
	defb	12
	defb	118	; Newline
	defb	13
	defb    116     ; Graphics
	defb    6
	defb	11
	defb	'"'
	defb	10
	defb	'_'
	defb	12
	defb	'£'
	defb	13
	defb	'$'
	defb	14
	defb	':'
	defb	15
	defb	'?'
	defb	16
	defb	'('
	defb	17
	defb	')'
	defb	18
	defb	'-'
	defb	19
	defb	'+'
	defb	20
	defb	'*'
	defb	21
	defb	'/'
	defb	22
	defb	'='
	defb	23
	defb	'>'
	defb	24
	defb	'<'
	defb	25
	defb	';'
	defb	26
	defb	','
	defb	27
	defb	'.'
	defb	4
	defb	39 ;"'"
	defb	149 ; inverse "/"
	defb	'%'
	defb	147 ; inverse "+"
	defb	'&'
	defb	2
	defb	'['
	defb	130
	defb	']'
	defb	128
	defb	'@'
	defb	9
	defb	'#'
	defb	5
	defb	96	; reversed "'"
	defb	148	; inverse "*"
	defb	'^'
	defb	152
	defb	'{'
	defb	153
	defb	'}'
	defw	0
ENDIF
