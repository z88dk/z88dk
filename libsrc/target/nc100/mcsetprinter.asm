		
                SECTION code_clib
		PUBLIC	mcsetprinter
		PUBLIC	_mcsetprinter
; Fastcall
._mcsetprinter
.mcsetprinter	ld a, l
		jp 0xb857
