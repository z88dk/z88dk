

	SECTION		code_fp_dai32

	PUBLIC		___dai32_setup_two
	EXTERN		___dai32_fpac
	EXTERN		___dai32_tempval


; Used for the routines which accept two floats
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw right hand LSW
;        defw right hand MSW
;        defw left hand LSW
;        defw left hand MSW
___dai32_setup_two:
    ld      hl,4
    add     hl,sp
    ld      d,(hl)          ;right LSW
    inc     hl
    ld      e,(hl)
    inc     hl
    ex      de,hl
    ld      (___dai32_tempval+2),hl
    ex      de,hl
    ld      d,(hl)          ;right MSW
    inc     hl
    ld      e,(hl)
    inc     hl
    ex      de,hl
    ld      (___dai32_tempval+0),hl
    ex      de,hl
    ld      d,(hl)          ;left LSW
    inc     hl
    ld      e,(hl)
    inc     hl
    ex      de,hl
    ld      (___dai32_fpac+2),hl
    ex      de,hl
    ld      d,(hl)          ;left MSW
    inc     hl
    ld      e,(hl)
    inc     hl
    ex      de,hl
    ld      (___dai32_fpac+0),hl
    ld      hl,___dai32_tempval
    ret
