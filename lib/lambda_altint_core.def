; ----------------------------------------------------------------------------------------
;       LAMBDA 8300: Modified display handler to preserve IY
;	Note: a swap between IX and IY happens "on the fly" during assembly !
; ----------------------------------------------------------------------------------------
;
;       $Id: lambda_altint_core.def,v 1.2 2016-07-14 13:30:10 pauloscustodio Exp $
;
; - - - - - - -

;  MEMOTECH HRG won't work on the Lambda, it requires a specific D-FILE vector,
;  but the LAMBDA drivers points directly to the video memory.
; PUBLIC	MTCH_P1
; PUBLIC	MTCH_P2
; PUBLIC	MTCH_P3

PUBLIC	L0292
;  G007 HRG won't work on the Lambda
; PUBLIC	G007_P1
; PUBLIC	G007_P2
; PUBLIC	G007_P3

;--------------------------------------------------------------
;--------------------------------------------------------------

;; DISPLAY-1
L0229:
        LD      HL,($4034)      ; fetch two-byte system variable FRAMES.
        LD      A,H
        AND     $7F
        OR      L
        LD      A,H             ;
        JR      NZ,L0237        ; to ANOTHER ($12CD on the LAMBDA ROM, $0237 on the ZX81)

        RLA                     ;
        JR      L0239           ; to OVER-NC

; ---

;; ANOTHER
L0237:  SCF                     ; Set Carry Flag
        LD      C,0

;; OVER-NC
L0239:  LD      H,A             ;
        DEC     HL
        LD      ($4034),HL      ; sv FRAMES_lo
        RET     NC              ;
        LD      A,L
        LD      HL,(407Bh)		; BLINK
        SLA     (HL)
        RLA
        RLA
        RLA
        RLA
        RR      (HL)

;; DISPLAY-2
L023E:
        CALL    $D74           ; routine KEYBOARD
        LD      BC,($4025)      ; sv LAST_K
        LD      ($4025),HL      ; sv LAST_K
        LD      D,B
        ADD     A,$02           ;
        ADD     B
        SBC     HL,BC           ;
        LD      B,09h
        LD      A,($4027)       ; sv DEBOUNCE
        OR      H               ;
        OR      L               ;
        LD      HL,$403B        ; system variable CDFLAG
        RES     0,(HL)          ;
        JR      NZ,LNOKEY       ; to NO-KEY

        BIT     7,(HL)          ;
        SET     0,(HL)          ;
        RET     Z               ;

        DEC     B               ;
        DEC     B
        SCF                     ; Set Carry Flag

;; NO-KEY
LNOKEY:
        RL      B               ;

;; LOOP-B
L026A:  DJNZ    L026A           ; to LOOP-B
        LD      A,D
        CP      $FE             ;
        SBC     A,A             ;
        LD      HL,$4027        ; sv DEBOUNCE
        OR      (HL)            ;
        AND     $0F
        RRA                     ;
        LD      (HL),A          ;
        ADD     HL,HL
        ADD     HL,HL
        INC     HL
        OUT     ($FF),A         ;
; MTCH_P1:   <-- MEMOTECH HRG can't work, it uses a specific D-FILE vector.
        LD      HL,$C07D			; point to upper 32K 'display file' ghosted copy

; G007_P1:
        CALL    L0292           ; routine DISPLAY-3 (was $01ED on the LAMBDA ROM, $0292 on the ZX81)

; ---


;; R-IX-1  --  on the LAMBDA this is at position $1323
L0281:
; MTCH_P2:
; G007_P2:    ; the ROW couter patch for the G007 should be adjusted because..
        LD      BC,$0119        ; ..on the ZX81 C and B are inverted
        LD      A,(0)           ; on ZX81.. LD A,R
        LD      A,$F5           ;
        CALL    $1666           ; routine DISPLAY-5 ($02B5 on the ZX81)
        NOP
        NOP
        DEC     HL              ;
; G007_P3:
        CALL    L0292           ; routine DISPLAY-3  ($01ED in the LAMBDA ROM)

; ---


;; R-IX-2
L028F:  JP      L0229           ; to DISPLAY-1

; ---

;; DISPLAY-3
L0292:  POP     IY              ; return address to IX register (--IXIY swap).
                                ; will be either L0281 or L028F - see above.
; Modified here to keep IY unchanged

        ld	a,($4028)      ; load B with MARGIN
; MTCH_P3:
		add     0             ; more blank lines for fast application code and correct sync
        ld	b,a

        ld   a,($403B)      ; test CDFLAG
        and  128            ; is in FAST mode ?
        jp   z,$204         ; if so, jp to DISPLAY-4 ($02a9 on the ZX81)

        ; jp $29e       ;  this could save 6 bytes, but I'm not sure if the display timing will be correct.. 
                        ;  better to reach the 'out' instruction first
        ld   a,b
        dec  a
        neg
        ex   af,af
        out  ($FE),a

        jp	$1FF		; POP registers and RET

