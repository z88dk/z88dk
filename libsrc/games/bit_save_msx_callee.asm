;
;      Tape save routine
;
;      Stefano, 2022
;
;      int  bit_save_msx(char *name, size_t loadstart, void *start, void *exec, size_t len);
;

        SECTION code_clib

        PUBLIC  bit_save_msx_callee
        PUBLIC  _bit_save_msx_callee
        PUBLIC  asm_bit_save_msx

        INCLUDE "games/games.inc"

        EXTERN  bit_open_di
        EXTERN  bit_close_ei
        EXTERN  __snd_tick

  IF    __CPU_GBZ80__||__CPU_INTEL__
bit_save_msx_callee:
_bit_save_msx_callee:
asm_bit_save_msx:
        ret
  ELSE

bit_save_msx_callee:
_bit_save_msx_callee:

        POP     AF                      ; ret_addr
        POP     DE                      ; len
        POP     BC                      ; exec
        POP     HL                      ; start
        EXX
        POP     DE                      ; loadstart
        POP     HL                      ; name

        PUSH    AF

asm_bit_save_msx:

        PUSH    IX
        call    bit_open_di

        PUSH    DE
        LD      A, $D0                  ; BYTE block type header (long leading tone)
        CALL    SEND_CAS_FNAME
        POP     DE

        XOR     A                       ; short leading tone
        CALL    CWRTON                  ; start tape for writing

        EX      DE, HL
        PUSH    HL
        CALL    CASOUT_HL               ; declared M/C starting address

        EXX

        EX      (SP), HL
        ADD     HL, DE
        CALL    CASOUT_HL               ; declared M/C ending address

        LD      H, B
        LD      L, C
        CALL    CASOUT_HL               ; declared M/C exec entry

        POP     HL                      ; real starting address
        PUSH    HL
        ADD     HL, DE                  ; real ending address
        POP     DE
        EX      DE, HL

BSAVE_LOOP:
        LD      A, (HL)
        CALL    CASOUT                  ; send byte to tape
        CALL    DCOMPR                  ; Compare HL with DE.
        JR      NC, BSAVE_END
        INC     HL
        JR      BSAVE_LOOP
BSAVE_END:
        call    bit_close_ei
        POP     IX
        RET


DCOMPR:
        LD      A, H
        SUB     D
        RET     NZ
        LD      A, L
        SUB     E
        RET


SEND_CAS_FNAME:
        CALL    CWRTON                  ; start tape for writing
        LD      B, 10
SEND_CAS_TYPE:
        CALL    CASOUT                  ; send 10 type bytes to tape
        DJNZ    SEND_CAS_TYPE
        LD      B, 6
SEND_CAS_NAME:
        LD      A, (HL)
        AND     A                       ; check for string termination
        JP      NZ, NM_CONT
        LD      A, ' '
        JP      NM_END
NM_CONT:
        INC     HL
NM_END:
        CALL    CASOUT
        DJNZ    SEND_CAS_NAME

;IF FORsvi
;  XOR A		; SCRMOD 0
;  CALL CASOUT
;ENDIF

        RET



CWRTON:
        PUSH    HL
        PUSH    DE
        PUSH    BC
        PUSH    AF
;  CALL TAPOON

        OR      A
        PUSH    AF

        LD      HL, $0000
CWRTON_0:
        DEC     HL
        LD      A, H
        OR      L
        JR      NZ, CWRTON_0

        POP     AF
        LD      A, PLAY_MSXDATA_HDR
        JR      Z, CWRTON_1
        ADD     A, A
        ADD     A, A
CWRTON_1:
        LD      B, A
        LD      C, $00
  ;DI
CWRTON_2:
        CALL    TAPSEND_HIGH
        CALL    TAPSEND_RET
        DEC     BC
        LD      A, B
        OR      C
        JR      NZ, CWRTON_2

CWRTON_RET_0:
        POP     AF
        POP     BC
        POP     DE
        POP     HL
TAPSEND_RET:
        RET




CASOUT_HL:
        LD      A, L
        CALL    CASOUT
        LD      A, H
        JP      CASOUT

CASOUT:
        PUSH    HL
        PUSH    DE
        PUSH    BC
        PUSH    AF

        LD      HL, PLAY_MSXDATA_LO
        PUSH    AF
        LD      A, L
        SUB     $0E
        LD      L, A
  ; start bit (HL=LOW)
        CALL    TAPSEND_0
        POP     AF
        LD      B, $08                  ; 8 bits
_TAPOUT_0:
        RRCA
        CALL    C, TAPSEND_HIGH_X2      ; '1'
        CALL    NC, TAPSEND_LOW         ; '0'
        DJNZ    _TAPOUT_0
  ; stop bits
        CALL    TAPSEND_HIGH_X2
        CALL    TAPSEND_HIGH_X2

        JR      CWRTON_RET_0



TAPSEND_HIGH_X2:
        CALL    TAPSEND_HIGH
        EX      (SP), HL
        EX      (SP), HL
        NOP
        NOP
        NOP
        NOP
        CALL    TAPSEND_HIGH
        RET


TAPSEND_LOW:
        LD      HL, PLAY_MSXDATA_LO
        CALL    TAPSEND_0
        RET


TAPSEND_HIGH:
        LD      HL, PLAY_MSXDATA_HI

TAPSEND_0:
        PUSH    AF

TAPSEND_1:
        DEC     L
        JP      NZ, TAPSEND_1
        ld      a, (__snd_tick)         ; MIC on
    IF  (TAPEIN_ONEBIT_port=$FE)
        xor     $1E                     ; On the ZX Spectrum we extend the output to MIC, EAR, and BORDER
    ELSE
        xor     SOUND_ONEBIT_mask       ; MIC on<>off
    ENDIF
        ONEBITOUT
TAPSEND_2:
        DEC     H
        JP      NZ, TAPSEND_2
        ld      a, (__snd_tick)         ; MIC on
        ONEBITOUT
        POP     AF
        RET


  ENDIF
