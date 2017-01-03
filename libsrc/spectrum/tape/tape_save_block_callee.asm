;
;      Tape save routine
;
;      djm 16/10/2001
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)

PUBLIC tape_save_block_callee
PUBLIC _tape_save_block_callee
PUBLIC ASMDISP_TAPE_SAVE_BLOCK_CALLEE

IF FORts2068
EXTERN call_extrom
ELSE
EXTERN call_rom3
ENDIF

.tape_save_block_callee
._tape_save_block_callee

	pop hl
	pop bc
	ld a,c
	pop de
	pop ix
	push hl

; enter : ix = addr
;         de = len
;          a = type

.asmentry

	IF FORts2068
		ld		hl,$68
        call    call_extrom
        ld		hl,0
        ret
	ELSE
        ld      hl,(23613)
        push    hl
        ld      hl,saveblock1
        push    hl
        ld      (23613),sp
        call    call_rom3
        defw	1218            ;call ROM3 routine
        ;pop     hl              ;successfull dump the random value
        ld      hl,0
        
.saveblock2
        pop     de
        pop     de
        ld      (23613),de      ;get back original 23613
        ret

.saveblock1
        ld      hl,-1           ;error
        jr      saveblock2
	ENDIF

DEFC ASMDISP_TAPE_SAVE_BLOCK_CALLEE = # asmentry - tape_save_block_callee
