
;	.title	"CGB support"
;	.module	CGB

	MODULE	scroll_sprite

	PUBLIC	scroll_sprite
	PUBLIC	_scroll_sprite

	GLOBAL	set_xy_wtt

	SECTION	code_driver

	INCLUDE	"target/gb/def/gb_globals.def"

;void __LIB__ scroll_sprite(INT8 nb, INT8 x, INT8 y) __smallc  NONBANKED;
scroll_sprite:
_scroll_sprite:
        PUSH    BC
        LD      HL,sp+8         ; Skip return address and registers
        LD      C,(HL)          ; C = nb
	ld	hl,sp+6
        LD      D,(HL)          ; D = x
	ld	hl,sp+4
        LD      E,(HL)          ; E = y

        CALL    doscroll

        POP     BC
        RET

        ;; Move sprite number C at XY = DE
doscroll:
        LD      HL,OAM        ; Calculate origin of sprite info
        SLA     C               ; Multiply C by 4
        SLA     C
        LD      B,0x00
        ADD     HL,BC

        LD      A,(HL)
        ADD     E               ; Set Y
        LD      (HL+),A

        LD      A,(HL)
        ADD     D               ; Set X
        LD      (HL+),A
        RET
