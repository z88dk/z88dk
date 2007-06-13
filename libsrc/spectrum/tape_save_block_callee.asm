;
;      Tape save routine
;
;      djm 16/10/2001
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)

XLIB tape_save_block_callee
XDEF ASMDISP_TAPE_SAVE_BLOCK_CALLEE

.tape_save_block_callee

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

        ld      hl,(23613)
        push    hl
        ld      hl,saveblock1
        push    hl
        ld      (23613),sp
        call    1218            ;call ROM3 routine
        pop     hl              ;successfull dump the random value
        ld      hl,0
        
.saveblock2

        pop     de
        ld      (23613),de      ;get back original 23613
        ret
        
.saveblock1

        ld      hl,-1           ;error
        jr      saveblock2

DEFC ASMDISP_TAPE_SAVE_BLOCK_CALLEE = asmentry - tape_save_block_callee
