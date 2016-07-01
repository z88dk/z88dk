;
;       ZX IF1 & Microdrive functions
;
;       Stefano Bodrato - Oct. 2004
;
;
;       if1_rommap:
;        - detect the shadow rom version
;        - init the jump table
;
;       MAKE_M can't be called with the 'hook code' system because
;       the first issue of the interface one just doesn't have it.
;       
;       $Id: if1_rommap.asm,v 1.4 2016-07-01 22:08:20 dom Exp $
;

		SECTION   code_clib
                PUBLIC    if1_rommap

                PUBLIC    MAKE_M
                PUBLIC    CLOSE_M
                PUBLIC    FETCH_H
                PUBLIC    MOTOR
                PUBLIC    RD_BUFF
                PUBLIC    ERASEM
                PUBLIC    ADD_RECD
                PUBLIC    DEL_S_1

                PUBLIC    mdvbuffer

if1_rommap:     ; start creating an 'M' channel

                rst     8
                defb    31h             ; Create Interface 1 system vars if required

                ld      hl,paged
                ld      (5CEDh),hl      ; Location for hook 32h to jump to

                rst     8               ; Call 'paged' with shadow paged in
                defb    32h             ; (in other words: page in the shadow ROM)

paged:
                set     0,(iy+7Ch)      ; FLAGS3: reset the "executing extended command" flag

        ; update jump table
                ld      a,(10A5h)
                or      a
                jr      z,rom1
                ld      hl,rom2tab      ; JP table for ROM 2

                ld		a,(1d79h)		; basing on an old paper, it should be the
										; first byte of SCAN_M in issue 3 IF1
                cp		205
                jr		z,rom2
                
                ld		hl,rom3tab

rom2:
                ld      bc,24           ; 8 jumps * 3 bytes
                ;ld     bc,30           ; 10 jumps * 3 bytes
                ld      de,jptab        ; JP table dest addr
                ldir
                

rom1:
                
                pop     bc              ; throw away some garbage
                pop     bc              ; ... from the stack
                
                ret
                ;jp     MAKE_M


; Jump table (ROM1 is the default)

jptab:

MAKE_M:         JP 0FE8h        ; set temporary "M" channel
CLOSE_M:        JP 12A9h        ; close file (pointed by IX)
FETCH_H:        JP 12C4h        ; fetch header

IF OLDIF1MOTOR
  MOTOR:        JP 17F7h        ; select drive motor
ELSE
  MOTOR2:       JP 17F7h        ; select drive motor
ENDIF

RD_BUFF:        JP 18A9h        ; get buffer
ERASEM:         JP 1D6Eh        ; delete a file from cartridge
FREESECT:       JP 1D38h        ; add a record to file
DEL_S_1:        JP 1867h        ; 1ms delay

;LDBYTS:                JP 15ACh        ;
;SVBYTS:                JP 14EEh        ;


; Jump table image (rom2)
;

rom2tab:
                JP 10A5h
                JP 138Eh
                JP 13A9h
                JP 1532h ;MOTOR
                JP 15EBh ;RD_BUFF
                JP 1D79h ;ERASEM
                JP 1D43h ;FREESECT
                JP 15A2h ;DEL_S_1

                ;JP 199Dh ;LDBYTS
                ;JP 18DFh ;SVBYTS

; Jump table image (rom3)  ..based on the Pennel's book
;

rom3tab:
                JP 10A5h
                JP 138Eh
                JP 13A9h
                JP 1532h ;MOTOR
                JP 15EBh ;RD_BUFF
                JP 1D7Bh ;ERASEM
                JP 1D45h ;FREESECT	; - ?? we just suppose this one
                JP 15A2h ;DEL_S_1

                ;JP 199Dh ;LDBYTS ???
                ;JP 18DFh ;SVBYTS ???

IF !OLDIF1MOTOR

; New MOTOR routine.  
; This one traps the 'microdrive not present' error
; Mostly from the A. Pennel's Microdrive book

MOTOR:
        and	a               ; need to stop a motor ?
        jp      z,MOTOR2        ; use the original ROM routine
        
        push    hl
        di
        ;; jr      sw_motor

sw_motor:
        ;push    de
        ld      de,$0100        ; d=1, e=0
        neg                     ; negate the drive number
        add     9               ; a = 9 - drive number
        ld      c,a             ; drive selected
        ld      b,8             ; drive counter
        
all_motors:
        dec     c               ; decrement the drive selected
        jr      nz,off_motor    ; jump if not the one that is
                                ; under investigation
        ; put a motor ON
        ld      a,d
        ld      ($f7),a         ; send 1 (ON)
        ld      a,$ee
        out     ($ef),a
        call    DEL_S_1         ; wait 1 ms
        ld      a,$ec
        out     ($ef),a
        call    DEL_S_1         ; wait 1 ms
        jr      nxt_motor       ; do the next one
        
off_motor:
        ; switch a drive OFF
        ld      a,$ef
        out     ($ef),a
        ld      a,e
        out     ($f7),a         ; send 0: OFF
        call    DEL_S_1         ; wait 1 ms
        ld      a,$ed
        out     ($ef),a
        call    DEL_S_1         ; wait 1 ms
nxt_motor:
        djnz    all_motors

        ld      a,d
        out     ($f7),a         ; send 1
        ld      a,$ee
        out     ($ef),a
        ;; jr      turned_on
        
        ; now drive is on, check its status
turned_on:
        ld      hl,5000         ; delay counter
ton_delay:
        dec     hl
        ld      a,l
        or      h
        jr      nz,ton_delay
        
        ld      hl,5000         ; 'check' loop counter
reptest:
        ld      b,6             ; six times

        ; here the original ROM checks for BREAK,
        ; but we removed it as Pennel did
chk_pres:
        in      a,($ef)         ; 
        and     4               ; bit 2 only
        jr      nz,nopres       ; jp if drive not present
        djnz    chk_pres

        pop     hl              ; *CARTRIDGE PRESENT*, return..
        ret                     ;.. with zero flag set

nopres:
        dec     hl              ; decrement counter
        ld      a,h
        or      l
        jr      nz,reptest

        inc     a               ; *CARTRIDGE NOT PRESENT*, reset zero flag...
        pop     hl
        ret                     ; ...and return

ENDIF
		SECTION bss_clib
mdvbuffer:      defw    0
