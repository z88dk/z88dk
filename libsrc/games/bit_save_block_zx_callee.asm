;
;      ZX Spectrum style Tape save routine
;
;      int __CALLEE__ bit_save_block_zx_callee(void *addr, size_t len, unsigned char type)
;


        SECTION code_clib

        PUBLIC  bit_save_block_zx_callee
        PUBLIC  _bit_save_block_zx_callee
        PUBLIC  asm_bit_save_block_zx

        INCLUDE "games/games.inc"

        EXTERN  bit_open_di
        EXTERN  bit_close_ei
        EXTERN  __snd_tick

  IF    __CPU_GBZ80__||__CPU_INTEL__
bit_save_block_zx_callee:
_bit_save_block_zx_callee:
asm_bit_save_block_zx:
        ret
  ELSE

bit_save_block_zx_callee:
_bit_save_block_zx_callee:

        pop     hl
        pop     bc
        ld      a, c
        pop     de
        pop     bc
        push    hl

; enter : ix = addr
;         de = len
;          a = type

asm_bit_save_block_zx:

        push    af
        call    bit_open_di
        pop     af

        push    ix
        push    bc
        pop     ix

    IF  SOUND_ONEBIT_port>=256
        exx
        ld      bc, SOUND_ONEBIT_port
        exx
    ENDIF

        CALL    SA_BYTES

        pop     ix
        JP      bit_close_ei



SA_BYTES:
        LD      HL, $1F80               ; This constant will give a leader of about 5 seconds for a 'header'.
        BIT     7, A                    ; Jump forward if saving a header.
        JR      Z, SA_FLAG

        LD      HL, $0C98               ; This constant will give a leader of about 2 seconds for a program/data block.

SA_FLAG:
        EX      AF, AF'                 ; The flag is saved.
        INC     DE                      ; The 'length' is incremented and the 'base address' reduced to allow for the flag.
        DEC     IX

        ld      b, 2                    ; Give a short value to B to avoid jams in SA_LEADER
        ld      a, (__snd_tick)         ; MIC on

SA_LEADER:
        DJNZ    SA_LEADER               ; The main timing period.

        ONEBITOUT
        xor     SOUND_ONEBIT_mask       ; MIC on<>off

        LD      B, PLAY_DATA_LEAD       ; The main timing constant.
        DEC     L                       ; Decrease the low counter.
        JR      NZ, SA_LEADER           ; Jump back for another pulse.

        DEC     B
        DEC     H
        JP      P, SA_LEADER


; A sync pulse is now sent.
;-----------------------------
        LD      B, PLAY_DATA_SYNC1      ; MIC off for 667 T states from 'OUT to OUT'.
SA_SYNC_1:
        DJNZ    SA_SYNC_1

        ONEBITOUT                       ; MIC on

        ld      a, (__snd_tick)
        xor     SOUND_ONEBIT_mask       ; MIC off

        LD      B, PLAY_DATA_SYNC2      ; MIC on for 735 T States from 'OUT to OUT'.
SA_SYNC_2:
        DJNZ    SA_SYNC_2

        ONEBITOUT                       ; MIC off

        LD      B, PLAY_DATA_SYNC2+PLAY_DATA_BIAS
        ld      c, a                    ; 'MIC off'
        xor     SOUND_ONEBIT_mask


        EX      AF, AF'			; Fetch the flag and pass it to the L register for 'sending'.
        LD      L, A
        JP      SA_START                ; Jump forward into the saving loop.

;-----------------------------
SA_LOOP:
        LD      A, D                    ; The 'length' counter is tested and the jump taken when it has reached zero.
        OR      E
        JR      Z, SA_PARITY

        LD      L, (IX+$00)             ; Fetch the next byte that is to be saved.

SA_LOOP_PARITY:
        LD      A, H                    ; Fetch the current 'parity'.
        XOR     L                       ; Include the present byte.

SA_START:
        LD      H, A                    ; Restore the 'parity'. Note that on entry here the 'flag' value initialises 'parity'.
        ld      a, (__snd_tick)         ; MIC on

        SCF                             ; Set the carry flag. This will act as a 'marker' for the 8 bits of a byte.
        JP      SA_BYTE

;------------------------
SA_PARITY:
        LD      L, H
        JR      SA_LOOP_PARITY

;------------------------
SA_BIT_2:
        LD      A, C                    ;  Come here on the second pass and fetch 'MIC off and yellow'.
        BIT     7, B                    ; Set the zero flag to show 'second pass'.

SA_BIT_1:
        DJNZ    SA_BIT_1                ; The main timing loop; always 801 T states on a second pass.

        JR      NC, SA_OUT              ; Jump, taking the shorter path, if saving a '0'.

        LD      B, PLAY_DATA_BIT0+PLAY_DATA_BIAS
                                        ; However if saving a '1' then add 855 T states.

SA_SET:
        DJNZ    SA_SET

;------------------------
SA_OUT:
        ONEBITOUT

        LD      B, PLAY_DATA_BIT0
        JR      NZ, SA_BIT_2

        DEC     B

        XOR     A                       ; Clear the carry flag and set A to hold..
        ld      a, (__snd_tick)         ; ..MIC on

SA_BYTE:
        RL      L                       ; Move bit 7 to the carry and the 'marker' leftwards.
        JP      NZ, SA_BIT_1            ; Save the bit unless finished with the byte.

        DEC     DE
        INC     IX
        LD      B, PLAY_DATA_SYNC1      ; Set the timing constant for the first bit of the next byte.

;        LD      A,$7F			; Return (to SA_LD_RET) if the BREAK key is being pressed.
;        IN      A,($FE)
;        RRA
;        RET     NC

        LD      A, D                    ; test the 'counter' and jump back..
        INC     A                       ; ..even if it has reached zero (so as to send the 'parity' byte).
        JP      NZ, SA_LOOP

        LD      B, PLAY_DATA_SYNC2+PLAY_DATA_BIAS
                                        ; Exit when the 'counter' reaches +FFFF. But first give a short delay.

SA_DELAY:
        DJNZ    SA_DELAY
        RET


  ENDIF
