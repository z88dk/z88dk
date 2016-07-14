; ----------------------------------------------------------------------------------------
;       Modified display handler to preserve IY
;	Note: a swap between IX and IY happens "on the fly" during assembly !
; ----------------------------------------------------------------------------------------
;
;       $Id: zx81_altint_core.def,v 1.8 2016-07-14 13:30:10 pauloscustodio Exp $
;
; - - - - - - -

PUBLIC	MTCH_P1
PUBLIC	MTCH_P2
PUBLIC	MTCH_P3
PUBLIC	L0292
PUBLIC	G007_P1
PUBLIC	G007_P2
PUBLIC	G007_P3

;--------------------------------------------------------------
;--------------------------------------------------------------


;; DISPLAY-1
L0229:
        LD      HL,($4034)      ; fetch two-byte system variable FRAMES.
        DEC     HL              ; decrement frames counter.

;; DISPLAY-P
L022D:  LD      A,$7F           ;
        AND     H               ;
        OR      L               ;
        LD      A,H             ;
        JR      NZ,L0237        ; to ANOTHER

        RLA                     ;
        JR      L0239           ; to OVER-NC

; ---

;; ANOTHER
L0237:  LD      B,(HL)          ;
        SCF                     ; Set Carry Flag

;; OVER-NC
L0239:  LD      H,A             ;
        LD      ($4034),HL      ; sv FRAMES_lo
        RET     NC              ;

;; DISPLAY-2
L023E:
	; push	ix          ; Siggi - No point to preserve iy here !! 
	; ld	ix,16384
	CALL    $2BB           ; routine KEYBOARD
	; pop	ix
        LD      BC,($4025)      ; sv LAST_K
        LD      ($4025),HL      ; sv LAST_K
        LD      A,B             ;
        ADD     A,$02           ;
        SBC     HL,BC           ;
        LD      A,($4027)       ; sv DEBOUNCE
        OR      H               ;
        OR      L               ;
        LD      E,B             ;
        LD      B,$0B           ;
        LD      HL,$403B        ; system variable CDFLAG
        RES     0,(HL)          ;
        JR      NZ,L0264        ; to NO-KEY

        BIT     7,(HL)          ;
        SET     0,(HL)          ;
        RET     Z               ;

        DEC     B               ;
        NOP                     ;
        SCF                     ; Set Carry Flag

;; NO-KEY
L0264:  LD      HL,$4027        ; sv DEBOUNCE
        CCF                     ; Complement Carry Flag
        RL      B               ;

;; LOOP-B
L026A:  DJNZ    L026A           ; to LOOP-B

        LD      B,(HL)          ;
        LD      A,E             ;
        CP      $FE             ;
        SBC     A,A             ;
        LD      B,$1F           ;
        OR      (HL)            ;
        AND     B               ;
        RRA                     ;
        LD      (HL),A          ;
        OUT     ($FF),A         ;
MTCH_P1:
        LD      HL,($400C)      ; sv D_FILE_lo
        SET     7,H             ;

G007_P1:
        CALL    L0292           ; routine DISPLAY-3

; ---

;; R-IX-1
L0281:  LD      A,R             ;
MTCH_P2:
G007_P2:
        LD      BC,$1901        ;
        LD      A,$F5           ;
        CALL    $2B5           ; routine DISPLAY-5
        DEC     HL              ;
G007_P3:
        CALL    L0292           ; routine DISPLAY-3

; ---

;; R-IX-2
L028F:  JP      L0229           ; to DISPLAY-1

; ---

;; DISPLAY-3
L0292:  POP     IY              ; return address to IX register (--IXIY swap).
                                ; will be either L0281 or L028F - see above.
; Modified here to keep IY unchanged

        ld	a,($4028)      ; load C with MARGIN
MTCH_P3:
		add     0             ; more blank lines for fast application code and correct sync
        ld	c,a

        ld   a,($403B)      ; test CDFLAG
        and  128            ; is in FAST mode ?
        jp   z,$2a9         ; if so, jp to DISPLAY-4

        ; jp $29e       ;  this could save 6 bytes, but I'm not sure the display timing won't be correct.. 
                        ;  better to reach the 'out' instruction first
        ld   a,c
        neg
        inc  a
        ex   af,af
        out  ($FE),a

        jp	$2A4

