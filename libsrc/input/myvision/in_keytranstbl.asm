
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'. 

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl


;Unshifted
	defb	'1', '5', '9',  10,  23, 255, 255, 255		; '1', '5' '9', CURDOWN, '13'
	defb	'4', '8',  22, 255,  11, 255, 255, 255		; '4', '8', '12', -, CURUP
	defb	'2', '6',  20,   9,  24, 255, 255, 255		; '2', '6', '10', CURRIGHT, '14/Start'
	defb	'3', '7',  21, 'E',   8, 255, 255, 255		; '3', '7', '11', 'E', 'A/Left'


