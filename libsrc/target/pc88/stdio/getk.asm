;
;	NEC PC8801 Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2018
;
;
;	$Id: getk.asm $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk


;        INCLUDE "target/pc88/def/n88bios.def"


.getk
._getk
;	push	ix
;	call	CHSNS
;	pop	ix

        ld      hl,r1
        ld      c,$fe   ; lower part of keyboard port address is always $fe
        ld      d,12
krloop:
        call    readkrow
        jr      nc,kfound
        dec     d
        ld      a,d
        jr      z,kfound
        inc     hl
        jr      krloop

kfound:




IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret

	


readkrow:
		ld		b,0
        ld      c,(hl)  ; C holds $FE, so the full port addr is $xxFE
        in      a,(c)
        ld      e,8
e_lp:   inc     hl
        rra
        jr      c,no_za
        ld      a,(hl)          ; A holds the key code,
        ret                     ; carry flag is reset
no_za:  dec     e
        jr      nz,e_lp
        ret                     ; no keypress detected, 
                                ; carry flag is set

;--- --- --- ---

SECTION data_clib

; Key Table

r1:     defb    $00
        defb    '0'
        defb    '1'
        defb    '2'
        defb    '3'
        defb    '4'
        defb    '5'
        defb    '6'
        defb    '7'
r2:     defb    $01
        defb    '8'
        defb    '9'
        defb    '*'
        defb    '+'
        defb    '='
        defb    '.'
        defb    ','
        defb    13
r3:     defb    $02
        defb    '@'
        defb    'a'
        defb    'b'
        defb    'c'
        defb    'd'
        defb    'e'
        defb    'f'
        defb    'g'
r4:     defb    $03
        defb    'h'
        defb    'i'
        defb    'j'
        defb    'k'
        defb    'l'
        defb    'm'
        defb    'n'
        defb    'o'
r5:     defb    $04
        defb    'p'
        defb    'q'
        defb    'r'
        defb    's'
        defb    't'
        defb    'u'
        defb    'v'
        defb    'w'
r6:     defb    $05
        defb    'x'
        defb    'y'
        defb    'z'
        defb    '['
        defb    92	;'\'
        defb    ']'
        defb    '^'
        defb    '-'
r7:     defb    $06
        defb    '0'
        defb    '1'
        defb    '2'
        defb    '3'
        defb    '4'
        defb    '5'
        defb    '6'
        defb    '7'
r8:     defb    $07
        defb    '8'
        defb    '9'
        defb    ':'
        defb    ';'
        defb    ','
        defb    '.'
        defb    '/'
        defb    '_'
r9:     defb    $08
        defb    12	; CLR HOME
        defb    11	; cursor UP
        defb    09	; cursor RIGHT
        defb    0	; INS DEL
        defb    0	; GRPH
        defb    0	; KANA
        defb    0	; SHIFT
        defb    0	; CTRL
r10:    defb    $09
        defb    0	; STOP
        defb    0	; F1
        defb    0	; F2
        defb    0	; F3
        defb    0	; F4
        defb    0	; F5
        defb    ' '	; SPACE
        defb    27	; ESC
r11:    defb    $0A
        defb    8	; HTAB
        defb    10	; cursor DOWN
        defb    8	; cursor LEFT
        defb    0	; HELP
        defb    0	; COPY
        defb    '-'
        defb    '/'
        defb    0	; CAPS LOCK
;r12:    defb    $0B
;        defb    0	; ROLL UP
;        defb    0	; ROLL DOWN
;        defb    0
;        defb    0
;        defb    0
;        defb    0
;        defb    0
;        defb    0
r13:    defb    $0C
        defb    0	; F6
        defb    0	; F7
        defb    0	; F8
        defb    0	; F9
        defb    0	; F10
        defb    8	; BS
        defb    0	; INS
        defb    12	; DEL

;--- --- --- ---
