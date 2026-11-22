;       Player of sound effects, for AKG (Generic) the player, format V2 (including speed).
;       This file is meant to be included to the AKG player, do not use it stand-alone.
;       If you want sound effects without music, there is a specific player for that.

        ;Is there a loaded Player Configuration source? If no, use a default configuration.
        IFNDEF PLY_CFG_SFX_ConfigurationIsPresent
                PLY_CFG_UseHardwareSounds = 1
                PLY_CFG_SFX_LoopTo = 1
                PLY_CFG_SFX_NoSoftNoHard = 1
                PLY_CFG_SFX_NoSoftNoHard_Noise = 1
                PLY_CFG_SFX_SoftOnly = 1
                PLY_CFG_SFX_SoftOnly_Noise = 1
                PLY_CFG_SFX_HardOnly = 1
                PLY_CFG_SFX_HardOnly_Noise = 1
                PLY_CFG_SFX_HardOnly_Retrig = 1
                PLY_CFG_SFX_SoftAndHard = 1
                PLY_CFG_SFX_SoftAndHard_Noise = 1
                PLY_CFG_SFX_SoftAndHard_Retrig = 1
        ENDIF
        
;       Agglomerates some Player Configuration flags.
;       --------------------------------------------
;       Mixes the Hardware flags into one.
        IFDEF PLY_CFG_SFX_HardOnly
                PLY_AKG_SE_HardwareSounds = 1
        ENDIF
        IFDEF PLY_CFG_SFX_SoftAndHard
                PLY_AKG_SE_HardwareSounds = 1
        ENDIF
;       Mixes the Hardware Noise flags into one.
        IFDEF PLY_CFG_SFX_HardOnly_Noise
                PLY_AKG_SE_HardwareNoise = 1
        ENDIF
        IFDEF PLY_CFG_SFX_SoftAndHard_Noise
                PLY_AKG_SE_HardwareNoise = 1
        ENDIF
;       Mixes the Noise flags into one.
        IFDEF PLY_AKG_SE_HardwareNoise
                PLY_AKG_SE_Noise = 1
        ENDIF
        IFDEF PLY_CFG_SFX_NoSoftNoHard_Noise
                PLY_AKG_SE_Noise = 1
        ENDIF
        IFDEF PLY_CFG_SFX_SoftOnly
                PLY_AKG_SE_Noise = 1
        ENDIF
;       If Noise, the R6 code in the music player must be compiled.
        IFDEF PLY_AKG_SE_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF

;       Mixes the Software Volume flags into one.
        IFDEF PLY_CFG_SFX_NoSoftNoHard
                PLY_AKG_SE_VolumeSoft = 1
                PLY_AKG_SE_VolumeSoftOrHard = 1
        ENDIF
        IFDEF PLY_CFG_SFX_SoftOnly
                PLY_AKG_SE_VolumeSoft = 1
                PLY_AKG_SE_VolumeSoftOrHard = 1
        ENDIF
;       Mixes the volume (soft/hard) into one.
        IFDEF PLY_CFG_UseHardwareSounds
                PLY_AKG_SE_VolumeSoftOrHard = 1
        ENDIF
;       Mixes the retrig flags into one.
        IFDEF PLY_CFG_SFX_HardOnly_Retrig
                PLY_AKG_SE_Retrig = 1
        ENDIF
        IFDEF PLY_CFG_SFX_SoftAndHard_Retrig
                PLY_AKG_SE_Retrig = 1
        ENDIF
        

        ;Disark macro: Word region Start.
        disarkCounter = 0
        IFNDEF dkws
        MACRO dkws
PLY_AKG_DisarkWordRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Word region End.
        IFNDEF dkwe
        MACRO dkwe
PLY_AKG_DisarkWordRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        ;Disark macro: Pointer region Start.
        disarkCounter = 0
        IFNDEF dkps
        MACRO dkps
PLY_AKG_DisarkPointerRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Pointer region End.
        IFNDEF dkpe
        MACRO dkpe
PLY_AKG_DisarkPointerRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        ;Disark macro: Byte region Start.
        disarkCounter = 0
        IFNDEF dkbs
        MACRO dkbs
PLY_AKG_DisarkByteRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Byte region End.
        IFNDEF dkbe
        MACRO dkbe
PLY_AKG_DisarkByteRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF

        ;Disark macro: Force "No Reference Area" for 3 bytes (ld hl,xxxx).
        IFNDEF dknr3
        MACRO dknr3
PLY_AKG_DisarkForceNonReferenceDuring3_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF



;Initializes the sound effects. It MUST be called at any times before a first sound effect is triggered.
;It doesn't matter whether the song is playing or not, or if it has been initialized or not.
;IN:    HL = Address to the sound effects data.
PLY_AKG_InitSoundEffectsDisarkGenerateExternalLabel
PLY_AKG_InitSoundEffects:
        ld (PLY_AKG_PtSoundEffectTable + PLY_AKG_Offset1b),hl
        ret


;Plays a sound effect. If a previous one was already playing on the same channel, it is replaced.
;This does not actually plays the sound effect, but programs its playing.
;The music player, when called, will call the PLY_AKG_PlaySoundEffectsStream method below.
;IN:    A = Sound effect number (>0!).
;       C = The channel where to play the sound effect (0, 1, 2).
;       B = Inverted volume (0 = full volume, 16 = no sound). Hardware sounds are also lowered.
PLY_AKG_PlaySoundEffectDisarkGenerateExternalLabel
PLY_AKG_PlaySoundEffect:

        ;Gets the address to the sound effect.
        dec a                   ;The 0th is not encoded.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PtSoundEffectTable: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PtSoundEffectTable)
        ENDIF
        ld e,a
        ld d,0
        add hl,de
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ;Reads the header of the sound effect to get the speed.
        ld a,(de)
        inc de
        ex af,af'

        ld a,b

        ;Finds the pointer to the sound effect of the desired channel.
        ld hl,PLY_AKG_Channel1_SoundEffectData
        ld b,0
        sla c
        sla c
        sla c
        add hl,bc
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl        
        
        ;Now stores the inverted volume.
        ld (hl),a
        inc hl
        
        ;Resets the current speed, stores the instrument speed.
        ld (hl),0
        inc hl
        ex af,af'
        ld (hl),a

        ret

;Stops a sound effect. Nothing happens if there was no sound effect.
;IN:    A = The channel where to stop the sound effect (0, 1, 2).
PLY_AKG_StopSoundEffectFromChannelDisarkGenerateExternalLabel
PLY_AKG_StopSoundEffectFromChannel:
        ;Puts 0 to the pointer of the sound effect.
        add a,a
        add a,a
        add a,a
        ld e,a
        ld d,0
        ld hl,PLY_AKG_Channel1_SoundEffectData
        add hl,de
        ld (hl),d               ;0 means "no sound".
        inc hl
        ld (hl),d
        ret

;Plays the sound effects, if any has been triggered by the user.
;This does not actually send registers to the PSG, it only overwrite the required values of the registers of the player.
;The sound effects initialization method must have been called before!
;As R7 is required, this must be called after the music has been played, but BEFORE the registers are sent to the PSG.
;IN:    A = R7.
;OUT:   A = new R7.
PLY_AKG_PlaySoundEffectsStream:
        ;Shifts the R7 to the left twice, so that bit 2 and 5 only can be set for each track, below.
        rla
        rla

        ;Plays the sound effects on every channel.
        ld ix,PLY_AKG_Channel1_SoundEffectData
        ld iy,PLY_AKG_PSGReg8
        ld hl,PLY_AKG_PSGReg01_Instr + PLY_AKG_Offset1b
        exx
        ld c,a
        ;Channel 1.
        ;----------
        call PLY_AKG_PSES_Play
        ld ix,PLY_AKG_Channel2_SoundEffectData
        ld iy,PLY_AKG_PSGReg9
        exx
                ld hl,PLY_AKG_PSGReg23_Instr + PLY_AKG_Offset1b
        exx
        ;Channel 2.
        ;----------
        IFDEF PLY_AKG_HARDWARE_CPC
                srl c                                                   ;Not RR, to make sure bit 6 is 0 (else, no more keyboard on CPC!).
        ELSE
                IFDEF PLY_AKG_HARDWARE_MSX
                        srl c                                           ;R7 bit 6 on MSX must be 0.
                ELSE
                        rr c                                            ;On other platforms, we don't care.
                ENDIF
        ENDIF

        call PLY_AKG_PSES_Play
        ld ix,PLY_AKG_Channel3_SoundEffectData
        ld iy,PLY_AKG_PSGReg10
        exx
                ld hl,PLY_AKG_PSGReg45_Instr + PLY_AKG_Offset1b
        exx
        ;Channel 3.
        ;----------
        IFDEF PLY_AKG_HARDWARE_MSX
                scf                                                    ;R7 bit 7 on MSX must be 1.
        ENDIF
        rr c
        call PLY_AKG_PSES_Play

        ld a,c
        ret


;Plays the sound stream from the given pointer to the sound effect. If 0, no sound is played.
;The given R7 is given shift twice to the left, so that this code MUST set/reset the bit 2 (sound), and set/reset bit 5 (noise).
;This code MUST overwrite these bits because sound effects have priority over the music.
;IN:    IX = Points on the sound effect pointer. If the sound effect pointer is 0, nothing must be played.
;       IY = Points on the address where to store the volume for this channel.
;       HL'= Points on the address where to store the software period for this channel.
;       C = R7, shifted twice to the left.
;OUT:   The pointed pointer by IX may be modified as the sound advances.
;       C = R7, MUST be modified if there is a sound effect.
PLY_AKG_PSES_Play:
        ;Reads the pointer pointed by IX.
        ld l,(ix + 0)
        ld h,(ix + 1)
        ld a,l
        or h
        ret z           ;No sound to be played? Returns immediately.

        ;Reads the first byte. What type of sound is it?
PLY_AKG_PSES_ReadFirstByte:
        ld a,(hl)
        inc hl
        ld b,a
        rra
        jr c,PLY_AKG_PSES_SoftwareOrSoftwareAndHardware
        rra
                        IFDEF PLY_CFG_SFX_HardOnly              ;CONFIG SPECIFIC
        jr c,PLY_AKG_PSES_HardwareOnly
                        ENDIF ;PLY_CFG_SFX_HardOnly

        ;No software, no hardware, or end/loop.
        ;-------------------------------------------
        ;End or loop?
        rra
                        IFDEF PLY_CFG_SFX_NoSoftNoHard         ;CONFIG SPECIFIC. If not present, the jump is not needed, the method is just below.
        jr c,PLY_AKG_PSES_S_EndOrLoop

        ;No software, no hardware.
        ;-------------------------------------------
        ;Gets the volume.
        call PLY_AKG_PSES_ManageVolumeFromA_Filter4Bits

        ;Noise?
                                IFDEF PLY_CFG_SFX_NoSoftNoHard_Noise                ;CONFIG SPECIFIC
        rl b
        call PLY_AKG_PSES_ReadNoiseIfNeededAndOpenOrCloseNoiseChannel
                                ELSE
        set 5,c                                                 ;No noise in compilation, so stops the noise.
                                ENDIF ;PLY_CFG_SFX_NoSoftNoHard_Noise

        ;Cuts the sound.
        set 2,c
        
        jr PLY_AKG_PSES_SavePointerAndExit
                        ENDIF ;PLY_CFG_SFX_NoSoftNoHard

        ;**Warning!** Do not put any instruction between EndOrLoop and NoSoftNoHard.

PLY_AKG_PSES_S_EndOrLoop:
                        IFDEF PLY_CFG_SFX_LoopTo                ;CONFIG SPECIFIC. If no "loop to", the sounds always end, no need to test.
        ;Is it an end?
        rra
        jr c,PLY_AKG_PSES_S_Loop
                        ENDIF ;PLY_CFG_SFX_LoopTo
        ;End of the sound. Marks the sound pointer with 0, meaning "no sound".
        xor a
        ld (ix + 0),a
        ld (ix + 1),a
        ret
                        IFDEF PLY_CFG_SFX_LoopTo                ;CONFIG SPECIFIC.
PLY_AKG_PSES_S_Loop:
        ;Loops. Reads the pointer and directly uses it.
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        jr PLY_AKG_PSES_ReadFirstByte
                        ENDIF ;PLY_CFG_SFX_LoopTo
                        

;Saves HL into IX, and exits. This must be called at the end of each Cell.
;If the speed has not been reached, it is not saved.
PLY_AKG_PSES_SavePointerAndExit:
        ;Speed reached?
        ld a,(ix + PLY_AKG_SoundEffectData_OffsetCurrentStep)
        cp (ix + PLY_AKG_SoundEffectData_OffsetSpeed)
        jr c,PLY_AKG_PSES_NotReached
        ;The speed has been reached, so resets it and saves the pointer to the next cell to read.
        ld (ix + PLY_AKG_SoundEffectData_OffsetCurrentStep),0
        ld (ix + 0),l
        ld (ix + 1),h
        ret
PLY_AKG_PSES_NotReached:
        ;Speed not reached. Increases it, that's all. The same cell will be read next time.
        inc (ix + PLY_AKG_SoundEffectData_OffsetCurrentStep)
        ret

                        IFDEF PLY_CFG_SFX_HardOnly         ;CONFIG SPECIFIC
        ;Hardware only.
        ;-------------------------------------------
PLY_AKG_PSES_HardwareOnly:
        ;Calls the shared code that manages everything.
        call PLY_AKG_PSES_Shared_ReadRetrigHardwareEnvPeriodNoise
        ;Cuts the sound.
        set 2,c

        jr PLY_AKG_PSES_SavePointerAndExit
                        ENDIF ;PLY_CFG_SFX_HardOnly



PLY_AKG_PSES_SoftwareOrSoftwareAndHardware:
        ;Software only?
        rra
                        IFDEF PLY_CFG_SFX_SoftAndHard         ;CONFIG SPECIFIC
        jr c,PLY_AKG_PSES_SoftwareAndHardware
                        ENDIF ;PLY_CFG_SFX_SoftAndHard

        ;Software.
        ;-------------------------------------------
                        IFDEF PLY_CFG_SFX_SoftOnly          ;CONFIG SPECIFIC
        ;Volume.
        call PLY_AKG_PSES_ManageVolumeFromA_Filter4Bits

        ;Noise?
                                IFDEF PLY_CFG_SFX_SoftOnly_Noise                ;CONFIG SPECIFIC
        rl b
        call PLY_AKG_PSES_ReadNoiseIfNeededAndOpenOrCloseNoiseChannel
                                ELSE
        set 5,c                                                 ;No noise in compilation, so stops the noise.
                                ENDIF ;PLY_CFG_SFX_SoftOnly_Noise
                                
        ;Opens the "sound" channel.
        res 2,c

        ;Reads the software period.
        call PLY_AKG_PSES_ReadSoftwarePeriod

        jr PLY_AKG_PSES_SavePointerAndExit
                        ENDIF ;PLY_CFG_SFX_SoftOnly
                        

        ;Software and Hardware.
        ;-------------------------------------------
                        IFDEF PLY_AKG_SE_HardwareSounds         ;CONFIG SPECIFIC
PLY_AKG_PSES_SoftwareAndHardware:
        ;Calls the shared code that manages everything.
        call PLY_AKG_PSES_Shared_ReadRetrigHardwareEnvPeriodNoise

        ;Reads the software period.
        call PLY_AKG_PSES_ReadSoftwarePeriod

        ;Opens the sound.
        res 2,c

        jr PLY_AKG_PSES_SavePointerAndExit
                        ENDIF ;PLY_AKG_SE_HardwareSounds


                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        ;Shared code used by the "hardware only" and "software and hardware" part.
        ;Reads the Retrig flag, the Hardware Envelope, the possible noise, the hardware period,
        ;and sets the volume to 16. The R7 sound channel is NOT modified.
PLY_AKG_PSES_Shared_ReadRetrigHardwareEnvPeriodNoise:
        ;Retrig?
        rra
                                IFDEF PLY_AKG_SE_Retrig                  ;CONFIG SPECIFIC
        jr nc,PLY_AKG_PSES_H_AfterRetrig
        ld d,a
        ld a,255
        ld (PLY_AKG_PSGReg13_OldValue + PLY_AKG_Offset1b),a
        ld a,d
PLY_AKG_PSES_H_AfterRetrig:
                                ENDIF ;PLY_AKG_SE_Retrig

        ;The hardware envelope can be set (8-15).
        and %111
        add a,8
        ld (PLY_AKG_PSGReg13_Instr + PLY_AKG_Offset1b),a

                                IFDEF PLY_AKG_SE_HardwareNoise           ;CONFIG SPECIFIC. B not needed after, we can put it in the condition too.
        ;Noise?
        rl b
        call PLY_AKG_PSES_ReadNoiseIfNeededAndOpenOrCloseNoiseChannel
                                ELSE
        set 5,c                                                 ;No noise in compilation, so stops the noise.
                                ENDIF ;PLY_AKG_SE_HardwareNoise

        ;Reads the hardware period.
        call PLY_AKG_PSES_ReadHardwarePeriod

        ;Sets the volume to "hardware". It still may be decreased.
        ld a,16
        jp PLY_AKG_PSES_ManageVolumeFromA_Hard
                        ENDIF ;PLY_CFG_UseHardwareSounds
                        

                        IFDEF PLY_AKG_SE_Noise
;If asked to, reads the noise pointed by HL, increases HL, and opens the noise channel. If no noise, closes the noise channel.
;IN:    Carry = true if noise to read. False if no noise, so the noise channel must be closed.
;       HL = the data.
PLY_AKG_PSES_ReadNoiseIfNeededAndOpenOrCloseNoiseChannel:
        jr c,PLY_AKG_PSES_ReadNoiseAndOpenNoiseChannel_OpenNoise
        ;No noise, so closes the noise channel.
        set 5,c
        ret
PLY_AKG_PSES_ReadNoiseAndOpenNoiseChannel_OpenNoise:
        ;Reads the noise.
        ld a,(hl)
        ld (PLY_AKG_PSGReg6),a
        inc hl

        ;Opens noise channel.
        res 5,c
        ret
                        ENDIF ;PLY_AKG_SE_Noise

                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
;Reads the hardware period from HL and sets the R11/R12 registers. HL is incremented of 2.
PLY_AKG_PSES_ReadHardwarePeriod:
        ld a,(hl)
        ld (PLY_AKG_PSGHardwarePeriod_Instr + PLY_AKG_Offset1b),a
        inc hl
        ld a,(hl)
        ld (PLY_AKG_PSGHardwarePeriod_Instr + PLY_AKG_Offset1b + 1),a
        inc hl
        ret
                        ENDIF ;PLY_CFG_UseHardwareSounds

;Reads the software period from HL and sets the period registers in HL'. HL is incremented of 2.
PLY_AKG_PSES_ReadSoftwarePeriod:
        ld a,(hl)
        inc hl
        exx
                ld (hl),a
                inc hl
        exx
        ld a,(hl)
        inc hl
        exx
                ld (hl),a
        exx
        ret

                        IFDEF PLY_AKG_SE_VolumeSoft      ;CONFIG SPECIFIC
;Reads the volume in A, decreases it from the inverted volume of the channel, and sets the volume via IY.
;IN:    A = volume, from 0 to 15 (no hardware envelope).
PLY_AKG_PSES_ManageVolumeFromA_Filter4Bits:
        and %1111
                        ENDIF ;PLY_AKG_SE_VolumeSoft
                        IFDEF PLY_AKG_SE_VolumeSoftOrHard        ;CONFIG SPECIFIC
;After the filtering. Useful for hardware sound (volume has been forced to 16).
PLY_AKG_PSES_ManageVolumeFromA_Hard:
        ;Decreases the volume, checks the limit.
        sub (ix + PLY_AKG_SoundEffectData_OffsetInvertedVolume)
        jr nc,PLY_AKG_PSES_MVFA_NoOverflow
        xor a
PLY_AKG_PSES_MVFA_NoOverflow:
        ld (iy + 0),a
        ret
                        ENDIF ;PLY_AKG_SE_VolumeSoftOrHard
                        

        ;The data for RAM player. For ROM player, it is declared in the main player.
        IFNDEF PLY_AKG_Rom
;The data of the Channels MUST be consecutive.
PLY_AKG_Channel1_SoundEffectData:
dkws (void):
        dw 0                                            ;Points to the sound effect for the track 1, or 0 if not playing.
dkwe (void):
dkbs (void):
PLY_AKG_Channel1_SoundEffectInvertedVolume:
        db 0                                            ;Inverted volume.
PLY_AKG_Channel1_SoundEffectCurrentStep:
        db 0                                            ;Current step (>=0).
PLY_AKG_Channel1_SoundEffectSpeed:
        db 0                                            ;Speed (>=0).
        ds 3,0                                          ;Padding.
dkbe (void):
PLY_AKG_Channel_SoundEffectDataSize: equ $ - PLY_AKG_Channel1_SoundEffectData
    
dkbs (void):
PLY_AKG_Channel2_SoundEffectData:
        ds PLY_AKG_Channel_SoundEffectDataSize, 0
PLY_AKG_Channel3_SoundEffectData:
        ds PLY_AKG_Channel_SoundEffectDataSize, 0
dkbe (void):

        ;Checks that the pointers are consecutive.
        assert (PLY_AKG_Channel1_SoundEffectData + PLY_AKG_Channel_SoundEffectDataSize) == PLY_AKG_Channel2_SoundEffectData
        assert (PLY_AKG_Channel2_SoundEffectData + PLY_AKG_Channel_SoundEffectDataSize) == PLY_AKG_Channel3_SoundEffectData
        
        ENDIF ;PLY_AKG_Rom

;Offset from the beginning of the data, to reach the inverted volume.
PLY_AKG_SoundEffectData_OffsetInvertedVolume: equ PLY_AKG_Channel1_SoundEffectInvertedVolume - PLY_AKG_Channel1_SoundEffectData
PLY_AKG_SoundEffectData_OffsetCurrentStep: equ PLY_AKG_Channel1_SoundEffectCurrentStep - PLY_AKG_Channel1_SoundEffectData
PLY_AKG_SoundEffectData_OffsetSpeed: equ PLY_AKG_Channel1_SoundEffectSpeed - PLY_AKG_Channel1_SoundEffectData
