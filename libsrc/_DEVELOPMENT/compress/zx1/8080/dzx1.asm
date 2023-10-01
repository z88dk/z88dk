; -----------------------------------------------------------------------------
; ZX1 8080 decoder by Ivan Gorodetsky
; Based on ZX1 z80 decoder by Einar Saukas
; Compile with The Telemark Assembler (TASM) 3.2
; v1 (2021-02-16) - 131 bytes forward / 135 bytes backward
; v2 (2021-02-17) - 129 bytes forward / 133 bytes backward
; v3 (2021-02-22) - 124 bytes forward / 128 bytes backward
; v4 (2021-02-25) - 124 bytes forward / 128 bytes backward (faster version)
; v5 (2021-02-25) - 128 bytes forward / 132 bytes backward (+4 bytes, bug fix)
; -----------------------------------------------------------------------------
; Parameters (forward):
;   DE: source address (compressed data)
;   BC: destination address (decompressing)
;
; Parameters (backward):
;   DE: last source address (compressed data)
;   BC: last destination address (decompressing)
; -----------------------------------------------------------------------------

;#define BACKWARD



; We enter here with hl=source, de=dest
dzx1_standard:
                ld bc,de
                ex de,hl
IF BACKWARD
		lxi h,1
ELSE
		lxi h,0FFFFh
ENDIF
		shld Offset
		mvi a,080h
dzx1s_literals:
		call dzx1s_elias
		push psw
		dcx h
		inr l
dzx1s_ldir1:
		ldax d
		stax b
IF BACKWARD
        dcx d
        dcx b
ELSE
        inx d
        inx b
ENDIF
		dcr l
		jnz dzx1s_ldir1
		xra a
		ora h
		jz $+7
		dcr h
		jmp dzx1s_ldir1
		pop psw
		add a
		jc dzx1s_new_offset
		call dzx1s_elias
dzx1s_copy:
		push d
		xchg
		lhld Offset
		dad b
		push psw
		dcx d
		inr e
dzx1s_ldir2:
		mov a,m
		stax b
IF BACKWARD
        dcx h
        dcx b
ELSE
        inx h
        inx b
ENDIF
		dcr e
		jnz dzx1s_ldir2
		xra a
		ora d
		jz $+7
		dcr d
		jmp dzx1s_ldir2
		pop psw
		xchg
		pop d
		add a
		jnc dzx1s_literals
dzx1s_new_offset:
IF BACKWARD
		ora a
ELSE
		dcr h
ENDIF
		push psw
		ldax d
IF BACKWARD
        dcx d
ELSE
        inx d
ENDIF
		rar
        mov l,a
		jnc dzx1s_msb_skip
		ldax d
IF BACKWARD
        dcx d
ELSE
        inx d
ENDIF
IF BACKWARD
		ora a
		rar
        rar
        adc a
ELSE
		rar
        inr a
ENDIF
		jz dzx1s_exit
		mov h,a
IF BACKWARD
		dcr h
ENDIF
		mov a,l
        ral 
        mov l,a
dzx1s_msb_skip:
		pop psw
IF BACKWARD
		inr l
ENDIF
		shld Offset
		call dzx1s_elias
		inx h
		jmp dzx1s_copy
dzx1s_elias:
		lxi h,1
dzx1s_elias_loop:	
		add a
		rnc
		jnz dzx1s_elias_skip
		ldax d
IF BACKWARD
        dcx d
ELSE
        inx d
ENDIF
		ral
		rnc
dzx1s_elias_skip:
		dad h
		add a
		jnc dzx1s_elias_loop
		inr l
		jmp dzx1s_elias_loop
dzx1s_exit:
		pop psw
		ret

Offset:
		defw 0
		
		
