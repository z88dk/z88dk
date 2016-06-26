;
;	ZX81 libraries - Stefano Dec 2012
;
;----------------------------------------------------------------
;
;	$Id: gen_tv_field.asm,v 1.4 2016-06-26 20:36:33 dom Exp $
;
;----------------------------------------------------------------
;
; ZX80 (and ZX81 in FAST mode) trick to try to keep the display stable.
; This subroutine should be called in theory after every 1475ms  (4731 T-states, corresponding to 22.99 scan lines).
; According to this article: http://www.fruitcake.plus.com/Sinclair/ZX80/FlickerFree/ZX80_DisplayMechanism.htm
; .. a margin has to be considered.

;
;----------------------------------------------------------------

	SECTION code_clib
	PUBLIC	gen_tv_field
	PUBLIC	_gen_tv_field
	PUBLIC	DFILE_PTRA
	PUBLIC	DFILE_PTRB

gen_tv_field:
_gen_tv_field:
        OUT  ($FF),A                    ; 11        Turn off the vertical sync generator.

; Generate the top border and main display area.

;		NOP
DFILE_PTRA:
        LD   A,$E9                      ; 7         Timing counter for the duration of the first
                                        ;           scan line of the top border. Thereafter set
                                        ;           to $DD by the ROM.
;        LD   BC,$1900                   ; 10        There are 25 HALTs within the display file,
		LD		B,$19
                                        ;           i.e. 24 rows and 1 top border. C is set only
                                        ;           to achieve perfect timing.
;        LD   HL,DFILE+$8000             ; 10        Point to the start of the display file, i.e.
                                        ;           the initial HALT representing the top border,
                                        ;           but with bit 15 of the address set.

        LD      HL,($400C)      ;; point HL to D-FILE the first HALT
                                ;; instruction.
        SET     7,H             ;; now point to the DFILE echo in the 
                                ;; top 32K of address space.

DFILE_PTRB:
        ;LD   C,24			;
        LD   C,48			; 7         There are 48 scan lines (UK) above the ZX80
                                        ;           main display area, or 24 for USA models.
                                  
        CALL $01B0                      ; 17+n      Produce the top border and main area.

; Generate the bottom border.

        LD   A,$EC                      ; 7         Timing counter for the duration of the first
                                        ;           scan line of the bottom border. Thereafter
                                        ;           set to $DD by the ROM.
        INC  B                          ; 4         Increment the row count, i.e. B holds $01.
        DEC  HL                         ; 6         Decrement the screen address, i.e. point to
                                        ;           the last HALT.
        LD   C,$2F			; 7         the blank line counter, i.e. 47 or 23
                                        ;           scan lines below the ZX80 main display area.
        CALL $01B0                      ; 17+n      Produce the bottom border.

; Start the vertical sync pulse.

        IN   A,($FE)                    ; 11        Turn on the vertical sync generator. It be
                                        ;           will be turned off approximately 23 scan
        RET                             ; 10        lines from now.
