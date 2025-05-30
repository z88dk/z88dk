;;
;; Arkos 2 Player automatically generated for zx target in rom mode.
;; Do not modify this file directly.  Go instead to support/arkos directory
;; and regenerate the Player with the proper Makefile recipes!  - ZXjogv
;; (zx@jogv.es)
;;

        section code_sound_ay

        defc    asm_rom_PLY_AKG_INIT=PLY_AKG_INIT
        defc    asm_rom_PLY_AKG_STOP=PLY_AKG_STOP
        defc    asm_rom_PLY_AKG_PLAY=PLY_AKG_PLAY
        defc    asm_rom_PLY_AKG_INITSOUNDEFFECTS=PLY_AKG_INITSOUNDEFFECTS
        defc    asm_rom_PLY_AKG_PLAYSOUNDEFFECT=PLY_AKG_PLAYSOUNDEFFECT

        public  asm_rom_PLY_AKG_INIT
        public  asm_rom_PLY_AKG_STOP
        public  asm_rom_PLY_AKG_PLAY
        public  asm_rom_PLY_AKG_INITSOUNDEFFECTS
        public  asm_rom_PLY_AKG_PLAYSOUNDEFFECT

        defc    RASM_VERSION=ASMPC+2
        defc    PLY_AKG_SOUNDEFFECTDATA_OFFSETINVERTEDVOLUME=ASMPC+2
        defc    PLY_AKG_BITFORSOUND=ASMPC+2

PLY_AKG_START:

PLY_AKG_REMOVE_HOOKS:

PLY_AKG_REMOVE_STOP_SOUNDS:

PLY_AKG_REMOVE_FULL_INIT_CODE:

PLY_AKG_OFFSET1B:

PLY_AKG_OFFSET2B:

PLY_AKG_OPCODE_OR_A:
PLY_AKG_OPCODE_ADD_HL_BC_MSB:
        jp      PLY_AKG_INIT
        defc    PLY_AKG_SOUNDEFFECTDATA_OFFSETSPEED=ASMPC+1
        defc    PLY_AKG_BITFORNOISE=ASMPC+2
PLY_AKG_SOUNDEFFECTDATA_OFFSETCURRENTSTEP:
        jp      PLY_AKG_PLAY
        jp      PLY_AKG_INITTABLEJP_END

PLY_AKG_INITSOUNDEFFECTS:
PLY_AKG_OPCODE_ADD_HL_BC_LSB:
        ld      (PLY_AKG_PTSOUNDEFFECTTABLE), hl
        ret
PLY_AKG_PLAYSOUNDEFFECT:
        dec     a
        ld      hl, (PLY_AKG_PTSOUNDEFFECTTABLE)
        ld      e, a
        ld      d, 0
        add     hl, de
        add     hl, de
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        ld      a, (de)
        inc     de
        ex      af, af'
        ld      a, b
        ld      hl, PLY_AKG_CHANNEL1_SOUNDEFFECTDATA
        ld      b, 0
        defc    PLY_AKG_OPCODE_INC_HL=ASMPC+1
        sla     c
        sla     c
        sla     c
        add     hl, bc
        ld      (hl), e
        inc     hl
PLY_AKG_OPCODE_DEC_HL:
        ld      (hl), d
        inc     hl
        ld      (hl), a
        inc     hl
        ld      (hl), 0
        inc     hl
        ex      af, af'
        ld      (hl), a
        ret
PLY_AKG_STOPSOUNDEFFECTFROMCHANNEL:
        add     a, a
        add     a, a
        add     a, a
        ld      e, a
        ld      d, 0
        ld      hl, PLY_AKG_CHANNEL1_SOUNDEFFECTDATA
        add     hl, de
        ld      (hl), d
        inc     hl
        ld      (hl), d
PLY_AKG_OPCODE_SBC_HL_BC_LSB:
        ret
PLY_AKG_PLAYSOUNDEFFECTSSTREAM:
        rla
        rla
        ld      ix, PLY_AKG_CHANNEL1_SOUNDEFFECTDATA
        ld      iy, PLY_AKG_PSGREG8
        ld      hl, PLY_AKG_PSGREG01_INSTR
        exx
        ld      c, a
        call    PLY_AKG_PSES_PLAY
        ld      ix, PLY_AKG_CHANNEL2_SOUNDEFFECTDATA
        ld      iy, PLY_AKG_PSGREG9_10_INSTR
        exx
        ld      hl, PLY_AKG_PSGREG23_INSTR
        exx
        rr      c
        call    PLY_AKG_PSES_PLAY
        ld      ix, PLY_AKG_CHANNEL3_SOUNDEFFECTDATA
        ld      iy, PLY_AKG_PSGREG10
        exx
        ld      hl, PLY_AKG_PSGREG45_INSTR
        exx
        rr      c
        call    PLY_AKG_PSES_PLAY
        ld      a, c
        ret
PLY_AKG_PSES_PLAY:
        ld      l, (ix+0)
        ld      h, (ix+1)
        ld      a, l
        or      h
        ret     z
PLY_AKG_PSES_READFIRSTBYTE:
        ld      a, (hl)
        inc     hl
        ld      b, a
        rra
        jr      c, PLY_AKG_PSES_SOFTWAREORSOFTWAREANDHARDWARE
        rra
        jr      c, PLY_AKG_PSES_HARDWAREONLY
        rra
        jr      c, PLY_AKG_PSES_S_ENDORLOOP
        call    PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
        rl      b
        call    PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL
        set     2, c
        jr      PLY_AKG_PSES_SAVEPOINTERANDEXIT
PLY_AKG_PSES_S_ENDORLOOP:
        rra
        jr      c, PLY_AKG_PSES_S_LOOP
        xor     a
        ld      (ix+0), a
        ld      (ix+1), a
        ret
PLY_AKG_PSES_S_LOOP:
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        jr      PLY_AKG_PSES_READFIRSTBYTE
PLY_AKG_PSES_SAVEPOINTERANDEXIT:
        ld      a, (ix+3)
        cp      (ix+4)
        jr      c, PLY_AKG_PSES_NOTREACHED
        ld      (ix+3), 0
        db      221
        db      117
        db      0
        db      221
        db      116
        db      1
        ret
PLY_AKG_PSES_NOTREACHED:
        inc     (ix+3)
PLY_AKG_OPCODE_JP:
        ret
        defc    PLY_AKG_OPCODE_ADD_A_IMMEDIATE=ASMPC+2
PLY_AKG_PSES_HARDWAREONLY:
        call    PLY_AKG_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE
        set     2, c
        jr      PLY_AKG_PSES_SAVEPOINTERANDEXIT
PLY_AKG_PSES_SOFTWAREORSOFTWAREANDHARDWARE:
        rra
        jr      c, PLY_AKG_PSES_SOFTWAREANDHARDWARE
        call    PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
        rl      b
        call    PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL
PLY_AKG_OPCODE_SUB_IMMEDIATE:
        res     2, c
        call    PLY_AKG_PSES_READSOFTWAREPERIOD
        jr      PLY_AKG_PSES_SAVEPOINTERANDEXIT
PLY_AKG_PSES_SOFTWAREANDHARDWARE:
        call    PLY_AKG_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE
        call    PLY_AKG_PSES_READSOFTWAREPERIOD
        res     2, c
        jr      PLY_AKG_PSES_SAVEPOINTERANDEXIT
PLY_AKG_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE:
        rra
        jr      nc, PLY_AKG_PSES_H_AFTERRETRIG
        ld      d, a
        ld      a, 255
PLY_AKG_OPCODE_SBC_HL_BC_MSB:
        ld      (PLY_AKG_PSGREG13_OLDVALUE), a
        ld      a, d
PLY_AKG_PSES_H_AFTERRETRIG:
        and     7
        add     a, 8
        ld      (PLY_AKG_PSGREG13_INSTR), a
        rl      b
        call    PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL
        defc    PLY_AKG_OPCODE_SCF=ASMPC+2
        call    PLY_AKG_PSES_READHARDWAREPERIOD
SYNCHRO:
        ld      a, 16
        jp      PLY_AKG_PSES_MANAGEVOLUMEFROMA_HARD
PLY_AKG_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL:
        jr      c, PLY_AKG_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE
        set     5, c
        ret
PLY_AKG_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE:
        ld      a, (hl)
        ld      (PLY_AKG_PSGREG6_8_INSTR), a
        inc     hl
        res     5, c
        ret
PLY_AKG_PSES_READHARDWAREPERIOD:
        ld      a, (hl)
        ld      (PLY_AKG_PSGHARDWAREPERIOD_INSTR), a
        inc     hl
        ld      a, (hl)
        ld      (PLY_AKG_PSGHARDWAREPERIOD_INSTR+1), a
        inc     hl
        ret
PLY_AKG_PSES_READSOFTWAREPERIOD:
        ld      a, (hl)
        inc     hl
        exx
        ld      (hl), a
        inc     hl
        exx
        ld      a, (hl)
        inc     hl
        exx
        ld      (hl), a
        exx
        ret
PLY_AKG_PSES_MANAGEVOLUMEFROMA_FILTER4BITS:
        and     15
PLY_AKG_PSES_MANAGEVOLUMEFROMA_HARD:
        sub     (ix+2)
        jr      nc, PLY_AKG_PSES_MVFA_NOOVERFLOW
        xor     a
PLY_AKG_PSES_MVFA_NOOVERFLOW:
        ld      (iy+0), a
        ret
PLY_AKG_INIT:
        ld      de, 4
        add     hl, de
        ld      de, PLY_AKG_ARPEGGIOSTABLE
        ldi
        ldi
        ld      de, PLY_AKG_PITCHESTABLE
        ldi
        ldi
        ld      de, PLY_AKG_INSTRUMENTSTABLE
        ldi
        ldi
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      (PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS1), bc
        add     a, a
        ld      e, a
        ld      d, 0
        add     hl, de
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        ld      de, 5
        add     hl, de
        ld      de, PLY_AKG_CURRENTSPEED
        ldi
        ld      de, PLY_AKG_BASENOTEINDEX
        ldi
        ld      (PLY_AKG_READLINKER_PTLINKER), hl
        ld      hl, PLY_AKG_INITTABLE0
        ld      bc, 3584
        call    PLY_AKG_INIT_READWORDSANDFILL
        inc     c
        ld      hl, PLY_AKG_INITTABLE0_END
        ld      b, 3
        call    PLY_AKG_INIT_READWORDSANDFILL
        ld      hl, PLY_AKG_INITTABLE1_END
        ld      bc, 3328
        call    PLY_AKG_INIT_READWORDSANDFILL
        ld      hl, PLY_AKG_INITTABLEORA_END
        ld      bc, 3267
        call    PLY_AKG_INIT_READWORDSANDFILL
        ld      a, 255
        ld      (PLY_AKG_PSGREG13_OLDVALUE), a
        ld      hl, (PLY_AKG_INSTRUMENTSTABLE)
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        ex      de, hl
        inc     hl
        ld      (PLY_AKG_EMPTYINSTRUMENTDATAPT), hl
        ld      (PLY_AKG_CHANNEL1_PTINSTRUMENT), hl
        ld      (PLY_AKG_CHANNEL2_PTINSTRUMENT), hl
        ld      (PLY_AKG_CHANNEL3_PTINSTRUMENT), hl
        xor     a
        ld      (PLY_AKG_CHANNEL1_PITCHTRACK+1), a
        ld      hl, PLY_AKG_CHANNEL1_PITCHTRACKINTEGERADDORSUBRETURN
        ld      (PLY_AKG_CHANNEL1_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS+1), hl
        ld      hl, PLY_AKG_CHANNEL1_PITCHTRACKADDORSBC_16BITSRETURN
        ld      (PLY_AKG_CHANNEL1_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS+1), hl
        ld      hl, PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUERETURNAFTERJP
        ld      (PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUERETURNJP+1), hl
        ld      (PLY_AKG_CHANNEL2_PITCHTRACK+1), a
        ld      hl, PLY_AKG_CHANNEL2_PITCHTRACKINTEGERADDORSUBRETURN
        ld      (PLY_AKG_CHANNEL2_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS+1), hl
        ld      hl, PLY_AKG_CHANNEL2_PITCHTRACKADDORSBC_16BITSRETURN
        ld      (PLY_AKG_CHANNEL2_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS+1), hl
        ld      hl, PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUERETURNAFTERJP
        ld      (PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUERETURNJP+1), hl
        ld      (PLY_AKG_CHANNEL3_PITCHTRACK+1), a
        ld      hl, PLY_AKG_CHANNEL3_PITCHTRACKINTEGERADDORSUBRETURN
        ld      (PLY_AKG_CHANNEL3_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS+1), hl
        ld      hl, PLY_AKG_CHANNEL3_PITCHTRACKADDORSBC_16BITSRETURN
        ld      (PLY_AKG_CHANNEL3_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS+1), hl
        ld      hl, PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUERETURNAFTERJP
        ld      (PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUERETURNJP+1), hl
        ld      hl, 0
        ld      (PLY_AKG_CHANNEL1_SOUNDEFFECTDATA), hl
        ld      (PLY_AKG_CHANNEL2_SOUNDEFFECTDATA), hl
        ld      (PLY_AKG_CHANNEL3_SOUNDEFFECTDATA), hl
        ret
PLY_AKG_INIT_READWORDSANDFILL_LOOP:
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      a, c
        ld      (de), a
PLY_AKG_INIT_READWORDSANDFILL:
        djnz    PLY_AKG_INIT_READWORDSANDFILL_LOOP
        ret
PLY_AKG_INITTABLE0:
        dw      PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL
        dw      PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER
        dw      PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL
        dw      PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER
        dw      PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL
        dw      PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER
        dw      PLY_AKG_CHANNEL1_PITCH
        dw      PLY_AKG_CHANNEL1_PITCH+1
        dw      PLY_AKG_CHANNEL2_PITCH
        dw      PLY_AKG_CHANNEL2_PITCH+1
        dw      PLY_AKG_CHANNEL3_PITCH
        dw      PLY_AKG_CHANNEL3_PITCH+1
        dw      PLY_AKG_CHANNEL_RE_READNEXTEFFECTINBLOCK

PLY_AKG_INITTABLE0_END:
PLY_AKG_INITTABLE1:
        dw      PLY_AKG_PATTERNDECREASINGHEIGHT
        dw      PLY_AKG_TICKDECREASINGCOUNTER

PLY_AKG_INITTABLE1_END:
PLY_AKG_INITTABLEORA:
        dw      PLY_AKG_CHANNEL1_ISVOLUMESLIDE
        dw      PLY_AKG_CHANNEL2_ISVOLUMESLIDE
        dw      PLY_AKG_CHANNEL3_ISVOLUMESLIDE
        dw      PLY_AKG_CHANNEL1_ISARPEGGIOTABLE
        dw      PLY_AKG_CHANNEL2_ISARPEGGIOTABLE
        dw      PLY_AKG_CHANNEL3_ISARPEGGIOTABLE
        dw      PLY_AKG_CHANNEL1_ISPITCHTABLE
        dw      PLY_AKG_CHANNEL2_ISPITCHTABLE
        dw      PLY_AKG_CHANNEL3_ISPITCHTABLE
        dw      PLY_AKG_CHANNEL1_ISPITCH
        dw      PLY_AKG_CHANNEL2_ISPITCH
        dw      PLY_AKG_CHANNEL3_ISPITCH

PLY_AKG_INITTABLEORA_END:
PLY_AKG_INITTABLEJP:
        dw      PLY_AKG_CHANNEL1_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS
        dw      PLY_AKG_CHANNEL2_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS
        dw      PLY_AKG_CHANNEL3_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS
        dw      PLY_AKG_CHANNEL1_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS
        dw      PLY_AKG_CHANNEL2_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS
        dw      PLY_AKG_CHANNEL3_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS
        dw      PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUERETURNJP
        dw      PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUERETURNJP
        dw      PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUERETURNJP
        dw      PLY_AKG_CHANNEL_READEFFECTS_ENDJUMPINSTRANDADDRESS
        dw      PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS

PLY_AKG_INITTABLEJP_END:
PLY_AKG_STOP:
        ld      (PLY_AKG_SAVESP), sp
        xor     a
        ld      l, a
        ld      h, a
        ld      (PLY_AKG_PSGREG8), a
        ld      (PLY_AKG_PSGREG9_10_INSTR), hl
        ld      a, 63
        jp      PLY_AKG_SENDPSGREGISTERS
PLY_AKG_PLAY:
        ld      (PLY_AKG_SAVESP), sp
        xor     a
        ld      (PLY_AKG_EVENT), a
        ld      a, (PLY_AKG_TICKDECREASINGCOUNTER)
        dec     a
        jp      nz, PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS
        ld      a, (PLY_AKG_PATTERNDECREASINGHEIGHT)
        dec     a
        jr      nz, PLY_AKG_SETCURRENTLINEBEFOREREADLINE
PLY_AKG_READLINKER:
        ld      sp, (PLY_AKG_READLINKER_PTLINKER)
        pop     hl
        ld      a, l
        or      h
        jr      nz, PLY_AKG_READLINKER_NOLOOP
        pop     hl
        ld      sp, hl
        pop     hl
PLY_AKG_READLINKER_NOLOOP:
        ld      (PLY_AKG_CHANNEL1_PTTRACK), hl
        pop     hl
        ld      (PLY_AKG_CHANNEL2_PTTRACK), hl
        pop     hl
        ld      (PLY_AKG_CHANNEL3_PTTRACK), hl
        pop     hl
        ld      (PLY_AKG_READLINKER_PTLINKER), sp
        ld      sp, hl
        pop     hl
        ld      c, l
        ld      a, h
        ld      (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS), a
        pop     hl
        ld      a, l
        ld      (PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS), a
        ld      a, h
        ld      (PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS), a
        pop     hl
        ld      (PLY_AKG_SPEEDTRACK_PTTRACK), hl
        pop     hl
        ld      (PLY_AKG_EVENTTRACK_PTTRACK), hl
        xor     a
        ld      (PLY_AKG_SPEEDTRACK_WAITCOUNTER), a
        ld      (PLY_AKG_EVENTTRACK_WAITCOUNTER), a
        ld      (PLY_AKG_CHANNEL1_WAITCOUNTER), a
        ld      (PLY_AKG_CHANNEL2_WAITCOUNTER), a
        ld      (PLY_AKG_CHANNEL3_WAITCOUNTER), a
        ld      a, c
PLY_AKG_SETCURRENTLINEBEFOREREADLINE:
        ld      (PLY_AKG_PATTERNDECREASINGHEIGHT), a
PLY_AKG_READLINE:
        ld      a, (PLY_AKG_SPEEDTRACK_WAITCOUNTER)
        sub     1
        jr      nc, PLY_AKG_SPEEDTRACK_MUSTWAIT
        ld      hl, (PLY_AKG_SPEEDTRACK_PTTRACK)
        ld      a, (hl)
        inc     hl
        srl     a
        jr      c, PLY_AKG_SPEEDTRACK_STOREPOINTERANDWAITCOUNTER
        jr      nz, PLY_AKG_SPEEDTRACK_NORMALVALUE
        ld      a, (hl)
        inc     hl
PLY_AKG_SPEEDTRACK_NORMALVALUE:
        ld      (PLY_AKG_CURRENTSPEED), a
        xor     a
PLY_AKG_SPEEDTRACK_STOREPOINTERANDWAITCOUNTER:
        ld      (PLY_AKG_SPEEDTRACK_PTTRACK), hl
PLY_AKG_SPEEDTRACK_MUSTWAIT:
        ld      (PLY_AKG_SPEEDTRACK_WAITCOUNTER), a
PLY_AKG_SPEEDTRACK_END:
        ld      a, (PLY_AKG_EVENTTRACK_WAITCOUNTER)
        sub     1
        jr      nc, PLY_AKG_EVENTTRACK_MUSTWAIT
        ld      hl, (PLY_AKG_EVENTTRACK_PTTRACK)
        ld      a, (hl)
        inc     hl
        srl     a
        jr      c, PLY_AKG_EVENTTRACK_STOREPOINTERANDWAITCOUNTER
        jr      nz, PLY_AKG_EVENTTRACK_NORMALVALUE
        ld      a, (hl)
        inc     hl
PLY_AKG_EVENTTRACK_NORMALVALUE:
        ld      (PLY_AKG_EVENT), a
        xor     a
PLY_AKG_EVENTTRACK_STOREPOINTERANDWAITCOUNTER:
        ld      (PLY_AKG_EVENTTRACK_PTTRACK), hl
PLY_AKG_EVENTTRACK_MUSTWAIT:
        ld      (PLY_AKG_EVENTTRACK_WAITCOUNTER), a
PLY_AKG_EVENTTRACK_END:
        ld      a, (PLY_AKG_CHANNEL1_WAITCOUNTER)
        sub     1
        jr      c, PLY_AKG_CHANNEL1_READTRACK
        ld      (PLY_AKG_CHANNEL1_WAITCOUNTER), a
        jp      PLY_AKG_CHANNEL1_READCELLEND
PLY_AKG_CHANNEL1_READTRACK:
        ld      hl, (PLY_AKG_CHANNEL1_PTTRACK)
        ld      c, (hl)
        inc     hl
        ld      a, c
        and     63
        cp      60
        jr      c, PLY_AKG_CHANNEL1_NOTE
        sub     60
        jp      z, PLY_AKG_CHANNEL1_MAYBEEFFECTS
        dec     a
        jr      z, PLY_AKG_CHANNEL1_WAIT
        dec     a
        jr      z, PLY_AKG_CHANNEL1_SMALLWAIT
        ld      a, (hl)
        inc     hl
        jr      PLY_AKG_CHANNEL1_AFTERNOTEKNOWN
PLY_AKG_CHANNEL1_SMALLWAIT:
        ld      a, c
        rlca
        rlca
        and     3
        inc     a
        ld      (PLY_AKG_CHANNEL1_WAITCOUNTER), a
        jr      PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_WAIT:
        ld      a, (hl)
        ld      (PLY_AKG_CHANNEL1_WAITCOUNTER), a
        inc     hl
        jr      PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_SAMEINSTRUMENT:
        ld      de, (PLY_AKG_CHANNEL1_PTBASEINSTRUMENT)
        ld      (PLY_AKG_CHANNEL1_PTINSTRUMENT), de
        jr      PLY_AKG_CHANNEL1_AFTERINSTRUMENT
PLY_AKG_CHANNEL1_NOTE:
        ld      b, a
        ld      a, (PLY_AKG_BASENOTEINDEX)
        add     a, b
PLY_AKG_CHANNEL1_AFTERNOTEKNOWN:
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS)
        add     a, b
        ld      (PLY_AKG_CHANNEL1_TRACKNOTE), a
        rl      c
        jr      nc, PLY_AKG_CHANNEL1_SAMEINSTRUMENT
        ld      a, (hl)
        inc     hl
        exx
        ld      l, a
        ld      h, 0
        add     hl, hl
        ld      de, (PLY_AKG_INSTRUMENTSTABLE)
        add     hl, de
        ld      sp, hl
        pop     hl
        ld      a, (hl)
        inc     hl
        ld      (PLY_AKG_CHANNEL1_INSTRUMENTORIGINALSPEED), a
        ld      (PLY_AKG_CHANNEL1_PTINSTRUMENT), hl
        ld      (PLY_AKG_CHANNEL1_PTBASEINSTRUMENT), hl
        exx
PLY_AKG_CHANNEL1_AFTERINSTRUMENT:
        ex      de, hl
        xor     a
        ld      l, a
        ld      h, a
        ld      (PLY_AKG_CHANNEL1_PITCH), hl
        ld      (PLY_AKG_CHANNEL1_ARPEGGIOTABLECURRENTSTEP), a
        ld      (PLY_AKG_CHANNEL1_PITCHTABLECURRENTSTEP), a
        ld      (PLY_AKG_CHANNEL1_INSTRUMENTSTEP), a
        ld      a, (PLY_AKG_CHANNEL1_INSTRUMENTORIGINALSPEED)
        ld      (PLY_AKG_CHANNEL1_INSTRUMENTSPEED), a
        ld      a, 0
        ld      (PLY_AKG_CHANNEL1_ISPITCH), a
        ld      a, (PLY_AKG_CHANNEL1_ARPEGGIOBASESPEED)
        ld      (PLY_AKG_CHANNEL1_ARPEGGIOTABLESPEED), a
        ld      a, (PLY_AKG_CHANNEL1_PITCHBASESPEED)
        ld      (PLY_AKG_CHANNEL1_PITCHTABLESPEED), a
        ld      hl, (PLY_AKG_CHANNEL1_ARPEGGIOTABLEBASE)
        ld      (PLY_AKG_CHANNEL1_ARPEGGIOTABLE), hl
        ld      hl, (PLY_AKG_CHANNEL1_PITCHTABLEBASE)
        ld      (PLY_AKG_CHANNEL1_PITCHTABLE), hl
        ex      de, hl
        rl      c
        jp      c, PLY_AKG_CHANNEL1_READEFFECTS
PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER:
        ld      (PLY_AKG_CHANNEL1_PTTRACK), hl
PLY_AKG_CHANNEL1_READCELLEND:
        ld      a, (PLY_AKG_CHANNEL2_WAITCOUNTER)
        sub     1
        jr      c, PLY_AKG_CHANNEL2_READTRACK
        ld      (PLY_AKG_CHANNEL2_WAITCOUNTER), a
        jp      PLY_AKG_CHANNEL2_READCELLEND
PLY_AKG_CHANNEL2_READTRACK:
        ld      hl, (PLY_AKG_CHANNEL2_PTTRACK)
        ld      c, (hl)
        inc     hl
        ld      a, c
        and     63
        cp      60
        jr      c, PLY_AKG_CHANNEL2_NOTE
        sub     60
        jp      z, PLY_AKG_CHANNEL1_READEFFECTSEND
        dec     a
        jr      z, PLY_AKG_CHANNEL2_WAIT
        dec     a
        jr      z, PLY_AKG_CHANNEL2_SMALLWAIT
        ld      a, (hl)
        inc     hl
        jr      PLY_AKG_CHANNEL2_AFTERNOTEKNOWN
PLY_AKG_CHANNEL2_SMALLWAIT:
        ld      a, c
        rlca
        rlca
        and     3
        inc     a
        ld      (PLY_AKG_CHANNEL2_WAITCOUNTER), a
        jr      PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_WAIT:
        ld      a, (hl)
        ld      (PLY_AKG_CHANNEL2_WAITCOUNTER), a
        inc     hl
        jr      PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_SAMEINSTRUMENT:
        ld      de, (PLY_AKG_CHANNEL2_PTBASEINSTRUMENT)
        ld      (PLY_AKG_CHANNEL2_PTINSTRUMENT), de
        jr      PLY_AKG_CHANNEL2_AFTERINSTRUMENT
PLY_AKG_CHANNEL2_NOTE:
        ld      b, a
        ld      a, (PLY_AKG_BASENOTEINDEX)
        add     a, b
PLY_AKG_CHANNEL2_AFTERNOTEKNOWN:
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS)
        add     a, b
        ld      (PLY_AKG_CHANNEL2_TRACKNOTE), a
        rl      c
        jr      nc, PLY_AKG_CHANNEL2_SAMEINSTRUMENT
        ld      a, (hl)
        inc     hl
        exx
        ld      e, a
        ld      d, 0
        ld      hl, (PLY_AKG_INSTRUMENTSTABLE)
        add     hl, de
        add     hl, de
        ld      sp, hl
        pop     hl
        ld      a, (hl)
        inc     hl
        ld      (PLY_AKG_CHANNEL2_INSTRUMENTORIGINALSPEED), a
        ld      (PLY_AKG_CHANNEL2_PTINSTRUMENT), hl
        ld      (PLY_AKG_CHANNEL2_PTBASEINSTRUMENT), hl
        exx
PLY_AKG_CHANNEL2_AFTERINSTRUMENT:
        ex      de, hl
        xor     a
        ld      l, a
        ld      h, a
        ld      (PLY_AKG_CHANNEL2_PITCH), hl
        ld      (PLY_AKG_CHANNEL2_ARPEGGIOTABLECURRENTSTEP), a
        ld      (PLY_AKG_CHANNEL2_PITCHTABLECURRENTSTEP), a
        ld      (PLY_AKG_CHANNEL2_INSTRUMENTSTEP), a
        ld      a, (PLY_AKG_CHANNEL2_INSTRUMENTORIGINALSPEED)
        ld      (PLY_AKG_CHANNEL2_INSTRUMENTSPEED), a
        ld      a, 0
        ld      (PLY_AKG_CHANNEL2_ISPITCH), a
        ld      a, (PLY_AKG_CHANNEL2_ARPEGGIOBASESPEED)
        ld      (PLY_AKG_CHANNEL2_ARPEGGIOTABLESPEED), a
        ld      a, (PLY_AKG_CHANNEL2_PITCHBASESPEED)
        ld      (PLY_AKG_CHANNEL2_PITCHTABLESPEED), a
        ld      hl, (PLY_AKG_CHANNEL2_ARPEGGIOTABLEBASE)
        ld      (PLY_AKG_CHANNEL2_ARPEGGIOTABLE), hl
        ld      hl, (PLY_AKG_CHANNEL2_PITCHTABLEBASE)
        ld      (PLY_AKG_CHANNEL2_PITCHTABLE), hl
        ex      de, hl
        rl      c
        jp      c, PLY_AKG_CHANNEL2_READEFFECTS
PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER:
        ld      (PLY_AKG_CHANNEL2_PTTRACK), hl
PLY_AKG_CHANNEL2_READCELLEND:
        ld      a, (PLY_AKG_CHANNEL3_WAITCOUNTER)
        sub     1
        jr      c, PLY_AKG_CHANNEL3_READTRACK
        ld      (PLY_AKG_CHANNEL3_WAITCOUNTER), a
        jp      PLY_AKG_CHANNEL3_READCELLEND
PLY_AKG_CHANNEL3_READTRACK:
        ld      hl, (PLY_AKG_CHANNEL3_PTTRACK)
        ld      c, (hl)
        inc     hl
        ld      a, c
        and     63
        cp      60
        jr      c, PLY_AKG_CHANNEL3_NOTE
        sub     60
        jp      z, PLY_AKG_CHANNEL2_READEFFECTSEND
        dec     a
        jr      z, PLY_AKG_CHANNEL3_WAIT
        dec     a
        jr      z, PLY_AKG_CHANNEL3_SMALLWAIT
        ld      a, (hl)
        inc     hl
        jr      PLY_AKG_CHANNEL3_AFTERNOTEKNOWN
PLY_AKG_CHANNEL3_SMALLWAIT:
        ld      a, c
        rlca
        rlca
        and     3
        inc     a
        ld      (PLY_AKG_CHANNEL3_WAITCOUNTER), a
        jr      PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_WAIT:
        ld      a, (hl)
        ld      (PLY_AKG_CHANNEL3_WAITCOUNTER), a
        inc     hl
        jr      PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_SAMEINSTRUMENT:
        ld      de, (PLY_AKG_CHANNEL3_PTBASEINSTRUMENT)
        ld      (PLY_AKG_CHANNEL3_PTINSTRUMENT), de
        jr      PLY_AKG_CHANNEL3_AFTERINSTRUMENT
PLY_AKG_CHANNEL3_NOTE:
        ld      b, a
        ld      a, (PLY_AKG_BASENOTEINDEX)
        add     a, b
PLY_AKG_CHANNEL3_AFTERNOTEKNOWN:
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS)
        add     a, b
        ld      (PLY_AKG_CHANNEL3_TRACKNOTE), a
        rl      c
        jr      nc, PLY_AKG_CHANNEL3_SAMEINSTRUMENT
        ld      a, (hl)
        inc     hl
        exx
        ld      e, a
        ld      d, 0
        ld      hl, (PLY_AKG_INSTRUMENTSTABLE)
        add     hl, de
        add     hl, de
        ld      sp, hl
        pop     hl
        ld      a, (hl)
        inc     hl
        ld      (PLY_AKG_CHANNEL3_INSTRUMENTORIGINALSPEED), a
        ld      (PLY_AKG_CHANNEL3_PTINSTRUMENT), hl
        ld      (PLY_AKG_CHANNEL3_PTBASEINSTRUMENT), hl
        exx
PLY_AKG_CHANNEL3_AFTERINSTRUMENT:
        ex      de, hl
        xor     a
        ld      l, a
        ld      h, a
        ld      (PLY_AKG_CHANNEL3_PITCH), hl
        ld      (PLY_AKG_CHANNEL3_ARPEGGIOTABLECURRENTSTEP), a
        ld      (PLY_AKG_CHANNEL3_PITCHTABLECURRENTSTEP), a
        ld      (PLY_AKG_CHANNEL3_INSTRUMENTSTEP), a
        ld      a, (PLY_AKG_CHANNEL3_INSTRUMENTORIGINALSPEED)
        ld      (PLY_AKG_CHANNEL3_INSTRUMENTSPEED), a
        ld      a, 0
        ld      (PLY_AKG_CHANNEL3_ISPITCH), a
        ld      a, (PLY_AKG_CHANNEL3_ARPEGGIOBASESPEED)
        ld      (PLY_AKG_CHANNEL3_ARPEGGIOTABLESPEED), a
        ld      a, (PLY_AKG_CHANNEL3_PITCHBASESPEED)
        ld      (PLY_AKG_CHANNEL3_PITCHTABLESPEED), a
        ld      hl, (PLY_AKG_CHANNEL3_ARPEGGIOTABLEBASE)
        ld      (PLY_AKG_CHANNEL3_ARPEGGIOTABLE), hl
        ld      hl, (PLY_AKG_CHANNEL3_PITCHTABLEBASE)
        ld      (PLY_AKG_CHANNEL3_PITCHTABLE), hl
        ex      de, hl
        rl      c
        jp      c, PLY_AKG_CHANNEL3_READEFFECTS
PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER:
        ld      (PLY_AKG_CHANNEL3_PTTRACK), hl
PLY_AKG_CHANNEL3_READCELLEND:
        ld      a, (PLY_AKG_CURRENTSPEED)
PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS:
        ld      (PLY_AKG_TICKDECREASINGCOUNTER), a
        ld      hl, (PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL)
        ld      a, (PLY_AKG_CHANNEL1_ISVOLUMESLIDE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL1_VOLUMESLIDE_END
        ld      de, (PLY_AKG_CHANNEL1_VOLUMESLIDEVALUE)
        add     hl, de
        bit     7, h
        jr      z, PLY_AKG_CHANNEL1_VOLUMENOTOVERFLOW
        ld      h, 0
        jr      PLY_AKG_CHANNEL1_VOLUMESETAGAIN
PLY_AKG_CHANNEL1_VOLUMENOTOVERFLOW:
        ld      a, h
        cp      16
        jr      c, PLY_AKG_CHANNEL1_VOLUMESETAGAIN
        ld      h, 15
PLY_AKG_CHANNEL1_VOLUMESETAGAIN:
        ld      (PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL), hl
PLY_AKG_CHANNEL1_VOLUMESLIDE_END:
        ld      a, h
        ld      (PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME), a
        ld      c, 0
        ld      a, (PLY_AKG_CHANNEL1_ISARPEGGIOTABLE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL1_ARPEGGIOTABLE_END
        ld      hl, (PLY_AKG_CHANNEL1_ARPEGGIOTABLE)
        ld      a, (hl)
        cp      128
        jr      nz, PLY_AKG_CHANNEL1_ARPEGGIOTABLE_AFTERLOOPTEST
        inc     hl
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        ld      a, (hl)
PLY_AKG_CHANNEL1_ARPEGGIOTABLE_AFTERLOOPTEST:
        ld      c, a
        ld      a, (PLY_AKG_CHANNEL1_ARPEGGIOTABLESPEED)
        ld      d, a
        ld      a, (PLY_AKG_CHANNEL1_ARPEGGIOTABLECURRENTSTEP)
        inc     a
        cp      d
        jr      c, PLY_AKG_CHANNEL1_ARPEGGIOTABLE_BEFOREEND_SAVESTEP
        inc     hl
        ld      (PLY_AKG_CHANNEL1_ARPEGGIOTABLE), hl
        xor     a
PLY_AKG_CHANNEL1_ARPEGGIOTABLE_BEFOREEND_SAVESTEP:
        ld      (PLY_AKG_CHANNEL1_ARPEGGIOTABLECURRENTSTEP), a
PLY_AKG_CHANNEL1_ARPEGGIOTABLE_END:
        ld      de, 0
        ld      a, (PLY_AKG_CHANNEL1_ISPITCHTABLE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL1_PITCHTABLE_END
        ld      sp, (PLY_AKG_CHANNEL1_PITCHTABLE)
        pop     de
        pop     hl
        ld      a, (PLY_AKG_CHANNEL1_PITCHTABLESPEED)
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL1_PITCHTABLECURRENTSTEP)
        inc     a
        cp      b
        jr      c, PLY_AKG_CHANNEL1_PITCHTABLE_BEFOREEND_SAVESTEP
        ld      (PLY_AKG_CHANNEL1_PITCHTABLE), hl
        xor     a
PLY_AKG_CHANNEL1_PITCHTABLE_BEFOREEND_SAVESTEP:
        ld      (PLY_AKG_CHANNEL1_PITCHTABLECURRENTSTEP), a
PLY_AKG_CHANNEL1_PITCHTABLE_END:
        ld      hl, (PLY_AKG_CHANNEL1_PITCH)
        ld      a, (PLY_AKG_CHANNEL1_ISPITCH)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL1_PITCH_END
        db      221
        db      105
        ld      bc, (PLY_AKG_CHANNEL1_PITCHTRACK)
        or      a
        jp      PLY_AKG_CHANNEL1_PITCHTRACKADDORSBC_16BITS
PLY_AKG_CHANNEL1_PITCHTRACKADDORSBC_16BITSRETURN:
        ld      a, (PLY_AKG_CHANNEL1_PITCHTRACKDECIMALVALUE)
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL1_PITCHTRACKDECIMALCOUNTER)
        jp      PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUE
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUERETURNAFTERJP:
        ld      (PLY_AKG_CHANNEL1_PITCHTRACKDECIMALCOUNTER), a
        jr      nc, PLY_AKG_CHANNEL1_PITCHTRACKINTEGERADDORSUBRETURN
        jp      PLY_AKG_CHANNEL1_PITCHTRACKINTEGERADDORSUB

PLY_AKG_CHANNEL1_PITCHTRACKINTEGERADDORSUBRETURN:
PLY_AKG_CHANNEL1_PITCHNOCARRY:
        ld      (PLY_AKG_CHANNEL1_PITCH), hl
        ld      a, (PLY_AKG_CHANNEL1_GLIDEDIRECTION)
        or      a
        jr      z, PLY_AKG_CHANNEL1_GLIDE_END
        ld      (PLY_AKG_CHANNEL1_GLIDE_SAVEHL), hl
        ld      c, l
        ld      b, h
        ex      af, af'
        ld      a, (PLY_AKG_CHANNEL1_TRACKNOTE)
        add     a, a
        ld      l, a
        ex      af, af'
        ld      h, 0
        ld      sp, PLY_AKG_PERIODTABLE
        add     hl, sp
        ld      sp, hl
        pop     hl
        dec     sp
        dec     sp
        add     hl, bc
        ld      bc, (PLY_AKG_CHANNEL1_GLIDETOREACH)
        rra
        jr      nc, PLY_AKG_CHANNEL1_GLIDEDOWNCHECK
        or      a
        sbc     hl, bc
        jr      nc, PLY_AKG_CHANNEL1_GLIDE_BEFOREEND
        jr      PLY_AKG_CHANNEL1_GLIDEOVER
PLY_AKG_CHANNEL1_GLIDEDOWNCHECK:
        sbc     hl, bc
        jr      c, PLY_AKG_CHANNEL1_GLIDE_BEFOREEND
PLY_AKG_CHANNEL1_GLIDEOVER:
        ld      l, c
        ld      h, b
        pop     bc
        or      a
        sbc     hl, bc
        ld      (PLY_AKG_CHANNEL1_PITCH), hl
        ld      a, 0
        ld      (PLY_AKG_CHANNEL1_ISPITCH), a
        jr      PLY_AKG_CHANNEL1_GLIDE_END
PLY_AKG_CHANNEL1_GLIDE_BEFOREEND:
        ld      hl, (PLY_AKG_CHANNEL1_GLIDE_SAVEHL)
PLY_AKG_CHANNEL1_GLIDE_END:
        db      221
        db      77
PLY_AKG_CHANNEL1_PITCH_END:
        add     hl, de
        ld      (PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH), hl
        ld      a, c
        ld      (PLY_AKG_CHANNEL1_GENERATEDCURRENTARPNOTE), a
        ld      hl, (PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL)
        ld      a, (PLY_AKG_CHANNEL2_ISVOLUMESLIDE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL2_VOLUMESLIDE_END
        ld      de, (PLY_AKG_CHANNEL2_VOLUMESLIDEVALUE)
        add     hl, de
        bit     7, h
        jr      z, PLY_AKG_CHANNEL2_VOLUMENOTOVERFLOW
        ld      h, 0
        jr      PLY_AKG_CHANNEL2_VOLUMESETAGAIN
PLY_AKG_CHANNEL2_VOLUMENOTOVERFLOW:
        ld      a, h
        cp      16
        jr      c, PLY_AKG_CHANNEL2_VOLUMESETAGAIN
        ld      h, 15
PLY_AKG_CHANNEL2_VOLUMESETAGAIN:
        ld      (PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL), hl
PLY_AKG_CHANNEL2_VOLUMESLIDE_END:
        ld      a, h
        ld      (PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME), a
        ld      c, 0
        ld      a, (PLY_AKG_CHANNEL2_ISARPEGGIOTABLE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL2_ARPEGGIOTABLE_END
        ld      hl, (PLY_AKG_CHANNEL2_ARPEGGIOTABLE)
        ld      a, (hl)
        cp      128
        jr      nz, PLY_AKG_CHANNEL2_ARPEGGIOTABLE_AFTERLOOPTEST
        inc     hl
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        ld      a, (hl)
PLY_AKG_CHANNEL2_ARPEGGIOTABLE_AFTERLOOPTEST:
        ld      c, a
        ld      a, (PLY_AKG_CHANNEL2_ARPEGGIOTABLESPEED)
        ld      d, a
        ld      a, (PLY_AKG_CHANNEL2_ARPEGGIOTABLECURRENTSTEP)
        inc     a
        cp      d
        jr      c, PLY_AKG_CHANNEL2_ARPEGGIOTABLE_BEFOREEND_SAVESTEP
        inc     hl
        ld      (PLY_AKG_CHANNEL2_ARPEGGIOTABLE), hl
        xor     a
PLY_AKG_CHANNEL2_ARPEGGIOTABLE_BEFOREEND_SAVESTEP:
        ld      (PLY_AKG_CHANNEL2_ARPEGGIOTABLECURRENTSTEP), a
PLY_AKG_CHANNEL2_ARPEGGIOTABLE_END:
        ld      de, 0
        ld      a, (PLY_AKG_CHANNEL2_ISPITCHTABLE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL2_PITCHTABLE_END
        ld      sp, (PLY_AKG_CHANNEL2_PITCHTABLE)
        pop     de
        pop     hl
        ld      a, (PLY_AKG_CHANNEL2_PITCHTABLESPEED)
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL2_PITCHTABLECURRENTSTEP)
        inc     a
        cp      b
        jr      c, PLY_AKG_CHANNEL2_PITCHTABLE_BEFOREEND_SAVESTEP
        ld      (PLY_AKG_CHANNEL2_PITCHTABLE), hl
        xor     a
PLY_AKG_CHANNEL2_PITCHTABLE_BEFOREEND_SAVESTEP:
        ld      (PLY_AKG_CHANNEL2_PITCHTABLECURRENTSTEP), a
PLY_AKG_CHANNEL2_PITCHTABLE_END:
        ld      hl, (PLY_AKG_CHANNEL2_PITCH)
        ld      a, (PLY_AKG_CHANNEL2_ISPITCH)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL2_PITCH_END
        db      221
        db      105
        ld      bc, (PLY_AKG_CHANNEL2_PITCHTRACK)
        or      a
        jp      PLY_AKG_CHANNEL2_PITCHTRACKADDORSBC_16BITS
PLY_AKG_CHANNEL2_PITCHTRACKADDORSBC_16BITSRETURN:
        ld      a, (PLY_AKG_CHANNEL2_PITCHTRACKDECIMALVALUE)
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL2_PITCHTRACKDECIMALCOUNTER)
        jp      PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUE
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUERETURNAFTERJP:
        ld      (PLY_AKG_CHANNEL2_PITCHTRACKDECIMALCOUNTER), a
        jr      nc, PLY_AKG_CHANNEL2_PITCHTRACKINTEGERADDORSUBRETURN
        jp      PLY_AKG_CHANNEL2_PITCHTRACKINTEGERADDORSUB

PLY_AKG_CHANNEL2_PITCHTRACKINTEGERADDORSUBRETURN:
PLY_AKG_CHANNEL2_PITCHNOCARRY:
        ld      (PLY_AKG_CHANNEL2_PITCH), hl
        ld      a, (PLY_AKG_CHANNEL2_GLIDEDIRECTION)
        or      a
        jr      z, PLY_AKG_CHANNEL2_GLIDE_END
        ld      (PLY_AKG_CHANNEL2_GLIDE_SAVEHL), hl
        ld      c, l
        ld      b, h
        ex      af, af'
        ld      a, (PLY_AKG_CHANNEL2_TRACKNOTE)
        add     a, a
        ld      l, a
        ex      af, af'
        ld      h, 0
        ld      sp, PLY_AKG_PERIODTABLE
        add     hl, sp
        ld      sp, hl
        pop     hl
        dec     sp
        dec     sp
        add     hl, bc
        ld      bc, (PLY_AKG_CHANNEL2_GLIDETOREACH)
        rra
        jr      nc, PLY_AKG_CHANNEL2_GLIDEDOWNCHECK
        or      a
        sbc     hl, bc
        jr      nc, PLY_AKG_CHANNEL2_GLIDE_BEFOREEND
        jr      PLY_AKG_CHANNEL2_GLIDEOVER
PLY_AKG_CHANNEL2_GLIDEDOWNCHECK:
        sbc     hl, bc
        jr      c, PLY_AKG_CHANNEL2_GLIDE_BEFOREEND
PLY_AKG_CHANNEL2_GLIDEOVER:
        ld      l, c
        ld      h, b
        pop     bc
        or      a
        sbc     hl, bc
        ld      (PLY_AKG_CHANNEL2_PITCH), hl
        ld      a, 0
        ld      (PLY_AKG_CHANNEL2_ISPITCH), a
        jr      PLY_AKG_CHANNEL2_GLIDE_END
PLY_AKG_CHANNEL2_GLIDE_BEFOREEND:
        ld      hl, (PLY_AKG_CHANNEL2_GLIDE_SAVEHL)
PLY_AKG_CHANNEL2_GLIDE_END:
        db      221
        db      77
PLY_AKG_CHANNEL2_PITCH_END:
        add     hl, de
        ld      (PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH), hl
        ld      a, c
        ld      (PLY_AKG_CHANNEL2_GENERATEDCURRENTARPNOTE), a
        ld      hl, (PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL)
        ld      a, (PLY_AKG_CHANNEL3_ISVOLUMESLIDE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL3_VOLUMESLIDE_END
        ld      de, (PLY_AKG_CHANNEL3_VOLUMESLIDEVALUE)
        add     hl, de
        bit     7, h
        jr      z, PLY_AKG_CHANNEL3_VOLUMENOTOVERFLOW
        ld      h, 0
        jr      PLY_AKG_CHANNEL3_VOLUMESETAGAIN
PLY_AKG_CHANNEL3_VOLUMENOTOVERFLOW:
        ld      a, h
        cp      16
        jr      c, PLY_AKG_CHANNEL3_VOLUMESETAGAIN
        ld      h, 15
PLY_AKG_CHANNEL3_VOLUMESETAGAIN:
        ld      (PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL), hl
PLY_AKG_CHANNEL3_VOLUMESLIDE_END:
        ld      a, h
        ld      (PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME), a
        ld      c, 0
        ld      a, (PLY_AKG_CHANNEL3_ISARPEGGIOTABLE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL3_ARPEGGIOTABLE_END
        ld      hl, (PLY_AKG_CHANNEL3_ARPEGGIOTABLE)
        ld      a, (hl)
        cp      128
        jr      nz, PLY_AKG_CHANNEL3_ARPEGGIOTABLE_AFTERLOOPTEST
        inc     hl
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        ld      a, (hl)
PLY_AKG_CHANNEL3_ARPEGGIOTABLE_AFTERLOOPTEST:
        ld      c, a
        ld      a, (PLY_AKG_CHANNEL3_ARPEGGIOTABLESPEED)
        ld      d, a
        ld      a, (PLY_AKG_CHANNEL3_ARPEGGIOTABLECURRENTSTEP)
        inc     a
        cp      d
        jr      c, PLY_AKG_CHANNEL3_ARPEGGIOTABLE_BEFOREEND_SAVESTEP
        inc     hl
        ld      (PLY_AKG_CHANNEL3_ARPEGGIOTABLE), hl
        xor     a
PLY_AKG_CHANNEL3_ARPEGGIOTABLE_BEFOREEND_SAVESTEP:
        ld      (PLY_AKG_CHANNEL3_ARPEGGIOTABLECURRENTSTEP), a
PLY_AKG_CHANNEL3_ARPEGGIOTABLE_END:
        ld      de, 0
        ld      a, (PLY_AKG_CHANNEL3_ISPITCHTABLE)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL3_PITCHTABLE_END
        ld      sp, (PLY_AKG_CHANNEL3_PITCHTABLE)
        pop     de
        pop     hl
        ld      a, (PLY_AKG_CHANNEL3_PITCHTABLESPEED)
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL3_PITCHTABLECURRENTSTEP)
        inc     a
        cp      b
        jr      c, PLY_AKG_CHANNEL3_PITCHTABLE_BEFOREEND_SAVESTEP
        ld      (PLY_AKG_CHANNEL3_PITCHTABLE), hl
        xor     a
PLY_AKG_CHANNEL3_PITCHTABLE_BEFOREEND_SAVESTEP:
        ld      (PLY_AKG_CHANNEL3_PITCHTABLECURRENTSTEP), a
PLY_AKG_CHANNEL3_PITCHTABLE_END:
        ld      hl, (PLY_AKG_CHANNEL3_PITCH)
        ld      a, (PLY_AKG_CHANNEL3_ISPITCH)
        add     a, a
        jr      nc, PLY_AKG_CHANNEL3_PITCH_END
        db      221
        db      105
        ld      bc, (PLY_AKG_CHANNEL3_PITCHTRACK)
        or      a
        jp      PLY_AKG_CHANNEL3_PITCHTRACKADDORSBC_16BITS
PLY_AKG_CHANNEL3_PITCHTRACKADDORSBC_16BITSRETURN:
        ld      a, (PLY_AKG_CHANNEL3_PITCHTRACKDECIMALVALUE)
        ld      b, a
        ld      a, (PLY_AKG_CHANNEL3_PITCHTRACKDECIMALCOUNTER)
        jp      PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUE
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUERETURNAFTERJP:
        ld      (PLY_AKG_CHANNEL3_PITCHTRACKDECIMALCOUNTER), a
        jr      nc, PLY_AKG_CHANNEL3_PITCHTRACKINTEGERADDORSUBRETURN
        jp      PLY_AKG_CHANNEL3_PITCHTRACKINTEGERADDORSUB

PLY_AKG_CHANNEL3_PITCHTRACKINTEGERADDORSUBRETURN:
PLY_AKG_CHANNEL3_PITCHNOCARRY:
        ld      (PLY_AKG_CHANNEL3_PITCH), hl
        ld      a, (PLY_AKG_CHANNEL3_GLIDEDIRECTION)
        or      a
        jr      z, PLY_AKG_CHANNEL3_GLIDE_END
        ld      (PLY_AKG_CHANNEL3_GLIDE_SAVEHL), hl
        ld      c, l
        ld      b, h
        ex      af, af'
        ld      a, (PLY_AKG_CHANNEL3_TRACKNOTE)
        add     a, a
        ld      l, a
        ex      af, af'
        ld      h, 0
        ld      sp, PLY_AKG_PERIODTABLE
        add     hl, sp
        ld      sp, hl
        pop     hl
        dec     sp
        dec     sp
        add     hl, bc
        ld      bc, (PLY_AKG_CHANNEL3_GLIDETOREACH)
        rra
        jr      nc, PLY_AKG_CHANNEL3_GLIDEDOWNCHECK
        or      a
        sbc     hl, bc
        jr      nc, PLY_AKG_CHANNEL3_GLIDE_BEFOREEND
        jr      PLY_AKG_CHANNEL3_GLIDEOVER
PLY_AKG_CHANNEL3_GLIDEDOWNCHECK:
        sbc     hl, bc
        jr      c, PLY_AKG_CHANNEL3_GLIDE_BEFOREEND
PLY_AKG_CHANNEL3_GLIDEOVER:
        ld      l, c
        ld      h, b
        pop     bc
        or      a
        sbc     hl, bc
        ld      (PLY_AKG_CHANNEL3_PITCH), hl
        ld      a, 0
        ld      (PLY_AKG_CHANNEL3_ISPITCH), a
        jr      PLY_AKG_CHANNEL3_GLIDE_END
PLY_AKG_CHANNEL3_GLIDE_BEFOREEND:
        ld      hl, (PLY_AKG_CHANNEL3_GLIDE_SAVEHL)
PLY_AKG_CHANNEL3_GLIDE_END:
        db      221
        db      77
PLY_AKG_CHANNEL3_PITCH_END:
        add     hl, de
        ld      (PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH), hl
        ld      a, c
        ld      (PLY_AKG_CHANNEL3_GENERATEDCURRENTARPNOTE), a
        ld      sp, (PLY_AKG_SAVESP)
        ld      hl, (PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH)
        ld      a, (PLY_AKG_CHANNEL1_TRACKNOTE)
        ld      e, a
        ld      a, (PLY_AKG_CHANNEL1_GENERATEDCURRENTARPNOTE)
        add     a, e
        ld      e, a
        ld      d, 0
        exx
        ld      a, (PLY_AKG_CHANNEL1_INSTRUMENTSTEP)
        db      253
        db      111
        ld      hl, (PLY_AKG_CHANNEL1_PTINSTRUMENT)
        ld      a, (PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME)
        ld      e, a
        ld      d, 224
        call    PLY_AKG_READINSTRUMENTCELL
        ld      a, (PLY_AKG_CHANNEL1_INSTRUMENTSPEED)
        ld      b, a
        db      253
        db      125
        inc     a
        cp      b
        jr      c, PLY_AKG_CHANNEL1_SETINSTRUMENTSTEP
        ld      (PLY_AKG_CHANNEL1_PTINSTRUMENT), hl
        xor     a
PLY_AKG_CHANNEL1_SETINSTRUMENTSTEP:
        ld      (PLY_AKG_CHANNEL1_INSTRUMENTSTEP), a
        ld      a, e
        ld      (PLY_AKG_PSGREG8), a
        rr      d
        exx
        ld      (PLY_AKG_PSGREG01_INSTR), hl
        ld      hl, (PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH)
        ld      a, (PLY_AKG_CHANNEL2_TRACKNOTE)
        ld      e, a
        ld      a, (PLY_AKG_CHANNEL2_GENERATEDCURRENTARPNOTE)
        add     a, e
        ld      e, a
        ld      d, 0
        exx
        ld      a, (PLY_AKG_CHANNEL2_INSTRUMENTSTEP)
        db      253
        db      111
        ld      hl, (PLY_AKG_CHANNEL2_PTINSTRUMENT)
        ld      a, (PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME)
        ld      e, a
        call    PLY_AKG_READINSTRUMENTCELL
        ld      a, (PLY_AKG_CHANNEL2_INSTRUMENTSPEED)
        ld      b, a
        db      253
        db      125
        inc     a
        cp      b
        jr      c, PLY_AKG_CHANNEL2_SETINSTRUMENTSTEP
        ld      (PLY_AKG_CHANNEL2_PTINSTRUMENT), hl
        xor     a
PLY_AKG_CHANNEL2_SETINSTRUMENTSTEP:
        ld      (PLY_AKG_CHANNEL2_INSTRUMENTSTEP), a
        ld      a, e
        ld      (PLY_AKG_PSGREG9_10_INSTR), a
        rr      d
        exx
        ld      (PLY_AKG_PSGREG23_INSTR), hl
        ld      hl, (PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH)
        ld      a, (PLY_AKG_CHANNEL3_TRACKNOTE)
        ld      e, a
        ld      a, (PLY_AKG_CHANNEL3_GENERATEDCURRENTARPNOTE)
        add     a, e
        ld      e, a
        ld      d, 0
        exx
        ld      a, (PLY_AKG_CHANNEL3_INSTRUMENTSTEP)
        db      253
        db      111
        ld      hl, (PLY_AKG_CHANNEL3_PTINSTRUMENT)
        ld      a, (PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME)
        ld      e, a
        call    PLY_AKG_READINSTRUMENTCELL
        ld      a, (PLY_AKG_CHANNEL3_INSTRUMENTSPEED)
        ld      b, a
        db      253
        db      125
        inc     a
        cp      b
        jr      c, PLY_AKG_CHANNEL3_SETINSTRUMENTSTEP
        ld      (PLY_AKG_CHANNEL3_PTINSTRUMENT), hl
        xor     a
PLY_AKG_CHANNEL3_SETINSTRUMENTSTEP:
        ld      (PLY_AKG_CHANNEL3_INSTRUMENTSTEP), a
        ld      a, e
        ld      (PLY_AKG_PSGREG10), a
        ld      a, d
        exx
        ld      (PLY_AKG_PSGREG45_INSTR), hl
        call    PLY_AKG_PLAYSOUNDEFFECTSSTREAM
PLY_AKG_SENDPSGREGISTERS:
        ex      af, af'
        ld      de, 49151
        ld      bc, 65533
        ld      a, 1
        ld      hl, (PLY_AKG_PSGREG01_INSTR)
        db      237
        db      113
        ld      b, d
        out     (c), l
        ld      b, e
        out     (c), a
        ld      b, d
        out     (c), h
        ld      b, e
        ld      hl, (PLY_AKG_PSGREG23_INSTR)
        inc     a
        out     (c), a
        ld      b, d
        out     (c), l
        ld      b, e
        inc     a
        out     (c), a
        ld      b, d
        out     (c), h
        ld      b, e
        ld      hl, (PLY_AKG_PSGREG45_INSTR)
        inc     a
        out     (c), a
        ld      b, d
        out     (c), l
        ld      b, e
        inc     a
        out     (c), a
        ld      b, d
        out     (c), h
        ld      b, e
        ld      hl, (PLY_AKG_PSGREG6_8_INSTR)
        inc     a
        out     (c), a
        ld      b, d
        out     (c), l
        ld      b, e
        inc     a
        out     (c), a
        ld      b, d
        ex      af, af'
        out     (c), a
        ex      af, af'
        ld      b, e
        inc     a
        out     (c), a
        ld      b, d
        out     (c), h
        ld      b, e
        ld      hl, (PLY_AKG_PSGREG9_10_INSTR)
        inc     a
        out     (c), a
        ld      b, d
        out     (c), l
        ld      b, e
        inc     a
        out     (c), a
        ld      b, d
        out     (c), h
        ld      b, e
        ld      hl, (PLY_AKG_PSGHARDWAREPERIOD_INSTR)
        inc     a
        out     (c), a
        ld      b, d
        out     (c), l
        ld      b, e
        inc     a
        out     (c), a
        ld      b, d
        out     (c), h
        ld      b, e
        inc     a
        out     (c), a
        ld      a, (PLY_AKG_PSGREG13_INSTR)
        ld      l, a
        ld      a, (PLY_AKG_RETRIG)
        ld      h, a
        ld      a, (PLY_AKG_PSGREG13_OLDVALUE)
        or      h
        cp      l
        jr      z, PLY_AKG_PSGREG13_END
        ld      a, l
        ld      (PLY_AKG_PSGREG13_OLDVALUE), a
        ld      b, d
        out     (c), a
        xor     a
        ld      (PLY_AKG_RETRIG), a
PLY_AKG_PSGREG13_END:
        ld      sp, (PLY_AKG_SAVESP)
        ret
PLY_AKG_CHANNEL1_MAYBEEFFECTS:
        ld      (PLY_AKG_CHANNEL1_WAITCOUNTER), a
        bit     6, c
        jp      z, PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_READEFFECTS:
        ld      iy, PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
        ld      ix, PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
        ld      de, PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
        jr      PLY_AKG_CHANNEL3_READEFFECTSEND

PLY_AKG_CHANNEL1_READEFFECTSEND:
PLY_AKG_CHANNEL2_MAYBEEFFECTS:
        ld      (PLY_AKG_CHANNEL2_WAITCOUNTER), a
        bit     6, c
        jp      z, PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_READEFFECTS:
        ld      iy, PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
        ld      ix, PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
        ld      de, PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
        jr      PLY_AKG_CHANNEL3_READEFFECTSEND

PLY_AKG_CHANNEL2_READEFFECTSEND:
PLY_AKG_CHANNEL3_MAYBEEFFECTS:
        ld      (PLY_AKG_CHANNEL3_WAITCOUNTER), a
        bit     6, c
        jp      z, PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_READEFFECTS:
        ld      iy, PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
        ld      ix, PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
        ld      de, PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER

PLY_AKG_CHANNEL3_READEFFECTSEND:
PLY_AKG_CHANNEL_READEFFECTS:
        ld      (PLY_AKG_CHANNEL_READEFFECTS_ENDJUMPINSTRANDADDRESS+1), de
        ex      de, hl
        ld      a, (de)
        inc     de
        sla     a
        jr      c, PLY_AKG_CHANNEL_READEFFECTS_RELATIVEADDRESS
        exx
        ld      l, a
        ld      h, 0
        ld      de, (PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS1)
        add     hl, de
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
PLY_AKG_CHANNEL_RE_EFFECTADDRESSKNOWN:
        ld      a, (de)
        inc     de
        ld      (PLY_AKG_CHANNEL_RE_READNEXTEFFECTINBLOCK), a
        and     254
        ld      l, a
        ld      h, 0
        ld      sp, PLY_AKG_EFFECTTABLE
        add     hl, sp
        ld      sp, hl
        ret
PLY_AKG_CHANNEL_RE_EFFECTRETURN:
        ld      a, (PLY_AKG_CHANNEL_RE_READNEXTEFFECTINBLOCK)
        rra
        jr      c, PLY_AKG_CHANNEL_RE_EFFECTADDRESSKNOWN
        exx
        ex      de, hl
        jp      PLY_AKG_CHANNEL_READEFFECTS_ENDJUMPINSTRANDADDRESS
PLY_AKG_CHANNEL_READEFFECTS_RELATIVEADDRESS:
        srl     a
        exx
        ld      h, a
        exx
        ld      a, (de)
        inc     de
        exx
        ld      l, a
        ld      de, (PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS1)
        add     hl, de
        ex      de, hl
        jr      PLY_AKG_CHANNEL_RE_EFFECTADDRESSKNOWN
PLY_AKG_READINSTRUMENTCELL:
        ld      a, (hl)
        inc     hl
        ld      b, a
        rra
        jp      c, PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP
        rra
        jp      c, PLY_AKG_STH_OR_ENDWITHOUTLOOP
        rra
        jr      c, PLY_AKG_HARDTOSOFT
PLY_AKG_NOSOFTNOHARD:
        and     15
        sub     e
        jr      nc, PLY_AKG_NOSOFTNOHARD+6
        xor     a
        ld      e, a
        rl      b
        jr      nc, PLY_AKG_NSNH_NONOISE
        ld      a, (hl)
        inc     hl
        ld      (PLY_AKG_PSGREG6_8_INSTR), a
        set     2, d
        res     5, d
        ret
PLY_AKG_NSNH_NONOISE:
        set     2, d
        ret
PLY_AKG_SOFT:
        and     15
        sub     e
        jr      nc, PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON-1
        xor     a
        ld      e, a
PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON:
        rl      b
        jr      nc, PLY_AKG_S_NOTSIMPLE
        ld      c, 0
        jr      PLY_AKG_S_AFTERSIMPLETEST
PLY_AKG_S_NOTSIMPLE:
        ld      b, (hl)
        ld      c, b
        inc     hl
PLY_AKG_S_AFTERSIMPLETEST:
        call    PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD
        ld      a, c
        and     31
        ret     z
        ld      (PLY_AKG_PSGREG6_8_INSTR), a
        res     5, d
        ret
PLY_AKG_HARDTOSOFT:
        call    PLY_AKG_STOH_HTOS_SANDH_COMMON
        exx
        ld      bc, PLY_AKG_HS_JUMPRATIO
        add     a, c
        ld      c, a
        ld      a, b
        adc     a, 0
        ld      b, a
        ld      (PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS+1), bc
        exx
        ld      a, b
        exx
        ld      (PLY_AKG_PSGHARDWAREPERIOD_INSTR), hl
        jp      PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS
PLY_AKG_HS_JUMPRATIO:
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        sla     l
        rl      h
        rla
        jr      nc, PLY_AKG_SH_NOSOFTWAREPITCHSHIFT
        exx
        ld      a, (hl)
        inc     hl
        exx
        add     a, l
        ld      l, a
        exx
        ld      a, (hl)
        inc     hl
        exx
        adc     a, h
        ld      h, a
PLY_AKG_SH_NOSOFTWAREPITCHSHIFT:
        exx
        ret
PLY_AKG_ENDWITHOUTLOOP:
        ld      hl, (PLY_AKG_EMPTYINSTRUMENTDATAPT)
        inc     hl
        xor     a
        ld      b, a
        jp      PLY_AKG_NOSOFTNOHARD
PLY_AKG_STH_OR_ENDWITHOUTLOOP:
        rra
        jr      c, PLY_AKG_ENDWITHOUTLOOP
        call    PLY_AKG_STOH_HTOS_SANDH_COMMON
        exx
        ld      bc, PLY_AKG_SH_JUMPRATIO
        add     a, c
        ld      c, a
        ld      a, b
        adc     a, 0
        ld      b, a
        ld      (PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS+1), bc
        exx
        ld      a, b
        exx
        ld      e, l
        ld      d, h
        jp      PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS
PLY_AKG_SH_JUMPRATIO:
        srl     h
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
        srl     h
        rr      l
        jr      nc, PLY_AKG_SH_JUMPRATIOEND
        inc     hl
PLY_AKG_SH_JUMPRATIOEND:
        rla
        jr      nc, PLY_AKG_SH_NOHARDWAREPITCHSHIFT
        exx
        ld      a, (hl)
        inc     hl
        exx
        add     a, l
        ld      l, a
        exx
        ld      a, (hl)
        inc     hl
        exx
        adc     a, h
        ld      h, a
PLY_AKG_SH_NOHARDWAREPITCHSHIFT:
        ld      (PLY_AKG_PSGHARDWAREPERIOD_INSTR), hl
        ex      de, hl
        exx
        ret
PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP:
        rra
        jr      c, PLY_AKG_H_OR_ENDWITHLOOP
        rra
        jp      nc, PLY_AKG_SOFT
        exx
        push    hl
        push    de
        exx
        call    PLY_AKG_STOH_HTOS_SANDH_COMMON
        exx
        ld      (PLY_AKG_PSGHARDWAREPERIOD_INSTR), hl
        pop     de
        pop     hl
        exx
        rl      b
        jp      PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD
PLY_AKG_H_OR_ENDWITHLOOP:
        rra
        jr      c, PLY_AKG_ENDWITHLOOP
        ld      e, 16
        rra
        jr      nc, PLY_AKG_H_AFTERRETRIG
        ld      c, a
        db      253
        db      125
        or      a
        jr      nz, PLY_AKG_H_RETRIGEND
        ld      a, e
        ld      (PLY_AKG_RETRIG), a
PLY_AKG_H_RETRIGEND:
        ld      a, c
PLY_AKG_H_AFTERRETRIG:
        and     7
        add     a, 8
        ld      (PLY_AKG_PSGREG13_INSTR), a
        call    PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON
        exx
        ld      (PLY_AKG_PSGHARDWAREPERIOD_INSTR), hl
        exx
        set     2, d
        ret
PLY_AKG_ENDWITHLOOP:
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        jp      PLY_AKG_READINSTRUMENTCELL
PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD:
        jr      nc, PLY_AKG_S_OR_H_NEXTBYTE
        exx
        ex      de, hl
        add     hl, hl
        ld      bc, PLY_AKG_PERIODTABLE
        add     hl, bc
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        add     hl, de
        exx
        rl      b
        rl      b
        rl      b
        ret
PLY_AKG_S_OR_H_NEXTBYTE:
        rl      b
        jr      c, PLY_AKG_S_OR_H_FORCEDPERIOD
        rl      b
        jr      nc, PLY_AKG_S_OR_H_AFTERARPEGGIO
        ld      a, (hl)
        inc     hl
        exx
        add     a, e
        ld      e, a
        exx
PLY_AKG_S_OR_H_AFTERARPEGGIO:
        rl      b
        jr      nc, PLY_AKG_S_OR_H_AFTERPITCH
        ld      a, (hl)
        inc     hl
        exx
        add     a, l
        ld      l, a
        exx
        ld      a, (hl)
        inc     hl
        exx
        adc     a, h
        ld      h, a
        exx
PLY_AKG_S_OR_H_AFTERPITCH:
        exx
        ex      de, hl
        add     hl, hl
        ld      bc, PLY_AKG_PERIODTABLE
        add     hl, bc
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a
        add     hl, de
        exx
        ret
PLY_AKG_S_OR_H_FORCEDPERIOD:
        ld      a, (hl)
        inc     hl
        exx
        ld      l, a
        exx
        ld      a, (hl)
        inc     hl
        exx
        ld      h, a
        exx
        rl      b
        rl      b
        ret
PLY_AKG_STOH_HTOS_SANDH_COMMON:
        ld      e, 16
        rra
        jr      nc, PLY_AKG_SHOHS_AFTERRETRIG
        ld      c, a
        db      253
        db      125
        or      a
        jr      nz, PLY_AKG_SHOHS_RETRIGEND
        dec     a
        ld      (PLY_AKG_RETRIG), a
PLY_AKG_SHOHS_RETRIGEND:
        ld      a, c
PLY_AKG_SHOHS_AFTERRETRIG:
        and     7
        add     a, 8
        ld      (PLY_AKG_PSGREG13_INSTR), a
        rl      b
        jr      nc, PLY_AKG_SHOHS_AFTERNOISE
        ld      a, (hl)
        inc     hl
        ld      (PLY_AKG_PSGREG6_8_INSTR), a
        res     5, d
PLY_AKG_SHOHS_AFTERNOISE:
        ld      c, (hl)
        ld      b, c
        inc     hl
        rl      b
        call    PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD
        ld      a, c
        rla
        rla
        and     28
        ret
PLY_AKG_EFFECTTABLE:
        dw      PLY_AKG_EFFECT_RESETFULLVOLUME
        dw      PLY_AKG_EFFECT_RESET
        dw      PLY_AKG_EFFECT_VOLUME
        dw      PLY_AKG_EFFECT_ARPEGGIOTABLE
        dw      PLY_AKG_EFFECT_ARPEGGIOTABLESTOP
        dw      PLY_AKG_EFFECT_PITCHTABLE
        dw      PLY_AKG_EFFECT_PITCHTABLESTOP
        dw      PLY_AKG_EFFECT_VOLUMESLIDE
        dw      PLY_AKG_EFFECT_VOLUMESLIDESTOP
        dw      PLY_AKG_EFFECT_PITCHUP
        dw      PLY_AKG_EFFECT_PITCHDOWN
        dw      PLY_AKG_EFFECT_PITCHSTOP
        dw      PLY_AKG_EFFECT_GLIDEWITHNOTE
        dw      PLY_AKG_EFFECT_GLIDE_READSPEED
        dw      PLY_AKG_EFFECT_LEGATO
        dw      PLY_AKG_EFFECT_FORCEINSTRUMENTSPEED
        dw      PLY_AKG_EFFECT_FORCEARPEGGIOSPEED
        dw      PLY_AKG_EFFECT_FORCEPITCHSPEED
PLY_AKG_EFFECT_RESETFULLVOLUME:
        xor     a
        jr      PLY_AKG_EFFECT_RESETVOLUME_AFTERREADING
PLY_AKG_EFFECT_RESET:
        ld      a, (de)
        inc     de
PLY_AKG_EFFECT_RESETVOLUME_AFTERREADING:
        ld      (iy+38), a
        xor     a
        ld      (iy+39), a
        ld      (iy+40), a
        ld      a, 0
        ld      (iy+5), a
        ld      (iy+4), a
        ld      (iy+3), a
        ld      (iy+2), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_VOLUME:
        ld      a, (de)
        inc     de
        ld      (iy+38), a
        ld      (iy+2), 0
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_ARPEGGIOTABLE:
        ld      a, (de)
        inc     de
        ld      l, a
        ld      h, 0
        add     hl, hl
        ld      bc, (PLY_AKG_ARPEGGIOSTABLE)
        add     hl, bc
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      a, (bc)
        inc     bc
        ld      (iy+12), a
        ld      (iy+11), a
        ld      (iy+23), c
        ld      (iy+24), b
        ld      (iy+25), c
        ld      (iy+26), b
        ld      (iy+3), 255
        xor     a
        ld      (iy+9), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_ARPEGGIOTABLESTOP:
        ld      (iy+3), 0
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_PITCHTABLE:
        ld      a, (de)
        inc     de
        ld      l, a
        ld      h, 0
        add     hl, hl
        ld      bc, (PLY_AKG_PITCHESTABLE)
        add     hl, bc
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      a, (bc)
        inc     bc
        ld      (iy+15), a
        ld      (iy+14), a
        ld      (iy+29), c
        ld      (iy+30), b
        ld      (iy+31), c
        ld      (iy+32), b
        ld      (iy+4), 255
        xor     a
        ld      (iy+13), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_PITCHTABLESTOP:
        ld      (iy+4), 0
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_VOLUMESLIDE:
        ld      a, (de)
        inc     de
        ld      (iy+45), a
        ld      a, (de)
        inc     de
        ld      (iy+46), a
        ld      (iy+2), 255
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_VOLUMESLIDESTOP:
        ld      (iy+2), 0
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_PITCHDOWN:
        ld      (iy+58), 0
        ld      (iy+59), 9
        ld      (iy+51), 198
        ld      (iy+63), 35
PLY_AKG_EFFECT_PITCHUPDOWN_COMMON:
        ld      (iy+5), 255
        ld      (iy+19), 0
        ld      a, (de)
        inc     de
        ld      (iy+52), a
        ld      a, (de)
        inc     de
        ld      (iy+27), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_PITCHUP:
        ld      (iy+58), 237
        ld      (iy+59), 66
        ld      (iy+51), 214
        ld      (iy+63), 43
        jr      PLY_AKG_EFFECT_PITCHUPDOWN_COMMON
PLY_AKG_EFFECT_PITCHSTOP:
        ld      (iy+5), 0
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_GLIDEWITHNOTE:
        ld      a, (de)
        inc     de
        ld      (PLY_AKG_EFFECT_GLIDEWITHNOTESAVEDE), de
        add     a, a
        ld      l, a
        ld      h, 0
        ld      bc, PLY_AKG_PERIODTABLE
        add     hl, bc
        ld      sp, hl
        pop     de
        ld      (iy+47), e
        ld      (iy+48), d
        ld      a, (ix+18)
        add     a, a
        ld      l, a
        ld      h, 0
        add     hl, bc
        ld      sp, hl
        pop     hl
        ld      c, (iy+39)
        ld      b, (iy+40)
        add     hl, bc
        or      a
        sbc     hl, de
        ld      de, (PLY_AKG_EFFECT_GLIDEWITHNOTESAVEDE)
        jr      c, PLY_AKG_EFFECT_GLIDE_PITCHDOWN
        ld      (iy+19), 1
        ld      (iy+58), 237
        ld      (iy+59), 66
        ld      (iy+51), 214
        ld      (iy+63), 43

PLY_AKG_EFFECT_GLIDE_READSPEED:
PLY_AKG_EFFECT_GLIDESPEED:
        ld      a, (de)
        inc     de
        ld      (iy+52), a
        ld      a, (de)
        inc     de
        ld      (iy+27), a
        ld      a, 255
        ld      (iy+5), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_GLIDE_PITCHDOWN:
        ld      (iy+19), 2
        ld      (iy+58), 0
        ld      (iy+59), 9
        ld      (iy+51), 198
        ld      (iy+63), 35
        jr      PLY_AKG_EFFECT_GLIDE_READSPEED
PLY_AKG_EFFECT_LEGATO:
        ld      a, (de)
        inc     de
        ld      (ix+18), a
        ld      a, 0
        ld      (iy+5), a
        xor     a
        ld      (iy+39), a
        ld      (iy+40), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_FORCEINSTRUMENTSPEED:
        ld      a, (de)
        inc     de
        ld      (ix+7), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_FORCEARPEGGIOSPEED:
        ld      a, (de)
        inc     de
        ld      (iy+12), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_FORCEPITCHSPEED:
        ld      a, (de)
        inc     de
        ld      (iy+15), a
        jp      PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_PERIODTABLE:
        dw      6778
        dw      6398
        dw      6039
        dw      5700
        dw      5380
        dw      5078
        dw      4793
        dw      4524
        dw      4270
        dw      4030
        dw      3804
        dw      3591
        dw      3389
        dw      3199
        dw      3019
        dw      2850
        dw      2690
        dw      2539
        dw      2397
        dw      2262
        dw      2135
        dw      2015
        dw      1902
        dw      1795
        dw      1695
        dw      1599
        dw      1510
        dw      1425
        dw      1345
        dw      1270
        dw      1198
        dw      1131
        dw      1068
        dw      1008
        dw      951
        dw      898
        dw      847
        dw      800
        dw      755
        dw      712
        dw      673
        dw      635
        dw      599
        dw      566
        dw      534
        dw      504
        dw      476
        dw      449
        dw      424
        dw      400
        dw      377
        dw      356
        dw      336
        dw      317
        dw      300
        dw      283
        dw      267
        dw      252
        dw      238
        dw      224
        dw      212
        dw      200
        dw      189
        dw      178
        dw      168
        dw      159
        dw      150
        dw      141
        dw      133
        dw      126
        dw      119
        dw      112
        dw      106
        dw      100
        dw      94
        dw      89
        dw      84
        dw      79
        dw      75
        dw      71
        dw      67
        dw      63
        dw      59
        dw      56
        dw      53
        dw      50
        dw      47
        dw      45
        dw      42
        dw      40
        dw      37
        dw      35
        dw      33
        dw      31
        dw      30
        dw      28
        dw      26
        dw      25
        dw      24
        dw      22
        dw      21
        dw      20
        dw      19
        dw      18
        dw      17
        dw      16
        dw      15
        dw      14
        dw      13
        dw      12
        dw      12
        dw      11
        dw      11
        dw      10
        dw      9
        dw      9
        dw      8
        dw      8
        dw      7
        dw      7
        dw      7
        dw      6
        dw      6
        dw      6
        dw      5
        dw      5
        dw      5
        dw      4
PLY_AKG_ARPEGGIOSTABLE  equ _arkos_var_buffer+17
PLY_AKG_BASENOTEINDEX   equ _arkos_var_buffer+2
PLY_AKG_CHANNEL1_ARPEGGIOBASESPEED  equ _arkos_var_buffer+60
PLY_AKG_CHANNEL1_ARPEGGIOTABLE  equ _arkos_var_buffer+72
PLY_AKG_CHANNEL1_ARPEGGIOTABLEBASE  equ _arkos_var_buffer+74
PLY_AKG_CHANNEL1_ARPEGGIOTABLECURRENTSTEP   equ _arkos_var_buffer+58
PLY_AKG_CHANNEL1_ARPEGGIOTABLESPEED equ _arkos_var_buffer+61
PLY_AKG_CHANNEL1_GENERATEDCURRENTARPNOTE    equ _arkos_var_buffer+59
PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME equ _arkos_var_buffer+69
PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH  equ _arkos_var_buffer+105
PLY_AKG_CHANNEL1_GLIDEDIRECTION equ _arkos_var_buffer+68
PLY_AKG_CHANNEL1_GLIDETOREACH   equ _arkos_var_buffer+96
PLY_AKG_CHANNEL1_GLIDE_SAVEHL   equ _arkos_var_buffer+98
PLY_AKG_CHANNEL1_INSTRUMENTORIGINALSPEED    equ _arkos_var_buffer+55
PLY_AKG_CHANNEL1_INSTRUMENTSPEED    equ _arkos_var_buffer+56
PLY_AKG_CHANNEL1_INSTRUMENTSTEP equ _arkos_var_buffer+57
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER  equ _arkos_var_buffer+87
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL    equ _arkos_var_buffer+86
PLY_AKG_CHANNEL1_ISARPEGGIOTABLE    equ _arkos_var_buffer+52
PLY_AKG_CHANNEL1_ISPITCH    equ _arkos_var_buffer+54
PLY_AKG_CHANNEL1_ISPITCHTABLE   equ _arkos_var_buffer+53
PLY_AKG_CHANNEL1_ISVOLUMESLIDE  equ _arkos_var_buffer+51
PLY_AKG_CHANNEL1_PITCH  equ _arkos_var_buffer+88
PLY_AKG_CHANNEL1_PITCHBASESPEED equ _arkos_var_buffer+63
PLY_AKG_CHANNEL1_PITCHTABLE equ _arkos_var_buffer+78
PLY_AKG_CHANNEL1_PITCHTABLEBASE equ _arkos_var_buffer+80
PLY_AKG_CHANNEL1_PITCHTABLECURRENTSTEP  equ _arkos_var_buffer+62
PLY_AKG_CHANNEL1_PITCHTABLESPEED    equ _arkos_var_buffer+64
PLY_AKG_CHANNEL1_PITCHTRACK equ _arkos_var_buffer+76
PLY_AKG_CHANNEL1_PITCHTRACKADDORSBC_16BITS  equ _arkos_var_buffer+107
PLY_AKG_CHANNEL1_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS equ _arkos_var_buffer+109
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALCOUNTER   equ _arkos_var_buffer+66
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUE equ _arkos_var_buffer+100
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTRANDVALUERETURNJP equ _arkos_var_buffer+102
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALVALUE equ _arkos_var_buffer+101
PLY_AKG_CHANNEL1_PITCHTRACKINTEGERADDORSUB  equ _arkos_var_buffer+112
PLY_AKG_CHANNEL1_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS  equ _arkos_var_buffer+113
PLY_AKG_CHANNEL1_PTBASEINSTRUMENT   equ _arkos_var_buffer+92
PLY_AKG_CHANNEL1_PTINSTRUMENT   equ _arkos_var_buffer+90
PLY_AKG_CHANNEL1_PTTRACK    equ _arkos_var_buffer+70
PLY_AKG_CHANNEL1_SOUNDEFFECTDATA    equ _arkos_var_buffer+252
PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS    equ _arkos_var_buffer+49
PLY_AKG_CHANNEL1_TRACKNOTE  equ _arkos_var_buffer+67
PLY_AKG_CHANNEL1_VOLUMESLIDEVALUE   equ _arkos_var_buffer+94
PLY_AKG_CHANNEL1_WAITCOUNTER    equ _arkos_var_buffer+50
PLY_AKG_CHANNEL2_ARPEGGIOBASESPEED  equ _arkos_var_buffer+127
PLY_AKG_CHANNEL2_ARPEGGIOTABLE  equ _arkos_var_buffer+139
PLY_AKG_CHANNEL2_ARPEGGIOTABLEBASE  equ _arkos_var_buffer+141
PLY_AKG_CHANNEL2_ARPEGGIOTABLECURRENTSTEP   equ _arkos_var_buffer+125
PLY_AKG_CHANNEL2_ARPEGGIOTABLESPEED equ _arkos_var_buffer+128
PLY_AKG_CHANNEL2_GENERATEDCURRENTARPNOTE    equ _arkos_var_buffer+126
PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME equ _arkos_var_buffer+136
PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH  equ _arkos_var_buffer+172
PLY_AKG_CHANNEL2_GLIDEDIRECTION equ _arkos_var_buffer+135
PLY_AKG_CHANNEL2_GLIDETOREACH   equ _arkos_var_buffer+163
PLY_AKG_CHANNEL2_GLIDE_SAVEHL   equ _arkos_var_buffer+165
PLY_AKG_CHANNEL2_INSTRUMENTORIGINALSPEED    equ _arkos_var_buffer+122
PLY_AKG_CHANNEL2_INSTRUMENTSPEED    equ _arkos_var_buffer+123
PLY_AKG_CHANNEL2_INSTRUMENTSTEP equ _arkos_var_buffer+124
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER  equ _arkos_var_buffer+154
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL    equ _arkos_var_buffer+153
PLY_AKG_CHANNEL2_ISARPEGGIOTABLE    equ _arkos_var_buffer+119
PLY_AKG_CHANNEL2_ISPITCH    equ _arkos_var_buffer+121
PLY_AKG_CHANNEL2_ISPITCHTABLE   equ _arkos_var_buffer+120
PLY_AKG_CHANNEL2_ISVOLUMESLIDE  equ _arkos_var_buffer+118
PLY_AKG_CHANNEL2_PITCH  equ _arkos_var_buffer+155
PLY_AKG_CHANNEL2_PITCHBASESPEED equ _arkos_var_buffer+130
PLY_AKG_CHANNEL2_PITCHTABLE equ _arkos_var_buffer+145
PLY_AKG_CHANNEL2_PITCHTABLEBASE equ _arkos_var_buffer+147
PLY_AKG_CHANNEL2_PITCHTABLECURRENTSTEP  equ _arkos_var_buffer+129
PLY_AKG_CHANNEL2_PITCHTABLESPEED    equ _arkos_var_buffer+131
PLY_AKG_CHANNEL2_PITCHTRACK equ _arkos_var_buffer+143
PLY_AKG_CHANNEL2_PITCHTRACKADDORSBC_16BITS  equ _arkos_var_buffer+174
PLY_AKG_CHANNEL2_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS equ _arkos_var_buffer+176
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALCOUNTER   equ _arkos_var_buffer+133
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUE equ _arkos_var_buffer+167
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTRANDVALUERETURNJP equ _arkos_var_buffer+169
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALVALUE equ _arkos_var_buffer+168
PLY_AKG_CHANNEL2_PITCHTRACKINTEGERADDORSUB  equ _arkos_var_buffer+179
PLY_AKG_CHANNEL2_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS  equ _arkos_var_buffer+180
PLY_AKG_CHANNEL2_PTBASEINSTRUMENT   equ _arkos_var_buffer+159
PLY_AKG_CHANNEL2_PTINSTRUMENT   equ _arkos_var_buffer+157
PLY_AKG_CHANNEL2_PTTRACK    equ _arkos_var_buffer+137
PLY_AKG_CHANNEL2_SOUNDEFFECTDATA    equ _arkos_var_buffer+260
PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS    equ _arkos_var_buffer+116
PLY_AKG_CHANNEL2_TRACKNOTE  equ _arkos_var_buffer+134
PLY_AKG_CHANNEL2_VOLUMESLIDEVALUE   equ _arkos_var_buffer+161
PLY_AKG_CHANNEL2_WAITCOUNTER    equ _arkos_var_buffer+117
PLY_AKG_CHANNEL3_ARPEGGIOBASESPEED  equ _arkos_var_buffer+194
PLY_AKG_CHANNEL3_ARPEGGIOTABLE  equ _arkos_var_buffer+206
PLY_AKG_CHANNEL3_ARPEGGIOTABLEBASE  equ _arkos_var_buffer+208
PLY_AKG_CHANNEL3_ARPEGGIOTABLECURRENTSTEP   equ _arkos_var_buffer+192
PLY_AKG_CHANNEL3_ARPEGGIOTABLESPEED equ _arkos_var_buffer+195
PLY_AKG_CHANNEL3_GENERATEDCURRENTARPNOTE    equ _arkos_var_buffer+193
PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME equ _arkos_var_buffer+203
PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH  equ _arkos_var_buffer+239
PLY_AKG_CHANNEL3_GLIDEDIRECTION equ _arkos_var_buffer+202
PLY_AKG_CHANNEL3_GLIDETOREACH   equ _arkos_var_buffer+230
PLY_AKG_CHANNEL3_GLIDE_SAVEHL   equ _arkos_var_buffer+232
PLY_AKG_CHANNEL3_INSTRUMENTORIGINALSPEED    equ _arkos_var_buffer+189
PLY_AKG_CHANNEL3_INSTRUMENTSPEED    equ _arkos_var_buffer+190
PLY_AKG_CHANNEL3_INSTRUMENTSTEP equ _arkos_var_buffer+191
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER  equ _arkos_var_buffer+221
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL    equ _arkos_var_buffer+220
PLY_AKG_CHANNEL3_ISARPEGGIOTABLE    equ _arkos_var_buffer+186
PLY_AKG_CHANNEL3_ISPITCH    equ _arkos_var_buffer+188
PLY_AKG_CHANNEL3_ISPITCHTABLE   equ _arkos_var_buffer+187
PLY_AKG_CHANNEL3_ISVOLUMESLIDE  equ _arkos_var_buffer+185
PLY_AKG_CHANNEL3_PITCH  equ _arkos_var_buffer+222
PLY_AKG_CHANNEL3_PITCHBASESPEED equ _arkos_var_buffer+197
PLY_AKG_CHANNEL3_PITCHTABLE equ _arkos_var_buffer+212
PLY_AKG_CHANNEL3_PITCHTABLEBASE equ _arkos_var_buffer+214
PLY_AKG_CHANNEL3_PITCHTABLECURRENTSTEP  equ _arkos_var_buffer+196
PLY_AKG_CHANNEL3_PITCHTABLESPEED    equ _arkos_var_buffer+198
PLY_AKG_CHANNEL3_PITCHTRACK equ _arkos_var_buffer+210
PLY_AKG_CHANNEL3_PITCHTRACKADDORSBC_16BITS  equ _arkos_var_buffer+241
PLY_AKG_CHANNEL3_PITCHTRACKAFTERADDORSBCJUMPINSTRANDADDRESS equ _arkos_var_buffer+243
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALCOUNTER   equ _arkos_var_buffer+200
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUE equ _arkos_var_buffer+234
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTRANDVALUERETURNJP equ _arkos_var_buffer+236
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALVALUE equ _arkos_var_buffer+235
PLY_AKG_CHANNEL3_PITCHTRACKINTEGERADDORSUB  equ _arkos_var_buffer+246
PLY_AKG_CHANNEL3_PITCHTRACKINTEGERAFTERADDORSUBJUMPINSTRANDADDRESS  equ _arkos_var_buffer+247
PLY_AKG_CHANNEL3_PTBASEINSTRUMENT   equ _arkos_var_buffer+226
PLY_AKG_CHANNEL3_PTINSTRUMENT   equ _arkos_var_buffer+224
PLY_AKG_CHANNEL3_PTTRACK    equ _arkos_var_buffer+204
PLY_AKG_CHANNEL3_SOUNDEFFECTDATA    equ _arkos_var_buffer+268
PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS    equ _arkos_var_buffer+183
PLY_AKG_CHANNEL3_TRACKNOTE  equ _arkos_var_buffer+201
PLY_AKG_CHANNEL3_VOLUMESLIDEVALUE   equ _arkos_var_buffer+228
PLY_AKG_CHANNEL3_WAITCOUNTER    equ _arkos_var_buffer+184
PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS1   equ _arkos_var_buffer+23
PLY_AKG_CHANNEL_READEFFECTS_ENDJUMPINSTRANDADDRESS  equ _arkos_var_buffer+41
PLY_AKG_CHANNEL_RE_READNEXTEFFECTINBLOCK    equ _arkos_var_buffer+10
PLY_AKG_CURRENTSPEED    equ _arkos_var_buffer+1
PLY_AKG_EFFECT_GLIDEWITHNOTESAVEDE  equ _arkos_var_buffer+44
PLY_AKG_EMPTYINSTRUMENTDATAPT   equ _arkos_var_buffer+25
PLY_AKG_EVENT   equ _arkos_var_buffer+0
PLY_AKG_EVENTTRACK_PTTRACK  equ _arkos_var_buffer+15
PLY_AKG_EVENTTRACK_WAITCOUNTER  equ _arkos_var_buffer+6
PLY_AKG_INSTRUMENTSTABLE    equ _arkos_var_buffer+21
PLY_AKG_PATTERNDECREASINGHEIGHT equ _arkos_var_buffer+3
PLY_AKG_PITCHESTABLE    equ _arkos_var_buffer+19
PLY_AKG_PSGHARDWAREPERIOD_INSTR equ _arkos_var_buffer+39
PLY_AKG_PSGREG01_INSTR  equ _arkos_var_buffer+29
PLY_AKG_PSGREG10    equ _arkos_var_buffer+38
PLY_AKG_PSGREG13_INSTR  equ _arkos_var_buffer+8
PLY_AKG_PSGREG13_OLDVALUE   equ _arkos_var_buffer+7
PLY_AKG_PSGREG23_INSTR  equ _arkos_var_buffer+31
PLY_AKG_PSGREG45_INSTR  equ _arkos_var_buffer+33
PLY_AKG_PSGREG6_8_INSTR equ _arkos_var_buffer+35
PLY_AKG_PSGREG8 equ _arkos_var_buffer+36
PLY_AKG_PSGREG9_10_INSTR    equ _arkos_var_buffer+37
PLY_AKG_PTSOUNDEFFECTTABLE  equ _arkos_var_buffer+250
PLY_AKG_READLINKER_PTLINKER equ _arkos_var_buffer+11
PLY_AKG_RETRIG  equ _arkos_var_buffer+9
PLY_AKG_SAVESP  equ _arkos_var_buffer+27
PLY_AKG_SPEEDTRACK_PTTRACK  equ _arkos_var_buffer+13
PLY_AKG_SPEEDTRACK_WAITCOUNTER  equ _arkos_var_buffer+5
PLY_AKG_TEMPPLAYINSTRUMENTJUMPINSTRANDADDRESS   equ _arkos_var_buffer+46
PLY_AKG_TICKDECREASINGCOUNTER   equ _arkos_var_buffer+4
;;
;; maximum arkos variable offset: 268
;; _arkos_var_buffer size: 269


        section bss_sound_ay
_arkos_var_buffer:
        defs    269

