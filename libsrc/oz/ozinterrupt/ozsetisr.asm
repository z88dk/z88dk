;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	interrupt routines
;
;
; ------
; $Id: ozsetisr.asm,v 1.5 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozsetisr
	PUBLIC	_ozsetisr
	EXTERN	ozinstisr
	
ozsetisr:
_ozsetisr:
;; load in interrupt handler stub
        ld     hl,ISRStub_begin
        ld     de,ISRStub_loc
        ld     bc,ISRStub_len
        ldir

        ld   hl,2
        add  hl,sp
        ld   de,r_ozisrpointer
        ldi
        ldi

        ld   bc,ISRStub_loc
        push bc
        call ozinstisr
        pop  bc
        ret

ISRStub_begin:
        push    af
        push    bc
        push    de
        ld      c,1
        in      e,(c)
        inc     c
        in      d,(c)
        push    de
        inc     c
        in      e,(c)
        inc     c
        in      d,(c)
        push    de
        ld      a,6-4
        out     (1),a
        ld      a,4
        out     (2),a
        ld      a,7
        out     (3),a
        ld      a,4
        out     (4),a
;ozisrpointer equ $+1
ozisrpointer:
        call    38h
        pop     de
        ld      c,3
        out     (c),e
        inc     c
        out     (c),d
        pop     de
        ld      c,1
        out     (c),e
        inc     c
        out     (c),d
        pop     de
        pop     bc
        pop     af
        ei
        reti
ISRStub_end:

;ISRStub_len equ ISRStub_end-ISRStub_begin
;ISRStub_loc equ 0fff4h - ISRStub_len
;r_ozisrpointer equ ISRStub_loc + (ozisrpointer-ISRStub_begin)

defc	ISRStub_len = # ISRStub_end-ISRStub_begin
defc	ISRStub_loc = # 0fff4h - ISRStub_len
defc	r_ozisrpointer = # ISRStub_loc + (ozisrpointer+1-ISRStub_begin)
