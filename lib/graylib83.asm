
; Graylib interrupt installer
; Ported by Stefano Bodrato - Mar 2000
;
; original code (portions of gray82.inc and greylib.asm) by:
;
;---------------= Gray82 =--------------
; Author:       Ian Graf
;               (ian_graf@geocities.com)
; Port:         Sam Heald
;		    (void.calc.org)
;---------------------------------------------------------------------------
;***** GreyLib version 1.0 (C) 1997 by Bill Nagel & Dines Justesen *********
;---------------------------------------------------------------------------
;

	XDEF	graybit1
	XDEF	graybit2

    LD HL,$8300
    LD DE,$8301
    LD BC,256
    LD (HL),$85
    LDIR

    LD HL,IntProcStart       ; Get pointer to interrupt rutine
    LD DE,$8585              ; Start of int ruotine, and length of it
    LD BC,IntProcEnd-IntProcStart+1
    LDIR

    XOR A                    ; Init vars
    LD (intcount),A

    LD A,$83	             ; Point to the new table
    LD I,A
    IM 2
    jp	jump_over


.IntProcStart

        push	af
        push	hl
        push	de
        push	bc
        
        in      a,(3)                   ; check vbl int
        and     @00000010               ;
        jr      z,exit_interrupt        ;
        ld      hl,intcount             ; inc counter
        inc     (hl)                    ;
        ld      a,(hl)                  ;
        dec     a                       ; 1
        jr      z,Display_pic1                 ;
        dec     a                       ; 2
        jr      z,Display_pic2                 ;                     ;
        ld      (hl),0                  ; reset counter
.exit_interrupt
        in      a,(3)                   ; check on interrupt status
        rra                             ;
        ld      a,0                     ;
        adc     a,9                     ;
        out     (3),a
        ld      a,$0B
        out     (3),a
        
	pop	bc
        pop	de
        pop	hl
        pop	af
        ei                              ; skip standard interrupt
        reti                            ;

.Display_pic1
    LD HL,(graybit1)
    JR DisplayPicture
.Display_pic2
    LD HL,(graybit2)
    JR DisplayPicture
.DisplayPicture
    LD A,      7
    CALL LCDBusy
    OUT ($10),A     ;send 00000111 to LCD : select row number
    LD A,$80        ; Goto the left
.LineLoop
    LD D,A          ; Save currect coloum
    CALL LCDBusy
    OUT ($10),A
    LD A,$20        ; Goto top
    CALL LCDBusy
    OUT ($10),A
    LD BC,$0C11     ; 40 bytes to port 10
.WriteLoop          ; Write them
    NEG
    NEG
    NEG
    NEG
    OUTI
    JR NZ,WriteLoop
    LD A,D
    INC A
    CP $C0
    JR NZ,LineLoop
    JR exit_interrupt
.LCDBusy
    PUSH    AF                      ;This is the TI made procedure
    INC     HL                      ;it makes a small pause before
    DEC     HL                      ;writing to the LCD
    POP     AF
    RET
.IntProcEnd

.graybit1 defw $8E29	;GRAPH_MEM
;.graybit2 defw $8265	;saferam1(apdram)
.graybit2 defw gbuf2
.gbuf2
DEFS	769

defc intcount = $8583
;.intcount	defb	0

.jump_over
