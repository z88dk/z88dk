
; Graylib interrupt installer
; Ported for the Z88DK and modified for the TI86 by Stefano Bodrato - May 2000
;
; original code (graydraw.asm) by:
;
;------------------------------------------------------------
; Date:     Sun, 5 May 1996 12:44:17 -0400 (EDT)
; From:     Jingyang Xu  [br00416@bingsuns.cc.binghamton.edu]
; Subject:  LZ: Graydraw source!
;------------------------------------------------------------
;
; $Id: graylib86.asm,v 1.1 2001-05-11 07:58:59 stefano Exp $
;


	XDEF	graybit1
	XDEF	graybit2

	;; ld hl,($d297)   ;get end of VAT
	ld	hl,$f500

        ;dec hl
        ;dec hl          ;make sure we're clear it..

           ; now we need to get the position of
           ; the nearest screen boundary

        ld a,h
        sub 5
        ld h,a
        ld l,0

           ;Save out the address of our 2nd Screen

        ld (graybit2),hl

           ; save out the byte to send to port 0
           ; to switch to our 2nd screen

        ld a,h
        and @00111111
        ld (page2),a
        
           ; Set the IV for IM2 mode

	dec h
	ld a,h
        ld i,a
        
           ; Set the IV table
        
        ld      (hl),Int_Rout&$FF
        inc     hl
        ld      (hl),Int_Rout/256
        ld	d,h
        ld	e,l
	dec	hl
        inc	de
        ld	bc,255
        ldir

           ; Init counter

        xor	a
        ld	(intcount),a

           ; Activate Interrupt

        im 2
        
        jp cont_jp

.Int_Rout
	push	af
        in a,(3)
        bit 1,a           ; check that it is a vbl interrupt
        jr z,EndInt

        ld a,(intcount)
        cp 2
        jr z,Disp_2

.Disp_1
        inc a
        ld (intcount),a
        ld a,(page2)
        out (0),a
        jr EndInt
.Disp_2
        ld a,$3c
        out (0),a
        xor a
        ld (intcount),a
.EndInt

	;in a,(3)			;this stuff must be done or calc crashes
	;rra				;mysterious stuff from the ROM
	;ld a,0
	;adc a,9
	;out (3),a
	;ld a,$0B
	;out (3),a

        pop	af
        ei
        reti
        ;jp      $38

.Int_RoutEnd

.graybit1 defw $fc00	;GRAPH_MEM
.graybit2 defw 0
.page2    defb 0
.intcount defb 0

.cont_jp

