
; Graylib interrupt installer
; Ported by Stefano Bodrato - Mar 2000
;
; original code (gray82.inc) by:
;
;---------------= Gray82 =--------------
; Author:       Ian Graf
;               (ian_graf@geocities.com)
; Port:         Sam Heald
;		    (void.calc.org)
; Version:      1.0
; Date:         4/22/00
;---------------------------------------
;
; $Id: graylib82.asm,v 1.4 2001-06-06 14:01:55 stefano Exp $
;

	XDEF	graybit1
	XDEF	graybit2

defc intcount = $8BDF	;TEXT_MEM2

        ld      hl,$8400                ; set up interrupt vector
        ld      de,$8401                ;
        ld      (hl),$82                ;
        ld      bc,$0100                ;
        ldir                            ;
        ld      hl,$8282                ;
        ld      (hl),$C3                ; jp greyscale
        inc     hl                      ;
        
        ld      (hl),grayint&$FF
        inc     hl
        ld      (hl),grayint/256
        
        xor     a                       ; reset counter
        ld      a,(intcount)            ;
        ld      a,$84                   ; point i to interrupt vector
        ld      i,a                     ;
        im      2                       ;
        jp	jump_over

.grayint
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
        jr      z,dpic2                 ;
        dec     a                       ; 2
        jr      z,dpic1                 ;                     ;
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


.dpic1
        ld      hl,(graybit2)
        jr      drawp
.dpic2
        ld      hl,(graybit1)

.drawp  ld      a,$80
        out     ($10),a
        ld      de,755
        add     hl,de
        ld      a,$20
        ld      c,a
.wloop1 ld      b,64
        inc     c
        ld      de,-767
        out     ($10),a
        add     hl,de
        ld      de,11
.wloop2 add     hl,de
        inc     hl
        ld      a,(hl)
        out     ($11),a
	  ;push ix
	  ;pop ix
        djnz    wloop2
        ld      a,c
        cp      $2B+1
        jr      nz,wloop1
        jr      exit_interrupt 

.graybit1	defw	$88b8	;GRAPH_MEM

;.graybit2	defw	$8228	;APD_BUF
.graybit2	defw	gbuf2
.gbuf2		DEFS	768

.jump_over
.cont_jp
