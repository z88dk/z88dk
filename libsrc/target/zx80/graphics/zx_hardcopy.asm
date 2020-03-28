;
;		Copy the graphics from screen to the zx printer
;		It can be used for any redefined (or not) pseudo-graphics, fonts and characters.
;
;		Traps the BREAK key to avoid an unwanted C program termination, etc..
;
;		Stefano Bodrato, 2018
;
;
;	$Id: zx_hardcopy.asm $
;
		SECTION code_clib
		PUBLIC    zx_hardcopy
		PUBLIC    _zx_hardcopy
		
		EXTERN  restore81
		;EXTERN  zx_fast
		;EXTERN  zx_slow


.zx_hardcopy
._zx_hardcopy

		call	restore81
		
; The full character-mapped screen is copied to the ZX-Printer.
; All twenty-four text/graphic lines are printed.

;; COPY
L0869:  LD      D,$16           ; prepare to copy twenty four text lines.
        LD      HL,($400C)      ; set HL to start of display file from D_FILE.
        INC     HL              ; 

;; COPY*D
L0876:  ;CALL    $02E7           ; routine SET-FAST

		; we are always in FAST mode..
		;call zx_fast

        PUSH    BC              ; *** preserve BC throughout.
                                ; a pending character may be present 
                                ; in C from LPRINT-CH

;; COPY-LOOP
L087A:  PUSH    HL              ; save first character of line pointer. (*)
        XOR     A               ; clear accumulator.
        LD      E,A             ; set pixel line count, range 0-7, to zero.

; this inner loop deals with each horizontal pixel line.

;; COPY-TIME
L087D:  OUT     ($FB),A         ; bit 2 reset starts the printer motor
                                ; with an inactive stylus - bit 7 reset.
        POP     HL              ; pick up first character of line pointer (*)
                                ; on inner loop.

;; COPY-BRK
L0880:
        IN      A,($FE)         ;
        RRA                     ;

        jr nc,stop_exit

; ---

;; COPY-CONT
L088A:  IN      A,($FB)         ; read from printer port.
        ADD     A,A             ; test bit 6 and 7
        JP      M,L08DE         ; jump forward with no printer to COPY-END

        JR      NC,L0880        ; back if stylus not in position to COPY-BRK

        PUSH    HL              ; save first character of line pointer (*)
        PUSH    DE              ; ** preserve character line and pixel line.

        LD      A,D             ; text line count to A?
        CP      $02             ; sets carry if last line.
        SBC     A,A             ; now $FF if last line else zero.

; now cleverly prepare a printer control mask setting bit 2 (later moved to 1)
; of D to slow printer for the last two pixel lines ( E = 6 and 7)

        AND     E               ; and with pixel line offset 0-7
        RLCA                    ; shift to left.
        AND     E               ; and again.
        LD      D,A             ; store control mask in D.

;; COPY-NEXT
L089C:  LD      C,(HL)          ; load character from screen or buffer.
        LD      A,C             ; save a copy in C for later inverse test.
        INC     HL              ; update pointer for next time.
        CP      $76             ; is character a NEWLINE ?
        JR      Z,L08C7         ; forward, if so, to COPY-N/L

        PUSH    HL              ; * else preserve the character pointer.

        SLA     A               ; (?) multiply by two
        ADD     A,A             ; multiply by four
        ADD     A,A             ; multiply by eight

		ld l,a
		ld	a,i
		adc	0
		ld	h,a
		ld	a,l

;        LD      H,$0F           ; load H with half the address of character set.
;        RL      H               ; now $1E or $1F (with carry)
        ADD     A,E             ; add byte offset 0-7
        LD      L,A             ; now HL addresses character source byte

        RL      C               ; test character, setting carry if inverse.
        SBC     A,A             ; accumulator now $00 if normal, $FF if inverse.
;		ld a,(hl)

        XOR     (HL)            ; combine with bit pattern at end or ROM.
        LD      C,A             ; transfer the byte to C.
        LD      B,$08           ; count eight bits to output.

;; COPY-BITS
L08B5:  LD      A,D             ; fetch speed control mask from D.
        RLC     C               ; rotate a bit from output byte to carry.
        RRA                     ; pick up in bit 7, speed bit to bit 1
        LD      H,A             ; store aligned mask in H register.

;; COPY-WAIT
L08BA:  IN      A,($FB)         ; read the printer port
        RRA                     ; test for alignment signal from encoder.
        JR      NC,L08BA        ; loop if not present to COPY-WAIT

        LD      A,H             ; control byte to A.
        OUT     ($FB),A         ; and output to printer port.
        DJNZ    L08B5           ; loop for all eight bits to COPY-BITS

        POP     HL              ; * restore character pointer.
        JR      L089C           ; back for adjacent character line to COPY-NEXT

; ---

; A NEWLINE has been encountered either following a text line or as the 
; first character of the screen or printer line.

;; COPY-N/L
L08C7:  IN      A,($FB)         ; read printer port.
        RRA                     ; wait for encoder signal.
        JR      NC,L08C7        ; loop back if not to COPY-N/L

        LD      A,D             ; transfer speed mask to A.
        RRCA                    ; rotate speed bit to bit 1. 
                                ; bit 7, stylus control is reset.
        OUT     ($FB),A         ; set the printer speed.

        POP     DE              ; ** restore character line and pixel line.
        INC     E               ; increment pixel line 0-7.
        BIT     3,E             ; test if value eight reached.
        JR      Z,L087D         ; back if not to COPY-TIME

; eight pixel lines, a text line have been completed.

        POP     BC              ; lose the now redundant first character 
                                ; pointer
        DEC     D               ; decrease text line count.
        JR      NZ,L087A        ; back if not zero to COPY-LOOP

stop_exit:
        LD      A,$04           ; stop the already slowed printer motor.
        OUT     ($FB),A         ; output to printer port.

;; COPY-END
L08DE:  ;CALL    $0207           ; routine SLOW/FAST
		;call zx_slow
        POP     BC              ; *** restore preserved BC.
		RET
