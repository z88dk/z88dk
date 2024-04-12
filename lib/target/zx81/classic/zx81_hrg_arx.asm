;       CRT0 for the ZX81 - HIGH RESOLUTION MODE (arx816 trick by Andy Rea)
;       Display handler modifications (to preserve IY) by Stefano Bodrato
;
;       Apr. 2024 - better sync control and character row count based on the new driver by Paul Farrow
;
;
; -- display modes --
; startup=13 - full screen, on exit requires BREAK to get back to text mode
; startup=14 - full screen, on exit returns immediately to text mode
; startup=15 - 64 rows, on exit requires BREAK to get back to text mode
; startup=16 - 64 rows, on exit returns immediately to text mode
; startup=17 - 4 levels grayscale, 64 rows
;
;
; - - - - - - -
;
;       $Id: zx81_hrg_arx.def $
;
; - - - - - - -

PUBLIC	hrg_on
PUBLIC	_hrg_on
PUBLIC	hrg_off
PUBLIC	_hrg_off
PUBLIC	HRG_LineStart
PUBLIC	HRG_handler
PUBLIC	zx_blank
PUBLIC	_zx_blank
PUBLIC	zx_noblank
PUBLIC	_zx_noblank
PUBLIC	zx_fast
PUBLIC	_zx_fast
PUBLIC	zx_slow
PUBLIC	_zx_slow


IF ((startup=13)|(startup=15))
hrgbrkflag:
        defb    0
ENDIF

;--------------------------------------------------------------
;--------------------------------------------------------------

;------------------------------------------
;
;   ZX81 system variables
;
;------------------------------------------
;DEFC   ERR_NR  = 16384 ;byte   one less than the report code
;DEFC   FLAGS   = 16385 ;byte   flags to control the BASIC system.
;DEFC   MODE    = 16390 ;byte   Specified K, L, F or G cursor.
;DEFC   PPC     = 16391 ;word   Line number of statement currently being executed

DEFC    ERR_SP  = 16386 ;word   Address of first item on machine stack (after GOSUB returns).
DEFC    RAMTOP  = 16388 ;word   Address of first byte above BASIC system area. 


;----------------------------------------------------------------
;
; Enter in FAST mode 
;
;----------------------------------------------------------------
zx_fast:
_zx_fast:
	call restore81
	jp	$F23		; FAST !

;----------------------------------------------------------------
;
; Switch to HRG mode 
; "base_graphics" has to point to a reasonable adress
;
;----------------------------------------------------------------
zx_slow:
_zx_slow:
hrg_on:
_hrg_on:
		call   restore81
		call   $F2B	; SLOW
IF !DEFINED_hrgpage
        ld      hl,(base_graphics)
        ld      a,h
        or      l
        jr      nz,no_default_base
        ld      hl,$2000      ; set base_graphics
        ld      (base_graphics),hl
.no_default_base
ENDIF
IF (startup=17)
        ld  hl,(base_graphics)
        ld	(graybit1),hl
        ld	de,2048
        add	hl,de
        ld	(graybit2),hl
ENDIF

;----------------------------------------------------------------
zx_noblank:
_zx_noblank:
        ld      hl,HRG_handler  ; starts the hires mode when JP (IX) is made
        call	HRG_Sync
IF (startup<15)
		xor a
		ld	(HRG_blank_patch+1),a
ENDIF
        ret

;----------------------------------------------------------------
zx_blank:
_zx_blank:
        ld      hl,HRG_BlankHandler
        call	HRG_Sync
IF (startup<15)
		ld	a,140
		ld	(HRG_blank_patch+1),a
ENDIF
        ret

;----------------------------------------------------------------
;
; Switch to TXT mode
;
;----------------------------------------------------------------
hrg_off:
_hrg_off:
IF DEFINED_noslowfix
		jp		zx_fast
ELSE
		call	hrg_on     ; restore registers and make sure we are in SLOW mode

        ld      hl,L0281    ; switch back to text (fixed video routine)

        call	HRG_Sync
        ld      a,$1e
        ld      i,a
        ret
ENDIF

;----------------------------------------------------------------
;
; Sync display before mode switching
;
;----------------------------------------------------------------
HRG_Sync:
        push   hl
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        jr     z,nosync
        ld     hl,$4034        ; FRAMES counter
        ld     a,(hl)          ; get old FRAMES
HRG_Sync1:
        cp     (hl)            ; compare to new FRAMES
        jp     z,HRG_Sync1     ; exit after a change is detected
nosync:
        pop    hl
        push   hl
        ld     (HRG_handler_patch+2),hl
        pop    iy
        ret


IF !DEFINED_noslowfix
        INCLUDE "zx81_altint_core.asm"
ENDIF
        

;----------------------------------------------------------------
;
; Entry for the HRG handler in blank mode
;
;----------------------------------------------------------------

HRG_BlankHandler:
        ld	a,123	; 52+8+8+55	..work always in 64 rows mode
                    ; to stay in the counter range   ;)
		ld (16424),a      ; MARGIN will ..cover the whole screen !
		jp HRG_postproc

;----------------------------------------------------------------
;
; This is the HRG handler
;
; I need to sync my lines with the ULA row counter the effect
; is to slow down basic execution a bit, not sure how much but
; it's effectively 8 scanlline
;
;----------------------------------------------------------------

HRG_handler:
        LD   B,$03                              ; 7                     Delay to ensure the LNCTR is reset when aligned with the hardware generated HSync.

ADP_DELAY:
        DJNZ ADP_DELAY                          ; 13/8=34

; Preserve the value of the I register.

        LD   A,I                                ; 9
        LD   E,A                                ; 4                     Save the current value of I, which allows the user program to use it.

; Prepare registers for exiting the driver routine.

        LD   A,($4028)			        ; 13                    Fetch the number of bottom border lines from system variable MARGIN.
        DEC  A                                  ; 4                     Decrement the number of bottom border lines to output to compensate for the initial delay of the VSync routine.
        LD   D,A                                ; 4                     Save the number of bottom border lines.
       
        LD   iy,ARX_DRIVER_VSYNC                ; 14            "pointedbyix"  Set the display vector address to point at the VSync pulse generation routine.


;; Initialise registers required by the ARX display driver.
        ld      a,$20                           ; 7 T  The first character set begins at $2000
        ld      i,a                             ; load MSB into I register which is RFSH address MSB


IF (startup>=15)
        LD   BC,$0408                           ; 10                    B=Number of character sets. C=Number of lines in a row.
else
        LD   BC,$0C08                           ; 10                    B=Number of character sets. C=Number of lines in a row.
endif

; Force the LNCTR to reset so that characters are output starting with their top line.

        IN   A,($FE)                            ; 11                    Force the LNCTR to 0 aligned with the start of the hardware HSync pulse. Also sets the video output to black.

; Enter a loop to output the 8 lines of a row of characters. Each iteration takes 207 T-cycles.

ADP_ROW1_LOOP:
        OUT  ($FF),A                            ; 11                    Set the video output back to white. Doubles as a delay on subsequent loop iterations.

        LD   H,$00                              ; 7                     Delay to ensure the picture begins with the same left border size as the standard display.
        LD   L,H                                ; 4                     HL holds $0000 which ensures the CP (HL) instructions in later delays do not accidentally invoke any RAM based memory mapped devices.

        LD   A,I                                ; 9                     Restore the value of I into A since this will be incremented by 2 to advance to the next character set.

g_patch1:
L41C7:  CALL HRG_LineStart + $8000              ; 17+(32*4)+10=155      Output a line of the row by 'executing' the echo of it.
        DEC  C                                  ; 4                     Decrement the count of the number of lines in the row.
        JR   Z,ADP_ROW1_DONE                    ; 12/7                  Jump ahead if all lines of the row have been output.

        JP   ADP_ROW1_LOOP                      ; 10                    Loop back to output the next line of the row.


; Move on to outputting the second row of characters for the current character set.

ADP_ROW1_DONE:
        LD  C,$08                               ; 7                     Re-initialise with the number of lines in a row.

; Enter a loop to output the 8 lines of a row of characters. Each iteration takes 207 T-cycles.

ADP_ROW2_LOOP:
        ADD HL,HL                               ; 11                    Delay.
        ADD HL,HL                               ; 11                    Delay.
        CP  (HL)                                ; 7                     Delay. This will read from address $0000 and so will not accidentally invoke any RAM based memory mapped devices.

g_patch2:
        CALL HRG_LineStart2 + $8000             ; 17+(32*4)+10=155      Output a line of the row by 'executing' the echo of it.
        DEC  C                                  ; 4                     Decrement the count of the number of lines in the row.
        JR   Z,ADP_ROW2_DONE                    ; 12/7                  Jump ahead if all lines of the row have been output.

        JR   ADP_ROW2_LOOP                      ; 12                    Loop back to output the next line of the row.

; Two rows have been output using the current character set, so now move onto the next character set.

ADP_ROW2_DONE:

        ADD  A,$02                              ; 7                     Advance to the next character set.
        LD   I,A                                ; 9

        LD   C,$08                              ; 7                     Re-initialise with the number of lines in a row.
        DJNZ L41C7                              ; 13/8                  Loop back to render the next character set.

; All lines of the main picture area have been output.

        LD   A,E
        LD   I,A                                ;                       Restore the original value of I.

        LD   A,D                                ;                       Retrieve the number of bottom border lines.
;        JP   $029E				;                       Enable the NMI generator and return to user program, which will be interrupted as the bottom border is being generated.



; -------------------------------------------------------
; 
HRG_postproc:

        ;call   $0292          ; return to application program

; Different from original call to keep IY unchanged
; and to eventually add blank lines
        ld      iy,ARX_DRIVER_VSYNC  ; in ROM we'd have had a POP IX and JP IX as a 'return'
        ld      a,(16424)      ; 33 or 19 blank lines in bottom MARGIN

; this idea comes from the Wilf Rigter's WRX1K hi-resolution implementation
; if we run in 64 lines mode we need to increase the number of border's lines

HRG_blank_patch:	; WARNING: the values change due to the patching, don't tune here !!
IF (startup>=15)
        add     140    ; more blank lines for fast application code and correct sync
        			; For the WRX version Siegfried Engel reports that values between 
        			; 80 and 159 worked fine on both a normal TV and an LCD one
; ELSE
;        add		-8             ; reduce by 8 scan lines
ENDIF

        ld      c,a            ; load C with MARGIN
        ; ld      a,(16443)     ; test CDFLAG
        ; bit     7,a
        and      a             ; setting zero flag is enough, 
                               ; ..we know MARGIN will always be > 0  ;)

        jp      $29b           ; save blank lines, start NMI, POP registers and RETURN

ARX_DRIVER_VSYNC:
        push    ix
        ld      ix,16384

        ld    hl,($4034)        ; FRAMES, used also by clock handler
        dec   hl
        ld    ($4034),hl

        call    $0220          ; first PUSH register, then do VSYNC and get KEYBD

IF ((startup=13)|(startup=15))
        ;call    $0F46          ; check break (space) key
        LD      A,$7F           ; read port $7FFE - keys B,N,M,.,SPACE.
        IN      A,($FE)         ;
        RRA                     ; carry will be set if space not pressed.
        jp      c,nobrkk
        ld      a,(hrgbrkflag)     ; set to '0' if program isn't running
        and	a
        jr	z,nobrkk
        SCF
nobrkk:

ELSE
IF (startup=14)
        SCF
ENDIF
        nop
        nop
        nop
ENDIF

IF (startup<15)
        nop
;		nop
ENDIF

        pop     ix

IF ((startup=13)|(startup=15))
		jp		c,nobrkk2
        ld      a,$1e           ; the I register is restored with the MSB address
        ld      i,a             ; of the ROM pattern table in case of BREAK key down
        jp      $02A4
nobrkk2:
ENDIF

IF (startup=17)
	ld	hl,gcount
	;res	7,(hl)
	inc	(hl)
	ld	a,(hl)
	dec	a
	jp	z,Display_pic1
	dec	a
	jp	z,Display_pic2
	ld	(hl),0
Display_pic1:
	ld hl,HRG_LineStart + $8000
	ld (g_patch1+1),hl
	ld hl,HRG_LineStart2 + $8000
	ld (g_patch2+1),hl
	jp	page_set
Display_pic2:
	ld hl,HRG_LineStart + $8100
	ld (g_patch1+1),hl
	ld hl,HRG_LineStart2 + $8100
	ld (g_patch2+1),hl
	jp	page_set

page_set:

ENDIF

HRG_handler_patch:
        ld      iy,HRG_handler  ; reload vector if no BREAK or else SINCLAIR video
        ld      a,(16424)      ; 33 or 19 blank lines in bottom MARGIN
        sub     8              ; reduce by 8 scan lines

        jp      $029e           ; now update A', start NMI, POP registers and return to BASIC/programs


; -----------------------------------------
; Generate VSync Pulse And Begin Top Border
; -----------------------------------------
; Returns here after the bottom border has been generated.

        LD   B,$09                              ; 7                     Delay to ensure the VSync pulse begins aligned with the end of the next hardware generated HSync.
        
ADV_DELAY:
        DJNZ ADV_DELAY                          ; 13/8=112
        
        PUSH ix                                 ; 15                    Save the current value of IY, which allows the user program to use it.

        LD   ix,16384                           ; 14                    Point at the start of the system variables, which is required by the VSync ROM routine.
        CALL $0220				;                       Generate the VSync pulse and then start generating the top border lines.

; Immediately returns back to here but with the NMI generator now switched on. The IX register now holds $0281.

        POP  ix                                 ;                       Restore the original value of IY.

        LD   iy,HRG_handler                     ;                       Set the display vector address to point at the main picture generation routine.
        JP   $02A2				;                       Enable the NMI generator and return to the user program, which will be interrupted as the top border is being generated.


;----------------------------------------------------------------
;  Variables for grayscale graphics
;----------------------------------------------------------------

IF (startup=17)
		PUBLIC	graybit1
		PUBLIC	graybit2
gcount:
		defb	0
graybit1:
		defw	0
graybit2:
		defw	0
ENDIF

;----------------------------------------------------------------
;
;	because of the way this ram is addressed during refresh
;	we need 2 dummy d-file lines, the first to do even character
;	rows, the second to do odd character rows. So basically the
;	h-file is laid out like 12 consecutive character maps.
;
;	each buffer is called 8 times as video bytes
;	both repeated 12 times in total,
;	(8+8)*12=192 scanlines.
;
;----------------------------------------------------------------

HRG_LineStart:
	defb 00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15
	defb 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
	ret

HRG_LineStart2:
	defb 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47
	defb 48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
	ret


;----------------------------------------------------------------
;
; End of HRG handler
;
;----------------------------------------------------------------

