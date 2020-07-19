

	SECTION		code_fp_dai32

	PUBLIC		___dai32_setup_single
	EXTERN		___dai32_fpac


; Used for the routines which accept single argument
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw float LSW
;        defw float MSW
___dai32_setup_single:
    ld      hl,4
    add     hl,sp
    ld      d,(hl)
    inc     hl
    ld      e,(hl)
    inc     hl
    ex      de,hl
    ld      (___dai32_fpac+2),hl
    ex      de,hl
    ld      d,(hl)
    inc     hl
    ld      e,(hl)
    ex      de,hl
    ld      (___dai32_fpac+0),hl
	ret
