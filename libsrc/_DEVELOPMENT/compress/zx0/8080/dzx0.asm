; -----------------------------------------------------------------------------
; ZX0 8080 decoder by Ivan Gorodetsky
; Based on ZX0 z80 decoder by Einar Saukas
; v1 (2021-02-15) - 103 bytes forward / 100 bytes backward
; v2 (2021-02-17) - 101 bytes forward / 100 bytes backward
; v3 (2021-02-22) - 99 bytes forward / 98 bytes backward
; v4 (2021-02-23) - 98 bytes forward / 97 bytes backward
; -----------------------------------------------------------------------------
; Parameters (forward):
;   HL: source address (compressed data)
;   BC: destination address (decompressing)
;
; Parameters (backward):
;   HL: last source address (compressed data)
;   BC: last destination address (decompressing)
; -----------------------------------------------------------------------------

;#define BACKWARD


dzx0_standard:
IF BACKWARD
        lxi d,1
		push d
		dcr e
ELSE
        lxi d,0FFFFh
		push d
		inx d
ENDIF
		mvi a,080h
dzx0s_literals:
		call dzx0s_elias
		call ldir
		add a
		jc dzx0s_new_offset
		call dzx0s_elias
dzx0s_copy:
		xthl
		push h
		dad b
		call ldir
		pop h
		xthl
		add a
		jnc dzx0s_literals
dzx0s_new_offset:
		call dzx0s_elias
IF BACKWARD
		inx sp
		inx sp
		dcr d
		rz
		dcr e
		mov d,e
ELSE
		mov d,a
		pop psw
		xra a
		sub e
		rz
		mov e,d
		mov d,a
		mov a,e
ENDIF
		push b
		mov b,a
		mov a,d
		rar
		mov d,a
		mov a,m
		rar 
		mov e,a
		mov a,b
		pop b
IF BACKWARD
		dcx h
ELSE
		inx h
ENDIF
IF BACKWARD
		inx d
ENDIF
		push d
		lxi d,1
IF BACKWARD
		cc dzx0s_elias_backtrack
ELSE
		cnc dzx0s_elias_backtrack
ENDIF
		inx d
		jmp dzx0s_copy
dzx0s_elias:
		inr e
dzx0s_elias_loop:	
		add a
		jnz dzx0s_elias_skip
		mov a,m
IF BACKWARD
		dcx h
ELSE
		inx h
ENDIF
		ral
dzx0s_elias_skip:
IF BACKWARD
		rnc
ELSE
		rc
ENDIF
dzx0s_elias_backtrack:
		xchg
		dad h
		xchg
		add a
		jnc dzx0s_elias_loop
		inr e
		jmp dzx0s_elias_loop
		
ldir:
		push psw						
ldir_loop:
		mov a,m
		stax b
IF BACKWARD
		dcx h
		dcx b
ELSE
		inx h
		inx b
ENDIF
		dcx d
		mov a,d
		ora e
		jnz ldir_loop
		pop psw
		ret

		.end
