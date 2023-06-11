;
;      Tape load routine
;
;      djm 16/10/2001
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;

PUBLIC tape_load_block_callee
PUBLIC _tape_load_block_callee
PUBLIC asm_tape_load_block

IF FORts2068
EXTERN call_extrom
ELSE
EXTERN call_rom3
ENDIF

.tape_load_block_callee
._tape_load_block_callee

	pop hl
	pop bc
	ld a,c
	pop de
	pop bc
	push hl

.asm_tape_load_block

; enter : ix = addr
;         de = len
;          a = type

	push ix
	push bc
	pop ix
	scf

	IF FORts2068
		ld		hl,$fc
        call    call_extrom
		pop ix
        ld      hl,-1
		ret	nc		;error
		inc	hl		;okay
		ret
	ELSE

		ld      hl,(23613)
		push    hl
		ld      hl,loadblock1
		push    hl
		ld      (23613),sp
        call    call_rom3
        defw    1366            ;call ROM3 load routine
;        pop     hl              ;successfull dump the random value
		ld	hl,0	; no error
		jr	nc,loadblock1

.loadblock2
        pop     de
        pop     de
        ld      (23613),de      ;get back original 23613
		pop     ix
        ret

.loadblock1
        ld      hl,-1           ;error
        jr      loadblock2

	ENDIF
