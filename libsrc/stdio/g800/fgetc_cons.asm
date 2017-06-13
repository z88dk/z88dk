;
;	Sharp PC G-800 family stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2017
;
;
;	$Id: fgetc_cons.asm - stefano Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	
	PUBLIC	key_to_asc

	defc	DELAY1=48
	defc	DELAY2=12

.fgetc_cons
._fgetc_cons

;	; PC-G850
;;	call $bcc4

; Generic key scanning

	call getkey_redo
	
key_to_asc:
	ld HL, key_to_asc_table
	bit 7, A
	jr Z, key_to_asc_skip
	ld HL, key_to_asc_table_shift
	and 0x7f
key_to_asc_skip:
	ld B,0
	ld C,A
	add HL, BC
	ld A,(HL)
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret




getkey_redo:
	ld A, (getkey_lastkey)
	ld D, A

	ld HL, getkey_delay
	ld E, (HL)

getkey_loop:
	call 0xbe53
	jr NC, getkey_new

	cp D
	jr NZ, getkey_new

	dec E
	jr NZ, getkey_loop

	ld (HL), DELAY2

getkey_last:
	ld (getkey_lastkey), A

	cp 0x49	;KEY_2NDF
	jr Z, getkey_2ndf

	ld HL, getkey_shift
	or (HL)
	ld (HL), 0
	;call put_2ndf		; show shift status on display

	ret


getkey_new:
	ld (HL), DELAY1

	call 0xbcfd
	jr getkey_last

getkey_2ndf:
	ld HL, getkey_shift
	ld A, (HL)
	xor 0x80
	ld (HL), A

	;call put_2ndf		; show shift status on display
	jr getkey_redo

;put_2ndf:
;	push AF
;
;	ld DE, 0x0290
;	call setxy
;	ld A, (HL)
;	rrca
;	rrca
;	out (0x41), A
;
;	pop AF
;	ret


;setxy:
;	in A, (0x40)
;	rlca
;	jr C, setxy
;
;	; Y
;	ld A, D
;	or 0xb0
;	out (0x40), A
;
;setx:
;	push AF
;
;	ld A, E
;	and 0x0f
;	out (0x40), A
;
;	ld A, E
;	rlca
;	rlca
;	rlca
;	rlca
;	and 0x0f
;	or 0x10
;	out (0x40), A
;	
;	pop AF
;	ret

key_to_asc_table:
	DEFB 0, 0, "Q", "W", "E", "R", "T", "Y"
	DEFB "U", "A", "S", "D", "F", "G", "H", "J"
	DEFB "K", "Z", "X", "C", "V", "B", "N", "M"
	DEFB ",", 0, 0, 0, 0, 0, " ", 0x0f
	DEFB 0x0e, 0x0c, 0x0d, 0, "0", ".", "=", "+"
	DEFB 0x0d, "L", ";", 0, "1", "2", "3", "-"
	DEFB 0, "I", "O", 0, "4", "5", "6", "*"
	DEFB 0, "P", 0x08, 0, "7", "8", "9", "/"
	DEFB "(", 0, 0, 0, 0, 0, "^", ")", 0
	DEFB 0, 0, 0, 0, 0, 0, 0, 0
	DEFB 0, 0, 0
key_to_asc_table_shift:
	DEFB 0, 0, "!", "\"", "#", "$", "%", "&"
	DEFB "'", "[", "]", "{", "}", "\\", "|", "~"
	DEFB "_", "Z", "X", "C", "V", "B", "N", "M"
	DEFB "?", 0, 0, 0, 0, 0, " ", 0x0f
	DEFB 0x0e, 0x0c, 0x0d, 0, "0", ".", "=", "+"
	DEFB 0x0d, "=", ":", 0, "1", "2", "3", "-"
	DEFB 0, "<", ">", 0, "4", "5", "6", "*"
	DEFB 0, "@", 0x08, 0, "7", "8", "9", "/"
	DEFB "(", 0, 0, 0, 0, 0, "^", ")", 0
	DEFB 0, 0, 0, 0, 0, 0, 0, 0
	DEFB 0, 0, 0


	SECTION	bss_clib

getkey_lastkey:
	DEFB 0

getkey_delay:
	DEFB 0

; 2ndf/shift
getkey_shift:
	DEFB 0
