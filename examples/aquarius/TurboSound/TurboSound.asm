        #include    "plus.inc"
        section code_user

        extern  AYREGSA
        extern  AYREGSB
        extern  PT3Player_DecodeA
        extern  PT3Player_DecodeB
        extern  PT3Player_IsDoneA
        extern  PT3Player_PauseA
        extern  PT3Player_PauseB
        extern  PT3Player_PlaySongA
        extern  PT3Player_PlaySongB
        extern  im1_init
        extern  add_raster_int
        extern  getk

        defc    NTSC_RELOAD=6

        public  _main
_main:
        call    im1_init
        ld      hl, ISR
        push    hl
        call    add_raster_int
        pop     af

        ld      hl, songA
        ld      a, 1                    ; 1 = no loop, 0 = loop
        call    PT3Player_PlaySongA
        ld      hl, songB
        ld      a, 1                    ; 1 = no loop, 0 = loop
        call    PT3Player_PlaySongB

        ; Wait for key release
waitRelease:
        halt
        call    getk
        or      a
        jr      nz, waitRelease

        ; Wait for player to finish
loop:
        halt
        call    PT3Player_IsDoneA
        jr      nz, finish

        ; Check for keyboard input
        call    getk
        or      a
        jr      z, loop

finish:
        ; Stop any playing music
        call    PT3Player_PauseA
        call    PT3Player_PauseB

        ; Wait for 2 interrupts to ensure we handle the 1/6 skip
        halt
        halt
        ret

ROUT:
        XOR     A
        LD      C, D
LOUT:
        OUT     (C), A
        LD      C, E
        OUTI
        LD      C, D
        INC     A
        CP      13
        JR      NZ, LOUT
        OUT     (C), A
        LD      A, (HL)
        AND     A
        RET     M
        LD      C, E
        OUT     (C), A
        RET

ISR:
        push    af
        ex      af, af'
        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy

        ; Drop 1 out of every 6 frames because we are NTSC
        ; and this tune was written for PAL (50 vs. 60 frames/sec)
        ld      hl, ntscCount
        dec     (hl)
        jr      z, skipping
noSkip:
        call    PT3Player_DecodeA
        call    PT3Player_DecodeB

        LD      HL, AYREGSA
        LD      DE, (IO_PSG1ADDR<<8)|IO_PSG1DATA
        call    ROUT

        LD      HL, AYREGSB
        LD      DE, (IO_PSG2ADDR<<8)|IO_PSG2DATA
        call    ROUT

skipFrame:
        ; Clear VBLANK interrupt
        ld      a, IRQ_VBLANK
        out     (IO_IRQSTAT), a

        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af
        ex      af, af'
        pop     af

        ei
        ret

skipping:
        ld      (hl), NTSC_RELOAD
        jr      skipFrame

        section data_user
ntscCount:
        db      NTSC_RELOAD

        section rodata_user
songA:
        binary  "Shiru - BallQuest2 (2006)-1.pt3"
songB:
        binary  "Shiru - BallQuest2 (2006)-2.pt3"
