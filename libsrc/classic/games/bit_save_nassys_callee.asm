;
; "CUTS 8000" Originally written to run the ZX Spectrum by M D Hendry, 10 Oct 1984
; to create a tape track compatible to the Nascom NAS-SYS

; The "8000" in the routine name refers to its original position in the ZX Spectrum RAM.
; It is a nice piece of code but it doesn't produce the different header (00 1B 1B 1B 1B)
; needed to identify the last block, the loading activity on the NASCOM side required manual operations.

; The original hardware produced a tone when in idle status, so the leading tone could be created by 
; calling a "wait" routine.   This means that length of the leading tone is probably different, 
; but we know it was used on the real hardware.

; " The output format follows exactly the format of a "W XXXX YYYY" command under NAS-SYS with all the usual checksums.
;   The generated audio can be loaded directly into memory on the NASCOM using the "R" command.
;   If NAS-SYS 3 is available, it may be loaded at any address by giving the appropriate offest as an argument. "

; CUTS worked at either 300 or 1200 baud, Michael Hendry chose the latter because the program
; showed to get more reliable.   At 1200 baud CUTS simply reduced the number of cycles per bit,
; with a mark being two cycles of 2400 and a space being one cycle at 1200. 
; It was otherwise the same as the original Kansas City standard, with a single "0" for the start bit
; and two trailing "1"s as stop bits, giving an effective data rate of 873 bits per second.


; NOTE: This program was configured to send 2 stop bits (see the commented out lines), but apparently
;       a different 1 stop-bit option existed  (e.g. on the BBC Micro).
;
;       Typical Nascom DIP switch setting: 1200 baud, 8 bits, no parity, and 1 stop-bit
;       It is also close to the SOL-20 format, with the following RS232 switches:
;              S4: (1..6), OFF, OFF, OFF,   ON (one stop), OFF (no parity), OFF
;              S3: (1..7), OFF, OFF, OFF, OFF, OFF, ON (1200 baud), OFF OFF
;
;       It is easy to get confused about the start/stop bit settings though, because in many cases 
;       1 start bit + 1 stop bit is equivalent to having 2 stop bits !



    SECTION code_clib

    PUBLIC  bit_save_nassys_callee
    PUBLIC  _bit_save_nassys_callee
    PUBLIC  asm_bit_save_nassys

    INCLUDE "classic/games/games.inc"

    EXTERN  bit_open_di
    EXTERN  bit_close_ei
    EXTERN  __snd_tick



;DEFC DEL1=111  ; 110.64
;DEFC DEL2=108  ; 108.03
;DEFC DEL3=55   ; 54.55
;DEFC DEL4=52   ; 51.94

;  Delay values originally computed for the ZX Spectrum.
;  We reuse the constants already available

DEFC DEL1=(PLAY_MSXDATA_LO/255)+LDR_DATA_TIMING   ; 111
DEFC DEL2=DEL1-PLAY_DATA_BIAS                     ; -4
DEFC DEL3=PLAY_DATA_SYNC2                         ; 54
DEFC DEL4=DEL3-(PLAY_DATA_BIAS/2)                 ; -2


bit_save_nassys_callee:
_bit_save_nassys_callee:


IF  __CPU_GBZ80__
    pop     af                          ;ret
    pop     de                          ;byte
    pop     hl                          ;addr
    push    af
ELSE
    pop     hl
    pop     de
    ex      (sp), hl
ENDIF



asm_bit_save_nassys:


IF  __CPU_GBZ80__||__CPU_INTEL__
asm_bit_load_block_zx:
    ret
ELSE

        LD      (ARG1),HL
        INC     DE        ; end address +1
        LD      (ARG2),DE

  IF    SOUND_ONEBIT_port>=256
    exx
    ld      bc, SOUND_ONEBIT_port
    exx
  ENDIF

        CALL    bit_open_di

        LD      BC,2000   ; leading tone
		                  ; originally it was just a DJNZ (256 cycles)
						  ; the author explained the NASCOM had a continous tone when idle
PL0:    PUSH    BC
        SCF               ; set flag for high bit
        CALL    SndBit
        POP     BC
		DEC     BC
		LD      A,B
		OR      C
        JR      NZ,PL0    ; send 256 high bits
		
        LD      B,0       ; set up counter
        LD      L,0       ; set up output register
PL1:    PUSH    BC
        CALL    BytOut    ; Output 256 null bytes.
                          ; On the dumentation it is written it helps with the
                          ; manual tape operations, like rewinding etc..
                          ; It also helps with those tape recorders
                          ; with an automatic microphone volume regulation
        POP     BC
        DJNZ    PL1

        LD      HL,(ARG1)
        ;    ##########  BLOCK LOOP  ##########
PL1A:   LD      DE,(ARG2)


        EX      DE,HL
        SCF               ; if len-1 is neg, end
        SBC     HL,DE
        JR      C,Finish
        EX      DE,HL

        LD      BC,2400   ; set up counter
PL2:    PUSH    BC
        SCF               ; set flag for high bit
        CALL    SndBit
        POP     BC
		DEC     BC
		LD      A,B
		OR      C
        JR      NZ,PL2       ; send 256 high bits

        ; --------------- BLOCK HEADER ---------------
        ; output 00 ff ff ff ff
        XOR     A         ; output 1 byte set to $00
        LD      B,5
PL3:    CALL    BOCall
        LD      A,0FFH    ; ..followed by 4 bytes set to $FF
        DJNZ    PL3

        ; if block 0, set len to e+1
        XOR     A
        CP      D
        JR      NZ,PL4
        LD      B,E
        INC     B
PL4:    LD      E,B
        LD      A,L       ; Output start address
        CALL    BOCall
        LD      A,H
        CALL    BOCall
        LD      A,E       ; output length of data
        CALL    BOCall
        LD      A,D       ; output block number
        CALL    BOCall
        ; -------------- HEADER CHECKSUM --------------
        LD      A,H
        ADD     A,L
        ADD     A,D
        ADD     A,E
        CALL    BOCall

        ; --------------- DATA BLOCK ------------------
        LD      C,0       ; init data checksum
PL5:    LD      A,(HL)
        ADD     A,C       ; update data checksum
        LD      C,A
        LD      A,(HL)
        CALL    BOCall
        INC     HL
        DJNZ    PL5
        ; --------------- DATA BLOCK CHECKSUM ---------------
        LD      B,11      ; output checksum and 10 nulls
        LD      A,C
PL6:    CALL    BOCall
        XOR     A
        DJNZ    PL6
        JR      PL1A
        ;    ##########  ##########  ##########

Finish:
        ld      a, (__snd_tick)             ; MIC on
        ONEBITOUT
        JP      bit_close_ei


BOCall: PUSH    HL        ; preserve registers
        PUSH    BC
        LD      L,A
        CALL    BytOut
        POP     BC        ; recover registers
        POP     HL
        RET

        ; Output a byte from the L register
BytOut: XOR     A         ; set up for a start bit
        CALL    SndBit
        LD      B,8
BO1:    PUSH    BC
        SRL     L         ; send 8 bits of data
        CALL    SndBit
        POP     BC
        DJNZ    BO1
        SCF               ; send 2 stop bits
        CALL    SndBit
        SCF               ; ^---  removing the 2 lines above we can change to 1 stop bit
        
        ; Output the bit in the carry register
        
SndBit: JR      C,HiBit   ; jump if logic 1
        LD      B,1       ; else 1 cycle at 1200Hz
SB0:    PUSH    BC

        ld      a, (__snd_tick)             ; MIC on
        ONEBITOUT
        
        LD      B,DEL1
SB1:    DJNZ    SB1

  IF    (TAPEIN_ONEBIT_port=$FE)
        xor     $1E                         ; On the ZX Spectrum we extend the output to MIC, EAR, and BORDER
  ELSE
        xor     SOUND_ONEBIT_mask           ; MIC on<>off
  ENDIF
        ONEBITOUT

        LD      B,DEL2
SB2:    DJNZ    SB2

        POP     BC
        DJNZ    SB0
        RET


        ; 2 cycles at 2400Hz
HiBit:  LD      B,2
HB0:    PUSH    BC

        ld      a, (__snd_tick)             ; MIC on
        ONEBITOUT
        
        LD      B,DEL3
HB1:    DJNZ    HB1

  IF    (TAPEIN_ONEBIT_port=$FE)
        xor     $1E                         ; On the ZX Spectrum we extend the output to MIC, EAR, and BORDER
  ELSE
        xor     SOUND_ONEBIT_mask           ; MIC on<>off
  ENDIF
        ONEBITOUT

        LD      B,DEL4
HB2:    DJNZ    HB2

        POP     BC
        DJNZ    HB0
        RET

ENDIF



    SECTION bss_clib

ARG1:  defs 2   ; Start address
ARG2:  defs 2   ; End address+1


