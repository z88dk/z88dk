
                SECTION code_clib
		PUBLIC	txtwrchar
		PUBLIC	_txtwrchar

; fastcall so in HL!
.txtwrchar
._txtwrchar
		ld a, l
		jp 0xB83C
