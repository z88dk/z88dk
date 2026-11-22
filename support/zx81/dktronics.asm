;
;	ZX81 Stdio hack to build a program supporting lowercase text
;	with the Dk'Tronics 4K graphics ROM
;
;	Modified ASCII-ZX81 conversion Table (known as cnvtab.asm)
;	used by fgetc_cons and fputc_cons
;
;	This file is intended to be copied locally in the current project folder
;	and manually specified together with the C source program, e.g.
;
;	zcc +zx81 -create-app -O3 -pragma-define:ZX_CHAR_XLATE_MODE=3 dktronics.asm adv_a.c
;
;	ZX_CHAR_XLATE_MODE=3 would alter the lowercase mapping rules, as a side effect
;	the text being typed will be received as uppercase only.   
;	This file will provide some fine-tuning with the symbols.
;	Consider that the Dk'Tronics lowercase font is very limited, the numbers were removed 
;	as well as many other symbols to leave room for the double character set (upper/lowercase).
;
;	Stefano Bodrato - Jun 2025
;
;

    SECTION rodata_clib
    PUBLIC  zx81_cnvtab


zx81_cnvtab:
    defb    114                         ; cursor-left
    defb    8
    defb    115                         ; cursor-right
    defb    9
    defb    112                         ; cursor-up
    defb    11
    defb    113                         ; cursor-down
    defb    10
    defb    119                         ; Rubout
    defb    12
    defb    118                         ; Newline
    IF  STANDARDESCAPECHARS
    defb    10
    ELSE
    defb    13
    ENDIF
    defb    116                         ; Graphics
    defb    6
;    defb    11
    defb    29                          ; Dk'Tronics "'" (USR 11914)
    defb    '"'
    ;defb    9
    defb    31+128                      ; Dk'Tronics "_" (USR 11914)
    defb    '_'
    defb    12
    defb    0xA3
    defb    13
    defb    '$'
;    defb    14
	defb    33                          ; Dk'Tronics "'" (USR 11914)
    defb    ':'
;    defb    155                         ; Reverse dot
	defb    28                          ; Dk'Tronics "'" (USR 11914)
    defb    '!'
;    defb    15
	defb    32                          ; Dk'Tronics "'" (USR 11914)
    defb    '?'
    defb    36
    defb    '('
    defb    37
    defb    ')'
    defb    37
;    defb    18
    defb    '>'
    defb    36
;    defb    19
    defb    '<'
    defb    20
    defb    '='
    defb    21
    defb    '+'
;    defb    22
	defb    35                          ; Dk'Tronics "'" (USR 11914)
    defb    '-'
    defb    23
    defb    '*'
;    defb    24
	defb    31                          ; Dk'Tronics "'" (USR 11914)
    defb    '/'
;    defb    25
	defb    34                          ; Dk'Tronics "'" (USR 11914)
    defb    ';'
;    defb    26
	defb    30                          ; Dk'Tronics "'" (USR 11914)
    defb    ','
    defb    27
    defb    '.'
    ;defb    1
	defb    29                          ; Dk'Tronics "'" (USR 11914)
    defb    39                          ;"'"
    defb    152                         ; inverse "/"
    defb    '%'
    defb    149                         ; inverse "+"
    defb    '&'
    defb    5
    defb    '['
    defb    133
    defb    ']'
    defb    128
    defb    '@'
    defb    8
    defb    '#'
    defb    2
    defb    96                          ; reversed "'"
    defb    151                         ; inverse "*"
    defb    '^'
    defb    147
    defb    '{'
    defb    146
    defb    '}'
    defw    0
