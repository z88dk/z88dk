;**********************************
;** Part 3. LOUDSPEAKER ROUTINES **
;**********************************

        PUBLIC L03B5
        PUBLIC L03F8

        EXTERN L1E94
        EXTERN L1E99
        EXTERN L33B4
        EXTERN L3406

; Documented by Alvin Albrecht.

; ------------------------------
; Routine to control loudspeaker
; ------------------------------
; Outputs a square wave of given duration and frequency
; to the loudspeaker.
;   Enter with: DE = #cycles - 1
;               HL = tone period as described next
;
; The tone period is measured in T states and consists of
; three parts: a coarse part (H register), a medium part
; (bits 7..2 of L) and a fine part (bits 1..0 of L) which
; contribute to the waveform timing as follows:
;
;                          coarse    medium       fine
; duration of low  = 118 + 1024*H + 16*(L>>2) + 4*(L&0x3)
; duration of hi   = 118 + 1024*H + 16*(L>>2) + 4*(L&0x3)
; Tp = tone period = 236 + 2048*H + 32*(L>>2) + 8*(L&0x3)
;                  = 236 + 2048*H + 8*L = 236 + 8*HL
;
; As an example, to output five seconds of middle C (261.624 Hz):
;   (a) Tone period = 1/261.624 = 3.822ms
;   (b) Tone period in T-States = 3.822ms*fCPU = 13378
;         where fCPU = clock frequency of the CPU = 3.5MHz
;    ©  Find H and L for desired tone period:
;         HL = (Tp - 236) / 8 = (13378 - 236) / 8 = 1643 = 0x066B
;   (d) Tone duration in cycles = 5s/3.822ms = 1308 cycles
;         DE = 1308 - 1 = 0x051B
;
; The resulting waveform has a duty ratio of exactly 50%.
;
;
;; BEEPER
L03B5:  DI                      ; Disable Interrupts so they don't disturb timing
        LD      A,L             ;
        SRL     L               ;
        SRL     L               ; L = medium part of tone period
        CPL                     ;
        AND     $03             ; A = 3 - fine part of tone period
        LD      C,A             ;
        LD      B,$00           ;
        LD      IX,L03D1        ; Address: BE-IX+3
        ADD     IX,BC           ;   IX holds address of entry into the loop
                                ;   the loop will contain 0-3 NOPs, implementing
                                ;   the fine part of the tone period.
        LD      A,($5C48)       ; BORDCR
        AND     $38             ; bits 5..3 contain border colour
        RRCA                    ; border colour bits moved to 2..0
        RRCA                    ;   to match border bits on port #FE
        RRCA                    ;
        OR       $08            ; bit 3 set (tape output bit on port #FE)
                                ;   for loud sound output
;; BE-IX+3
L03D1:  NOP              ;(4)   ; optionally executed NOPs for small
                                ;   adjustments to tone period
;; BE-IX+2
L03D2:  NOP              ;(4)   ;

;; BE-IX+1
L03D3:  NOP              ;(4)   ;

;; BE-IX+0
L03D4:  INC     B        ;(4)   ;
        INC     C        ;(4)   ;

;; BE-H&L-LP
L03D6:  DEC     C        ;(4)   ; timing loop for duration of
        JR      NZ,L03D6 ;(12/7);   high or low pulse of waveform

        LD      C,$3F    ;(7)   ;
        DEC     B        ;(4)   ;
        JP      NZ,L03D6 ;(10)  ; to BE-H&L-LP

        XOR     $10      ;(7)   ; toggle output beep bit
        OUT     ($FE),A  ;(11)  ; output pulse
        LD      B,H      ;(4)   ; B = coarse part of tone period
        LD      C,A      ;(4)   ; save port #FE output byte
        BIT     4,A      ;(8)   ; if new output bit is high, go
        JR      NZ,L03F2 ;(12/7);   to BE-AGAIN

        LD      A,D      ;(4)   ; one cycle of waveform has completed
        OR      E        ;(4)   ;   (low->low). if cycle countdown = 0
        JR      Z,L03F6  ;(12/7);   go to BE-END

        LD      A,C      ;(4)   ; restore output byte for port #FE
        LD      C,L      ;(4)   ; C = medium part of tone period
        DEC     DE       ;(6)   ; decrement cycle count
        JP      (IX)     ;(8)   ; do another cycle

;; BE-AGAIN                     ; halfway through cycle
L03F2:  LD      C,L      ;(4)   ; C = medium part of tone period
        INC     C        ;(4)   ; adds 16 cycles to make duration of high = duration of low
        JP      (IX)     ;(8)   ; do high pulse of tone

;; BE-END
L03F6:  EI                      ; Enable Interrupts
        RET                     ;


; ------------------
; THE 'BEEP' COMMAND
; ------------------
; BASIC interface to BEEPER subroutine.
; Invoked in BASIC with:
;   BEEP dur, pitch
;   where dur   = duration in seconds
;         pitch = # of semitones above/below middle C
;
; Enter with: pitch on top of calculator stack
;             duration next on calculator stack
;
;; beep
L03F8:  RST     28H             ;; FP-CALC
        DEFB    $31             ;;duplicate                  ; duplicate pitch
        DEFB    $27             ;;int                        ; convert to integer
        DEFB    $C0             ;;st-mem-0                   ; store integer pitch to memory 0
        DEFB    $03             ;;subtract                   ; calculate fractional part of pitch = fp_pitch - int_pitch
        DEFB    $34             ;;stk-data                   ; push constant
        DEFB    $EC             ;;Exponent: $7C, Bytes: 4    ; constant = 0.05762265
        DEFB    $6C,$98,$1F,$F5 ;;($6C,$98,$1F,$F5)
        DEFB    $04             ;;multiply                   ; compute:
        DEFB    $A1             ;;stk-one                    ; 1 + 0.05762265 * fraction_part(pitch)
        DEFB    $0F             ;;addition
        DEFB    $38             ;;end-calc                   ; leave on calc stack

        LD      HL,$5C92        ; MEM-0: number stored here is in 16 bit integer format (pitch)
                                ;   0, 0/FF (pos/neg), LSB, MSB, 0
                                ;   LSB/MSB is stored in two's complement
                                ; In the following, the pitch is checked if it is in the range -128<=p<=127
        LD      A,(HL)          ; First byte must be zero, otherwise
        AND     A               ;   error in integer conversion
        JR      NZ,L046C        ; to REPORT-B

        INC     HL              ;
        LD      C,(HL)          ; C = pos/neg flag = 0/FF
        INC     HL              ;
        LD      B,(HL)          ; B = LSB, two's complement
        LD      A,B             ;
        RLA                     ;
        SBC     A,A             ; A = 0/FF if B is pos/neg
        CP      C               ; must be the same as C if the pitch is -128<=p<=127
        JR      NZ,L046C        ; if no, error REPORT-B

        INC     HL              ; if -128<=p<=127, MSB will be 0/FF if B is pos/neg
        CP      (HL)            ; verify this
        JR      NZ,L046C        ; if no, error REPORT-B
                                ; now we know -128<=p<=127
        LD      A,B             ; A = pitch + 60
        ADD     A,$3C           ; if -60<=pitch<=67,
        JP      P,L0425         ;   goto BE-i-OK

        JP      PO,L046C        ; if pitch <= 67 goto REPORT-B
                                ;   lower bound of pitch set at -60

;; BE-I-OK                      ; here, -60<=pitch<=127
                                ; and A=pitch+60 -> 0<=A<=187

L0425:  LD      B,$FA           ; 6 octaves below middle C

;; BE-OCTAVE                    ; A=# semitones above 5 octaves below middle C
L0427:  INC     B               ; increment octave
        SUB     $0C             ; 12 semitones = one octave
        JR      NC,L0427        ; to BE-OCTAVE

        ADD     A,$0C           ; A = # semitones above C (0-11)
        PUSH    BC              ; B = octave displacement from middle C, 2's complement: -5<=B<=10
        LD      HL,L046E        ; Address: semi-tone
        CALL    L3406           ; routine LOC-MEM
                                ;   HL = 5*A + $046E
        CALL    L33B4           ; routine STACK-NUM
                                ;   read FP value (freq) from semitone table (HL) and push onto calc stack

        RST     28H             ;; FP-CALC
        DEFB    $04             ;;multiply   mult freq by 1 + 0.0576 * fraction_part(pitch) stacked earlier
                                ;;             thus taking into account fractional part of pitch.
                                ;;           the number 0.0576*frequency is the distance in Hz to the next
                                ;;             note (verify with the frequencies recorded in the semitone
                                ;;             table below) so that the fraction_part of the pitch does
                                ;;             indeed represent a fractional distance to the next note.
        DEFB    $38             ;;end-calc   HL points to first byte of fp num on stack = middle frequency to generate

        POP     AF              ; A = octave displacement from middle C, 2's complement: -5<=A<=10
        ADD     A,(HL)          ; increase exponent by A (equivalent to multiplying by 2^A)
        LD      (HL),A          ;

        RST     28H             ;; FP-CALC
        DEFB    $C0             ;;st-mem-0          ; store frequency in memory 0
        DEFB    $02             ;;delete            ; remove from calc stack
        DEFB    $31             ;;duplicate         ; duplicate duration (seconds)
        DEFB    $38             ;;end-calc

        CALL    L1E94           ; routine FIND-INT1 ; FP duration to A
        CP      $0B             ; if dur > 10 seconds,
        JR      NC,L046C        ;   goto REPORT-B

        ;;; The following calculation finds the tone period for HL and the cycle count
        ;;; for DE expected in the BEEPER subroutine.  From the example in the BEEPER comments,
        ;;;
        ;;; HL = ((fCPU / f) - 236) / 8 = fCPU/8/f - 236/8 = 437500/f -29.5
        ;;; DE = duration * frequency - 1
        ;;;
        ;;; Note the different constant (30.125) used in the calculation of HL
        ;;; below.  This is probably an error.

        RST     28H             ;; FP-CALC
        DEFB    $E0             ;;get-mem-0                 ; push frequency
        DEFB    $04             ;;multiply                  ; result1: #cycles = duration * frequency
        DEFB    $E0             ;;get-mem-0                 ; push frequency
        DEFB    $34             ;;stk-data                  ; push constant
        DEFB    $80             ;;Exponent $93, Bytes: 3    ; constant = 437500
        DEFB    $43,$55,$9F,$80 ;;($55,$9F,$80,$00)
        DEFB    $01             ;;exchange                  ; frequency on top
        DEFB    $05             ;;division                  ; 437500 / frequency
        DEFB    $34             ;;stk-data                  ; push constant
        DEFB    $35             ;;Exponent: $85, Bytes: 1   ; constant = 30.125
        DEFB    $71             ;;($71,$00,$00,$00)
        DEFB    $03             ;;subtract                  ; result2: tone_period(HL) = 437500 / freq - 30.125
        DEFB    $38             ;;end-calc

        CALL    L1E99           ; routine FIND-INT2
        PUSH    BC              ;   BC = tone_period(HL)
        CALL    L1E99           ; routine FIND-INT2, BC = #cycles to generate
        POP     HL              ; HL = tone period
        LD      D,B             ;
        LD      E,C             ; DE = #cycles
        LD      A,D             ;
        OR      E               ;
        RET     Z               ; if duration = 0, skip BEEP and avoid 65536 cycle
                                ;   boondoggle that would occur next
        DEC     DE              ; DE = #cycles - 1
        JP      L03B5           ; to BEEPER

; ---


;; REPORT-B
L046C:  RST     08H             ; ERROR-1
        DEFB    $0A             ; Error Report: Integer out of range



; ---------------------
; THE 'SEMI-TONE' TABLE
; ---------------------
;
;   Holds frequencies corresponding to semitones in middle octave.
;   To move n octaves higher or lower, frequencies are multiplied by 2^n.

;; semi-tone         five byte fp         decimal freq     note (middle)
L046E:  DEFB    $89, $02, $D0, $12, $86;  261.625565290         C
        DEFB    $89, $0A, $97, $60, $75;  277.182631135         C#
        DEFB    $89, $12, $D5, $17, $1F;  293.664768100         D
        DEFB    $89, $1B, $90, $41, $02;  311.126983881         D#
        DEFB    $89, $24, $D0, $53, $CA;  329.627557039         E
        DEFB    $89, $2E, $9D, $36, $B1;  349.228231549         F
        DEFB    $89, $38, $FF, $49, $3E;  369.994422674         F#
        DEFB    $89, $43, $FF, $6A, $73;  391.995436072         G
        DEFB    $89, $4F, $A7, $00, $54;  415.304697513         G#
        DEFB    $89, $5C, $00, $00, $00;  440.000000000         A
        DEFB    $89, $69, $14, $F6, $24;  466.163761616         A#
        DEFB    $89, $76, $F1, $10, $05;  493.883301378         B


;   "Music is the hidden mathematical endeavour of a soul unconscious it 
;    is calculating" - Gottfried Wilhelm Liebnitz 1646 - 1716
