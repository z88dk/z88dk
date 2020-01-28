;
;	Otrona Attachè specific routines
;
;	int psg_init();
;
;	Set up the PSG
;
;
;	$Id: psg_init.asm $
;

        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init


psg_init:
_psg_init:
	
	di
	
	; set bit io mode
	ld bc,0x00F9
	ld hl,0x00CF
	out(c),l
	
	; all 8 bits output
	ld hl,0x0000
	out(c),l

	ld bc,0x00FA
	ld hl,0x00FF ; no devices selected
	out (c),l

	ei

	ld	e,@01010101
	xor a 	; R0: Channel A frequency low bits
	call outpsg

	ld	e,a

	ld d,12
psg_iniloop:
	inc a	; R1-13: set all to 0 but 7 and 11
	cp 7
	jr z,skip
	;cp 11
	;jr z,skip
	call outpsg
skip:
	dec d
	jr	nz,psg_iniloop

	ld	e,@11111000	; R7: Channel setting.  Enable sound channels ABC and input on ports A and B
	ld	a,7
	call outpsg

	ld	e,@00001011	; R11: Envelope
	ld	a,11

outpsg:
    	di
	ld bc,0x00F8 ; Put register number on DPIOA
        out (c),a

        ld hl,0x00c3 ; magic select
        ld bc,0x00FA ; strobe select on dpiob - enable
        out (c),l
        ld hl,0x00E3 ; disable latch to dpiob
        out (c),l

        ld bc,0x00F8
        out (c),e    ; Put register on DPIOA

        ld bc,0x00FA ; Strobe latches again on DPIOB
        ld hl,0x00E7
        out(c),l
        ld hl,0x00C7
        out(c),l
        ld hl,0x00E7
        out(c),l
	
	ei
	ret

