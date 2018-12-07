		
                SECTION code_clib
		PUBLIC	kmsettickcount
		PUBLIC	_kmsettickcount

.kmsettickcount
._kmsettickcount
		pop bc
		pop de
		pop hl
		push hl
		push de
		push bc
		jp 0xB80C




