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
		
		EXTERN	loadudg6

.zx_hardcopy
._zx_hardcopy


		ld   c,0	; first UDG chr$ to load
		ld	 b,64	; number of characters to load
		;ld	hl,acefont
		ld	hl,0
		add hl,sp
		ld	(stacksave+1),hl
		ld	hl,-512
		add hl,sp
		ld sp,hl
		push hl
		call loadudg6
		pop hl
		ld de,-1024
		add hl,de
		ld	(acefont+1),hl
	
; The full character-mapped screen is copied to the ZX-Printer.
; All twenty-four text/graphic lines are printed.

;; COPY
		DI
L0869:  LD      D,24           ; prepare to copy twenty four text lines.
        LD      HL,$2400       ; set HL to start of display file from D_FILE.

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
; row_sync
;.LOOP1
;        IN A,($FB)              ; GET PRINTER STATUS BYTE
;        RLA                     ; ROTATE BIT 7 (LF BUSY) TO C FLAG
;        JR NC,LOOP1             ; LOOP IF LINEFEED IS BUSY


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
L089C:  LD      A,(HL)          ; load character from screen or buffer.

		ld	c,a
		
        INC     HL              ; update pointer for next time.
        PUSH    HL              ; * else preserve the character pointer.
		ld	h,0

		sub 128
		ld	a,h			; zero
		jp	c,blank		; filter out non-udg characters and force them to blank
		ld  a,c

		ld	l,a
		
		ld	c,d		; save D reg
		ld	d,h		; ..and put zero on it
		
		rl l
		rl h		; *2
		rl l
		rl h		; *4
		rl l
		rl h		; *8
		
		add hl,de			; current character row
		ld	a,e		; save E reg
acefont:
		;ld	de,acefont-1024
		ld	de,0
		add hl,de
		ld	e,a
		ld	d,c
				
		ld		a,(hl)
blank:

        LD      C,A             ; transfer the byte to C.
        LD      B,$08           ; count eight bits to output.

;; COPY-BITS
L08B5:  LD      A,D             ; fetch speed control mask from D.
        RLC     C               ; rotate a bit from output byte to carry.
        RRA                     ; pick up in bit 7, speed bit to bit 1
        LD      H,A             ; store aligned mask in H register.

;; COPY-WAIT
L08BA:  
        IN      A,($FB)         ; read the printer port
        RRA                     ; test for alignment signal from encoder.
        JR      NC,L08BA        ; loop if not present to COPY-WAIT

        LD      A,H             ; control byte to A.
        OUT     ($FB),A         ; and output to printer port.
        DJNZ    L08B5           ; loop for all eight bits to COPY-BITS
		
        POP     HL              ; * restore character pointer.
		ld	a,31
		and l                   ; test if we are in a new line

        JR      nz,L089C           ; if within 32 columns, back for adjacent character line to COPY-NEXT

; ---

; End of line
;; COPY-N/L

L08C7:  
        IN      A,($FB)         ; read the printer port
        RRA                     ; test for alignment signal from encoder.
        JR      NC,L08C7        ; loop if not present (as in COPY-WAIT)

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
L08DE:  
stacksave:
		ld	hl,0
		ld	sp,hl
		EI
		RET


;	SECTION	bss_clib
		
;acefont:
;		defs	512


