;       Arkos Tracker 2 player "generic" player.
;       By Targhan/Arkos.
;       Psg optimization trick on CPC by Madram/Overlanders.
;
;       This compiles with RASM. Check the compatibility page on the Arkos Tracker 2 website, it contains a source converter to any Z80 assembler!
;
;       The player uses the stack for optimizations. Make sure the interruptions are disabled before it is called.
;       The stack pointer is saved at the beginning and restored at the end.
;
;       Target hardware:
;       ---------------
;       This code can target Amstrad CPC, MSX, Spectrum and Pentagon. By default, it targets Amstrad CPC.
;       Simply use one of the follow line (BEFORE this player):
;       PLY_AKG_HARDWARE_CPC = 1
;       PLY_AKG_HARDWARE_MSX = 1
;       PLY_AKG_HARDWARE_SPECTRUM = 1
;       PLY_AKG_HARDWARE_PENTAGON = 1
;       Note that the PRESENCE of this variable is tested, NOT its value.
;
;       ROM
;       ----------------------
;       To use a ROM player (no automodification, use of a small buffer to put in RAM):
;       PLY_AKG_ROM = 1
;       PLY_AKG_ROM_Buffer = #4000 (or wherever).
;       This makes the player a bit slower and slightly bigger.
;       The buffer is PLY_AKG_ROM_BufferSize long (=250 max). You can hardcode this value, because it is calculated, so it won't be accessible before this player is assembled.
;       This value decreases when you use player configuration, but increases if you use sound effects.
;
;       Optimizations:
;       --------------
;       - Use the Player Configuration of Arkos Tracker 2 to generate a configuration file to be included at the beginning of this player.
;         It will disable useless features according to your songs, saving for memory and CPU! Check the manual for more details, or more simply the testers.
;       - Set PLY_AKG_USE_HOOKS to 0 to remove the three hooks just below to save 9 bytes (yay!).
;       - Set PLY_AKG_STOP_SOUNDS to 0 if you don't intent to stop the music via the PLY_AKG_Stop method.
;       - If you play your song "one shot" (i.e. without restarting it again), you can set the PLY_AKG_FULL_INIT_CODE to 0, some
;         initialization code will not be assembled.

;       Sound effects:
;       --------------
;       Sound effects are disabled by default. Declare PLY_AKG_MANAGE_SOUND_EFFECTS to enable it:
;       PLY_AKG_MANAGE_SOUND_EFFECTS = 1
;       Check the sound effect tester to see how it enables it.
;       Note that the PRESENCE of this variable is tested, NOT its value.

;       Additional note:
;       - There can be a slightly difference when using volume in/out effects compared to the PC side, because the volume management is
;         different. This means there can be a difference of 1 at certain frames. As it shouldn't be a bother, I let it this way.
;         This allows the Z80 code to be faster and simpler.
;
;       -------------------------------------------------------


PLY_AKG_Start:
 
        ;Checks the hardware. Only one must be selected.
PLY_AKG_HardwareCounter = 0
        IFDEF PLY_AKG_HARDWARE_CPC
                PLY_AKG_HardwareCounter = PLY_AKG_HardwareCounter + 1
        ENDIF
        IFDEF PLY_AKG_HARDWARE_MSX
                PLY_AKG_HardwareCounter = PLY_AKG_HardwareCounter + 1
                PLY_AKG_HARDWARE_SPECTRUM_OR_MSX = 1
        ENDIF
        IFDEF PLY_AKG_HARDWARE_SPECTRUM
                PLY_AKG_HardwareCounter = PLY_AKG_HardwareCounter + 1
                PLY_AKG_HARDWARE_SPECTRUM_OR_PENTAGON = 1
                PLY_AKG_HARDWARE_SPECTRUM_OR_MSX = 1
        ENDIF
        IFDEF PLY_AKG_HARDWARE_PENTAGON
                PLY_AKG_HardwareCounter = PLY_AKG_HardwareCounter + 1
                PLY_AKG_HARDWARE_SPECTRUM_OR_PENTAGON = 1
        ENDIF
        IF PLY_AKG_HardwareCounter > 1
                FAIL 'Only one hardware must be selected!'
        ENDIF
        ;By default, selects the Amstrad CPC.
        IF PLY_AKG_HardwareCounter == 0
                PLY_AKG_HARDWARE_CPC = 1
        ENDIF
        

PLY_AKG_USE_HOOKS: equ 1                            ;Use hooks for external calls? 0 if the Init/Play/Stop methods are directly called. Will save a few bytes.
PLY_AKG_STOP_SOUNDS: equ 1                          ;1 to have the "stop sounds" code. Set it to 0 if you never plan on stopping your music.
PLY_AKG_FULL_INIT_CODE: equ 1                       ;0 to skip some init code/values, saving memory. Possible if you don't plan on restarting your song.


        ;Is there a loaded Player Configuration source? If no, use a default configuration.
        IFNDEF PLY_CFG_ConfigurationIsPresent
                PLY_CFG_UseSpeedTracks = 1
                PLY_CFG_UseEventTracks = 1
                PLY_CFG_UseTranspositions = 1
                PLY_CFG_UseHardwareSounds = 1
                PLY_CFG_UseEffects = 1
                PLY_CFG_UseRetrig = 1
                ;PLY_CFG_UseInstrumentRetrig = 1        ;Not tested, the UseRetrig is used instead.
                PLY_CFG_UseInstrumentLoopTo = 1
                ;PLY_CFG_NoSoftNoHard = 1               ;Not tested, because always present.
                PLY_CFG_NoSoftNoHard_Noise = 1
                PLY_CFG_SoftOnly = 1
                PLY_CFG_SoftOnly_Noise = 1
                PLY_CFG_SoftOnly_ForcedSoftwarePeriod = 1
                PLY_CFG_SoftOnly_SoftwareArpeggio = 1
                PLY_CFG_SoftOnly_SoftwarePitch = 1
                PLY_CFG_SoftToHard = 1
                PLY_CFG_SoftToHard_Noise = 1
                PLY_CFG_SoftToHard_ForcedSoftwarePeriod = 1
                PLY_CFG_SoftToHard_SoftwareArpeggio = 1
                PLY_CFG_SoftToHard_SoftwarePitch = 1
                PLY_CFG_SoftToHard_HardwarePitch = 1
                PLY_CFG_SoftToHard_Retrig = 1
                PLY_CFG_HardOnly = 1
                PLY_CFG_HardOnly_Noise = 1
                PLY_CFG_HardOnly_ForcedHardwarePeriod = 1
                PLY_CFG_HardOnly_HardwareArpeggio = 1
                PLY_CFG_HardOnly_HardwarePitch = 1
                PLY_CFG_HardOnly_Retrig = 1
                PLY_CFG_HardToSoft = 1
                PLY_CFG_HardToSoft_Noise = 1
                PLY_CFG_HardToSoft_ForcedHardwarePeriod = 1
                PLY_CFG_HardToSoft_HardwareArpeggio = 1
                PLY_CFG_HardToSoft_HardwarePitch = 1
                PLY_CFG_HardToSoft_SoftwarePitch = 1
                PLY_CFG_HardToSoft_Retrig = 1
                PLY_CFG_SoftAndHard = 1
                PLY_CFG_SoftAndHard_Noise = 1
                PLY_CFG_SoftAndHard_ForcedSoftwarePeriod = 1
                PLY_CFG_SoftAndHard_SoftwareArpeggio = 1
                PLY_CFG_SoftAndHard_SoftwarePitch = 1
                PLY_CFG_SoftAndHard_ForcedHardwarePeriod = 1
                PLY_CFG_SoftAndHard_HardwareArpeggio = 1
                PLY_CFG_SoftAndHard_HardwarePitch = 1
                PLY_CFG_SoftAndHard_Retrig = 1
                PLY_CFG_UseEffect_Legato = 1
                PLY_CFG_UseEffect_Reset = 1
                PLY_CFG_UseEffect_ForcePitchTableSpeed = 1
                PLY_CFG_UseEffect_ForceArpeggioSpeed = 1
                PLY_CFG_UseEffect_ForceInstrumentSpeed = 1
                PLY_CFG_UseEffect_PitchGlide = 1
                PLY_CFG_UseEffect_PitchUp = 1
                PLY_CFG_UseEffect_PitchDown = 1
                PLY_CFG_UseEffect_PitchTable = 1
                PLY_CFG_UseEffect_Arpeggio3Notes = 1
                PLY_CFG_UseEffect_Arpeggio4Notes = 1
                PLY_CFG_UseEffect_ArpeggioTable = 1
                PLY_CFG_UseEffect_SetVolume = 1
                PLY_CFG_UseEffect_VolumeIn = 1
                PLY_CFG_UseEffect_VolumeOut = 1
        ENDIF

        ;Agglomerates some flags, because they are treated the same way by this player.
        ;--------------------------------------------------
        ;Special Track Used?
        IFDEF PLY_CFG_UseSpeedTracks
                PLY_AKG_UseSpecialTracks = 1
        ENDIF
        IFDEF PLY_CFG_UseEventTracks
                PLY_AKG_UseSpecialTracks = 1
        ENDIF
        ;SoftwareOnly and HardOnly share some code.
        IFDEF PLY_CFG_SoftOnly
                PLY_AKG_UseSoftOnlyOrHardOnly = 1
        ENDIF
        IFDEF PLY_CFG_HardOnly
                PLY_AKG_UseSoftOnlyOrHardOnly = 1
        ENDIF
        ;The same for their noise.
        IFDEF PLY_CFG_SoftOnly_Noise
                PLY_AKG_UseSoftOnlyOrHardOnly_Noise = 1
        ENDIF
        IFDEF PLY_CFG_HardOnly_Noise
                PLY_AKG_UseSoftOnlyOrHardOnly_Noise = 1
        ENDIF
        
        ;Agglomerates the Forced periods (soft/hard).
        IFDEF PLY_CFG_SoftOnly_ForcedSoftwarePeriod
                PLY_AKG_UseInstrumentForcedPeriods = 1
        ENDIF
        IFDEF PLY_CFG_HardOnly_ForcedHardwarePeriod
                PLY_AKG_UseInstrumentForcedPeriods = 1
        ENDIF
        IFDEF PLY_CFG_SoftToHard_ForcedSoftwarePeriod
                PLY_AKG_UseInstrumentForcedPeriods = 1
        ENDIF
        IFDEF PLY_CFG_HardToSoft_ForcedHardwarePeriod
                PLY_AKG_UseInstrumentForcedPeriods = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_ForcedSoftwarePeriod
                PLY_AKG_UseInstrumentForcedPeriods = 1
        ENDIF
        ;Agglomerates the Instrument Arpeggios (soft/hard).
        IFDEF PLY_CFG_SoftOnly_SoftwareArpeggio
                PLY_AKG_UseInstrumentArpeggios = 1
        ENDIF
        IFDEF PLY_CFG_SoftToHard_SoftwareArpeggio
                PLY_AKG_UseInstrumentArpeggios = 1
        ENDIF
        IFDEF PLY_CFG_HardOnly_HardwareArpeggio
                PLY_AKG_UseInstrumentArpeggios = 1
        ENDIF
        IFDEF PLY_CFG_HardToSoft_HardwareArpeggio
                PLY_AKG_UseInstrumentArpeggios = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_SoftwareArpeggio
                PLY_AKG_UseInstrumentArpeggios = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_HardwareArpeggio
                PLY_AKG_UseInstrumentArpeggios = 1
        ENDIF
        ;Agglomerates the Instrument Pitchs (soft/hard).
        IFDEF PLY_CFG_SoftOnly_SoftwarePitch
                PLY_AKG_UseInstrumentPitchs = 1
        ENDIF
        IFDEF PLY_CFG_SoftToHard_SoftwarePitch
                PLY_AKG_UseInstrumentPitchs = 1
        ENDIF
        IFDEF PLY_CFG_HardOnly_HardwarePitch
                PLY_AKG_UseInstrumentPitchs = 1
        ENDIF
        IFDEF PLY_CFG_HardToSoft_HardwarePitch
                PLY_AKG_UseInstrumentPitchs = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_SoftwarePitch
                PLY_AKG_UseInstrumentPitchs = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_HardwarePitch
                PLY_AKG_UseInstrumentPitchs = 1
        ENDIF
        ;Agglomerates the Instrument Forced Periods, Arpeggios and Pitchs (soft/hard).
        IFDEF PLY_AKG_UseInstrumentForcedPeriods
                PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs = 1
        ENDIF
        IFDEF PLY_AKG_UseInstrumentArpeggios
                PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs = 1
        ENDIF
        IFDEF PLY_AKG_UseInstrumentPitchs
                PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs = 1
        ENDIF
        
        ;Agglomerates the Retrig flags for SoftToHard, HardToSoft, SoftAndHard.
        IFDEF PLY_CFG_SoftToHard_Retrig
                PLY_AKG_UseRetrig_StoH_HtoS_SandH = 1
        ENDIF
        IFDEF PLY_CFG_HardToSoft_Retrig
                PLY_AKG_UseRetrig_StoH_HtoS_SandH = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_Retrig
                PLY_AKG_UseRetrig_StoH_HtoS_SandH = 1
        ENDIF
        ;Agglomerates the noise flags for SoftToHard, HardToSoft, SoftAndHard.
        IFDEF PLY_CFG_SoftToHard_Noise
                PLY_AKG_UseNoise_StoH_HtoS_SandH = 1
        ENDIF
        IFDEF PLY_CFG_HardToSoft_Noise
                PLY_AKG_UseNoise_StoH_HtoS_SandH = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_Noise
                PLY_AKG_UseNoise_StoH_HtoS_SandH = 1
        ENDIF
        ;Agglomerates the noise flags to know if the code about R6 must be compiled.
        IFDEF PLY_CFG_NoSoftNoHard_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF
        IFDEF PLY_CFG_SoftOnly_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF
        IFDEF PLY_CFG_HardOnly_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF
        IFDEF PLY_CFG_SoftToHard_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF
        IFDEF PLY_CFG_HardToSoft_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_Noise
                PLY_AKG_Use_NoiseRegister = 1
        ENDIF
        
        ;Agglomerates the effect volume in/out.
        IFDEF PLY_CFG_UseEffect_VolumeIn
                 PLY_AKG_UseEffect_VolumeSlide = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_VolumeOut
                 PLY_AKG_UseEffect_VolumeSlide = 1
        ENDIF
        
        ;Agglomerates the Arpeggios Table effects.
        IFDEF PLY_CFG_UseEffect_Arpeggio3Notes
                PLY_AKS_UseEffect_Arpeggio = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_Arpeggio4Notes
                PLY_AKS_UseEffect_Arpeggio = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_ArpeggioTable
                PLY_AKS_UseEffect_Arpeggio = 1
        ENDIF
        
        ;Agglomerates the PitchUp/Down effects.
        IFDEF PLY_CFG_UseEffect_PitchUp
                PLY_AKS_UseEffect_PitchUpOrDown = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchDown
                PLY_AKS_UseEffect_PitchUpOrDown = 1
        ENDIF
        ;Agglomerates the PitchUp/Down/Glide effects.
        ;IMPORTANT TO NOTE that if there is Glide, there WILL be pitch up/down, because the Glide is
        ;embedded in the pitch up/down code.
        IFDEF PLY_AKS_UseEffect_PitchUpOrDown
                PLY_AKS_UseEffect_PitchUpOrDownOrGlide = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchGlide
                PLY_AKS_UseEffect_PitchUpOrDownOrGlide = 1
        ENDIF
        
        ;Agglomerates a special flag combining ArpeggioTable and PitchTable.
        IFDEF PLY_AKS_UseEffect_Arpeggio
                PLY_AKS_UseEffect_ArpeggioTableOrPitchTable = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchTable
                PLY_AKS_UseEffect_ArpeggioTableOrPitchTable = 1
        ENDIF

;A nice trick to manage the offset using the same instructions, according to the player (ROM or not).
        IFDEF PLY_AKG_Rom
PLY_AKG_Offset1b: equ 0
PLY_AKG_Offset2b: equ 0         ;Used for instructions such as ld iyh,xx
        ELSE
PLY_AKG_Offset1b: equ 1
PLY_AKG_Offset2b: equ 2
        ENDIF

        IFNDEF PLY_AKG_Rom
PLY_AKG_OPCODE_OR_A: equ #b7                        ;Opcode for "or a".
PLY_AKG_OPCODE_SCF: equ #37                         ;Opcode for "scf".
        ELSE
        ;Another trick for the ROM player. The original opcodes are converted to number, which will be multiplied by 2, provoking a carry or not.
PLY_AKG_OPCODE_OR_A: equ 0                          ;0 * 2 = 0, no carry.
PLY_AKG_OPCODE_SCF: equ #ff                         ;255 * 2 = carry.
PLY_AKG_OPCODE_JP: equ #c3
        ENDIF

PLY_AKG_OPCODE_ADD_HL_BC_LSB: equ #09               ;Opcode for "add hl,bc", LSB.
PLY_AKG_OPCODE_ADD_HL_BC_MSB: equ #00               ;Opcode for "add hl,bc", MSB (fake, it is only 8 bits).
PLY_AKG_OPCODE_SBC_HL_BC_LSB: equ #42               ;Opcode for "sbc hl,bc", LSB.
PLY_AKG_OPCODE_SBC_HL_BC_MSB: equ #ed               ;Opcode for "sbc hl,bc", MSB.
PLY_AKG_OPCODE_INC_HL: equ #23                      ;Opcode for "inc hl".
PLY_AKG_OPCODE_DEC_HL: equ #2b                      ;Opcode for "dec hl".
PLY_AKG_OPCODE_ADD_A_IMMEDIATE: equ #c6             ;Opcode for "add a,x".
PLY_AKG_OPCODE_SUB_IMMEDIATE: equ #d6               ;Opcode for "sub x".


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
        
        ;Hooks for external calls. Can be removed if not needed.
        if PLY_AKG_USE_HOOKS
                assert PLY_AKG_Start == $		;Makes sure no extra byte were inserted before the hooks.
                jp PLY_AKG_Init                         ;PLY_AKG_Start + 0.
                jp PLY_AKG_Play                         ;PLY_AKG_Start + 3.
                if PLY_AKG_STOP_SOUNDS
                        jp PLY_AKG_Stop                         ;PLY_AKG_Start + 6.
                endif ;PLY_AKG_STOP_SOUNDS
        endif ;PLY_AKG_USE_HOOKS

        ;Includes the sound effects player, if wanted. Important to do it as soon as possible, so that
        ;its code can react to the Player Configuration and possibly alter it.
        IFDEF PLY_AKG_MANAGE_SOUND_EFFECTS
                include "PlayerAkg_SoundEffects.asm"
        ENDIF ;PLY_AKG_MANAGE_SOUND_EFFECTS
        ;[[INSERT_SOUND_EFFECT_SOURCE]]                 ;A tag for test units. Don't touch or you're dead.

;Initializes the player.
;IN:    HL = music address.
;       A = subsong index (>=0).
PLY_AKG_InitDisarkGenerateExternalLabel:
PLY_AKG_Init:
        
                        IFDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
        ;Skips the tag.
dknr3 (void): ld de,4
        add hl,de
                                IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld de,PLY_AKG_ArpeggiosTable + PLY_AKG_Offset1b
        ldi
        ldi
                                ELSE
                inc hl
                inc hl
                                ENDIF
                                IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        ld de,PLY_AKG_PitchesTable + PLY_AKG_Offset1b
        ldi
        ldi
                                ELSE
                inc hl
                inc hl
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
                        ELSE
                ;No effects. Skips the tag and the arp/pitch table.
dknr3 (void):   ld de,4 + 2 + 2
                add hl,de
                        ENDIF ;PLY_CFG_UseEffects
        ld de,PLY_AKG_InstrumentsTable + PLY_AKG_Offset1b
        ldi
        ldi
                        IFDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
        ld c,(hl)
        inc hl
        ld b,(hl)
        inc hl
        ld (PLY_AKG_Channel_ReadEffects_EffectBlocks1 + PLY_AKG_Offset1b),bc
                                IFNDEF PLY_AKG_Rom
        ;Not used in ROM, the same value is used.
        ld (PLY_AKG_Channel_ReadEffects_EffectBlocks2 + PLY_AKG_Offset1b),bc
                                ENDIF
                        ELSE
                ;No effects. Skips the effect block table.
                inc hl
                inc hl
                        ENDIF ;PLY_CFG_UseEffects

        
        ;We have reached the Subsong addresses. Which one to use?
        add a,a
        ld e,a
        ld d,0
        add hl,de
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        ;HL points on the Subsong metadata.
dknr3 (void): ld de,5         ;Skips the replay frequency, digichannel, psg count, loop ^art index, end index.
        add hl,de
        ld de,PLY_AKG_CurrentSpeed + PLY_AKG_Offset1b       ;Reads the initial speed (>0).
        ldi
        ld de,PLY_AKG_BaseNoteIndex + PLY_AKG_Offset1b      ;Reads the base note of the note that is considered "optimized", contrary to "escaped".
        ldi
        ld (PLY_AKG_ReadLinker_PtLinker + PLY_AKG_Offset1b),hl

        ;Initializes values. You can remove this part if you don't stop/restart your song.
        if PLY_AKG_FULL_INIT_CODE
                ld hl,PLY_AKG_InitTable0
dknr3 (void):   ld bc,((PLY_AKG_InitTable0_End - PLY_AKG_InitTable0) / 2 + 1) * 256 + 0
                call PLY_AKG_Init_ReadWordsAndFill
                inc c
                ld hl,PLY_AKG_InitTable1
                ld b,(PLY_AKG_InitTable1_End - PLY_AKG_InitTable1) / 2 + 1
                call PLY_AKG_Init_ReadWordsAndFill
                ld hl,PLY_AKG_InitTableOrA
dknr3 (void):   ld bc,((PLY_AKG_InitTableOrA_End - PLY_AKG_InitTableOrA) / 2 + 1) * 256 + PLY_AKG_OPCODE_OR_A
                call PLY_AKG_Init_ReadWordsAndFill
                
                IFDEF PLY_AKG_Rom
                        ;The ROM version requires a bit more of setup.        
                        ld hl,PLY_AKG_InitTableJp
dknr3 (void):           ld bc,((PLY_AKG_InitTableJp_End - PLY_AKG_InitTableJp) / 2 + 1) * 256 + PLY_AKG_OPCODE_JP
                        call PLY_AKG_Init_ReadWordsAndFill
                ENDIF
                
                        IFDEF PLY_CFG_UseRetrig         ;CONFIG SPECIFIC
                ld a,255
                ld (PLY_AKG_PSGReg13_OldValue + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseRetrig
        endif

        ;Stores the address to the empty instrument *data* (header skipped).
        ld hl,(PLY_AKG_InstrumentsTable + PLY_AKG_Offset1b)
        ld e,(hl)
        inc hl
        ld d,(hl)
        ex de,hl
        inc hl                  ;Skips the header.
        ld (PLY_AKG_EmptyInstrumentDataPt + PLY_AKG_Offset1b),hl
        ;Sets all the instrument to "empty".
        ld (PLY_AKG_Channel1_PtInstrument + PLY_AKG_Offset1b),hl
        ld (PLY_AKG_Channel2_PtInstrument + PLY_AKG_Offset1b),hl
        ld (PLY_AKG_Channel3_PtInstrument + PLY_AKG_Offset1b),hl
        
        ;The ROM version requires a bit more of setup.        
        IFDEF PLY_AKG_Rom
                IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide            ;CONFIG SPECIFIC
                        xor a
                        REPEAT 3, channelNumber
                                ;In the non-ROM code, the MSB is always 0, the LSB is updated. The MSB must be reset for ROM version.
                                ld (PLY_AKG_Channel{channelNumber}_PitchTrack + 1),a
                        
                                ld hl,PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAddOrSubReturn
                                ld (PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAfterAddOrSubJumpInstrAndAddress + 1),hl
                                ld hl,PLY_AKG_Channel{channelNumber}_PitchTrackAddOrSbc_16bitsReturn
                                ld (PLY_AKG_Channel{channelNumber}_PitchTrackAfterAddOrSbcJumpInstrAndAddress + 1),hl
                                
                                ld hl,PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValueReturnAfterJp
                                ld (PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValueReturnJp + 1),hl
                        REND
                ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
        ENDIF
        
        ;If sound effects, clears the SFX state.
        IFDEF PLY_AKG_MANAGE_SOUND_EFFECTS
dknr3 (void):   ld hl,0
                REPEAT 3, channelNumber
                        ld (PLY_AKG_Channel{channelNumber}_SoundEffectData),hl
                REND
        ENDIF ;PLY_AKG_MANAGE_SOUND_EFFECTS
        
        ret

        if PLY_AKG_FULL_INIT_CODE
;Fills all the read addresses with a byte.
;IN:    HL = table where the addresses are.
;       B = how many items in the table + 1.
;       C = byte to fill.
PLY_AKG_Init_ReadWordsAndFill_Loop:
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,c
        ld (de),a
PLY_AKG_Init_ReadWordsAndFill:
        djnz PLY_AKG_Init_ReadWordsAndFill_Loop
        ret

;Table initializing some data with 0.
PLY_AKG_InitTable0:
dkps (void):    ;Disark macro.
        dw PLY_AKG_Channel1_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b
        dw PLY_AKG_Channel1_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b + 1  ;PLY_AKG_Offset2b must NOT be used here.
        dw PLY_AKG_Channel2_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b
        dw PLY_AKG_Channel2_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b + 1
        dw PLY_AKG_Channel3_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b
        dw PLY_AKG_Channel3_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b + 1
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDown        ;CONFIG SPECIFIC
        dw PLY_AKG_Channel1_Pitch + PLY_AKG_Offset1b
        dw PLY_AKG_Channel1_Pitch + PLY_AKG_Offset1b + 1
        dw PLY_AKG_Channel2_Pitch + PLY_AKG_Offset1b
        dw PLY_AKG_Channel2_Pitch + PLY_AKG_Offset1b + 1
        dw PLY_AKG_Channel3_Pitch + PLY_AKG_Offset1b
        dw PLY_AKG_Channel3_Pitch + PLY_AKG_Offset1b + 1
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDown
                        IFDEF PLY_CFG_UseRetrig         ;CONFIG SPECIFIC
        dw PLY_AKG_Retrig + 1
                        ENDIF ;PLY_CFG_UseRetrig
dkpe (void):    ;Disark macro.
PLY_AKG_InitTable0_End:

PLY_AKG_InitTable1:
dkps (void):    ;Disark macro.
        dw PLY_AKG_PatternDecreasingHeight + PLY_AKG_Offset1b
        dw PLY_AKG_TickDecreasingCounter + PLY_AKG_Offset1b
dkpe (void):    ;Disark macro.
PLY_AKG_InitTable1_End:

PLY_AKG_InitTableOrA:
dkps (void):    ;Disark macro.
                        IFDEF PLY_AKG_UseEffect_VolumeSlide             ;CONFIG SPECIFIC
        dw PLY_AKG_Channel1_IsVolumeSlide
        dw PLY_AKG_Channel2_IsVolumeSlide
        dw PLY_AKG_Channel3_IsVolumeSlide
                        ENDIF ;PLY_AKG_UseEffect_VolumeSlide
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        dw PLY_AKG_Channel1_IsArpeggioTable
        dw PLY_AKG_Channel2_IsArpeggioTable
        dw PLY_AKG_Channel3_IsArpeggioTable
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        dw PLY_AKG_Channel1_IsPitchTable
        dw PLY_AKG_Channel2_IsPitchTable
        dw PLY_AKG_Channel3_IsPitchTable
                        ENDIF ;PLY_CFG_UseEffect_PitchTable
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDown        ;CONFIG SPECIFIC
        dw PLY_AKG_Channel1_IsPitch
        dw PLY_AKG_Channel2_IsPitch
        dw PLY_AKG_Channel3_IsPitch
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDown
dkpe (void):    ;Disark macro.
PLY_AKG_InitTableOrA_End:
        endif           ;PLY_AKG_FULL_INIT_CODE

        IFDEF PLY_AKG_Rom
PLY_AKG_InitTableJp:
dkps (void):    ;Disark macro.
        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide
        dw PLY_AKG_Channel1_PitchTrackIntegerAfterAddOrSubJumpInstrAndAddress
        dw PLY_AKG_Channel2_PitchTrackIntegerAfterAddOrSubJumpInstrAndAddress
        dw PLY_AKG_Channel3_PitchTrackIntegerAfterAddOrSubJumpInstrAndAddress
        dw PLY_AKG_Channel1_PitchTrackAfterAddOrSbcJumpInstrAndAddress
        dw PLY_AKG_Channel2_PitchTrackAfterAddOrSbcJumpInstrAndAddress
        dw PLY_AKG_Channel3_PitchTrackAfterAddOrSbcJumpInstrAndAddress
        dw PLY_AKG_Channel1_PitchTrackDecimalInstrAndValueReturnJp
        dw PLY_AKG_Channel2_PitchTrackDecimalInstrAndValueReturnJp
        dw PLY_AKG_Channel3_PitchTrackDecimalInstrAndValueReturnJp
        ENDIF
        
        IFDEF PLY_CFG_UseEffects
        dw PLY_AKG_Channel_ReadEffects_EndJumpInstrAndAddress
        ENDIF
        dw PLY_AKG_TempPlayInstrumentJumpInstrAndAddress
dkpe (void):    ;Disark macro.
PLY_AKG_InitTableJp_End:
        ENDIF

        if PLY_AKG_STOP_SOUNDS
;Stops the music. This code can be removed if you don't intend to stop it!
PLY_AKG_StopDisarkGenerateExternalLabel:
PLY_AKG_Stop:
        ld (PLY_AKG_SaveSP + PLY_AKG_Offset1b),sp              ;Only useful because the PLY_AKG_SendPSGRegisters restores it at the end.
        
        ;All the volumes to 0, all sound/noise channels stopped.
        xor a
        ld l,a
        ld h,a
        ld (PLY_AKG_PSGReg8),a
        ld (PLY_AKG_PSGReg9_10_Instr + PLY_AKG_Offset1b),hl
        IFDEF PLY_AKG_HARDWARE_MSX
                ld a,%10111111          ;On MSX, bit 7 must be 1, bit 6 0.
        ELSE
                ld a,%00111111          ;On CPC, bit 6 must be 0. Other platforms don't care.
        ENDIF
        jp PLY_AKG_SendPSGRegisters
        endif ;PLY_AKG_STOP_SOUNDS

;Plays one frame of the subsong.
PLY_AKG_PlayDisarkGenerateExternalLabel:
PLY_AKG_Play:
        ld (PLY_AKG_SaveSP + PLY_AKG_Offset1b),sp

                        IFDEF PLY_CFG_UseEventTracks            ;CONFIG SPECIFIC
        xor a
        ld (PLY_AKG_Event),a
                        ENDIF ;PLY_CFG_UseEventTracks

        ;Decreases the tick counter. If 0 is reached, a new line must be read.
        IFNDEF PLY_AKG_Rom
PLY_AKG_TickDecreasingCounter: ld a,1
        ELSE
        ld a,(PLY_AKG_TickDecreasingCounter)
        ENDIF
        dec a
        jp nz,PLY_AKG_SetSpeedBeforePlayStreams                 ;Jumps if there is no new line: continues playing the sound stream.

        ;New line! Is the Pattern ended? Not as long as there are lines to read.
        IFNDEF PLY_AKG_Rom
PLY_AKG_PatternDecreasingHeight: ld a,1
        ELSE
        ld a,(PLY_AKG_PatternDecreasingHeight)
        ENDIF
        dec a
        jr nz,PLY_AKG_SetCurrentLineBeforeReadLine  ;Jumps if the pattern isn't ended.

        ;New pattern!
        ;Reads the Linker. This is called at the start of the song, or at the end of every position.
PLY_AKG_ReadLinker:
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_ReadLinker_PtLinker: ld sp,0
        ELSE
        ld sp,(PLY_AKG_ReadLinker_PtLinker)
        ENDIF
        ;Reads the address of each Track.
        pop hl
        ld a,l
        or h
        jr nz,PLY_AKG_ReadLinker_NoLoop         ;Reached the end of the song?
        ;End of the song.
        pop hl          ;HL is the loop address.
        ld sp,hl
        pop hl          ;Reads once again the address of Track 1, in the pattern looped to.
PLY_AKG_ReadLinker_NoLoop:
        ld (PLY_AKG_Channel1_PtTrack + PLY_AKG_Offset1b),hl
        pop hl
        ld (PLY_AKG_Channel2_PtTrack + PLY_AKG_Offset1b),hl
        pop hl
        ld (PLY_AKG_Channel3_PtTrack + PLY_AKG_Offset1b),hl
        ;Reads the address of the LinkerBlock.
        pop hl
        ld (PLY_AKG_ReadLinker_PtLinker + PLY_AKG_Offset1b),sp
        ld sp,hl

        ;Reads the LinkerBlock. SP = LinkerBlock.
        ;Reads the height and transposition1.
        pop hl
        ld c,l                                ;Stores the pattern height, used below.
                        IFDEF PLY_CFG_UseTranspositions            ;CONFIG SPECIFIC
        ld a,h
        ld (PLY_AKG_Channel1_Transposition + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseTranspositions
        ;Reads the transposition2 and 3.
                        IFDEF PLY_AKG_UseSpecialTracks                  ;CONFIG SPECIFIC
                                IFNDEF PLY_CFG_UseTranspositions            ;CONFIG SPECIFIC
                                ;Transpositions not used? We could stop here. BUT the SpecialTracks, if present, must access their data after.
                                ;So in this case, the transpositions must be skipped.
                                pop hl
                                ENDIF ;PLY_CFG_UseTranspositions
                        ENDIF ;PLY_AKG_UseSpecialTracks
                        IFDEF PLY_CFG_UseTranspositions            ;CONFIG SPECIFIC
        pop hl
        ld a,l
        ld (PLY_AKG_Channel2_Transposition + PLY_AKG_Offset1b),a
        ld a,h
        ld (PLY_AKG_Channel3_Transposition + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseTranspositions
                        IFDEF PLY_AKG_UseSpecialTracks                  ;CONFIG SPECIFIC
        ;Reads the special Tracks addresses.
        pop hl          ;Must be performed even SpeedTracks not used, because EventTracks might be present, the word must be skipped.
                                IFDEF PLY_CFG_UseSpeedTracks            ;CONFIG SPECIFIC
        ld (PLY_AKG_SpeedTrack_PtTrack + PLY_AKG_Offset1b),hl
                                ENDIF ;PLY_CFG_UseSpeedTracks
        
                                IFDEF PLY_CFG_UseEventTracks            ;CONFIG SPECIFIC
        pop hl
        ld (PLY_AKG_EventTrack_PtTrack + PLY_AKG_Offset1b),hl
                                ENDIF ;PLY_CFG_UseEventTracks
                        ENDIF ;PLY_AKG_UseSpecialTracks

        xor a
        ;Forces the reading of every Track and Special Track.
                        IFDEF PLY_CFG_UseSpeedTracks            ;CONFIG SPECIFIC
        ld (PLY_AKG_SpeedTrack_WaitCounter + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseSpeedTracks
                        IFDEF PLY_CFG_UseEventTracks            ;CONFIG SPECIFIC
        ld (PLY_AKG_EventTrack_WaitCounter + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseEventTracks
        ld (PLY_AKG_Channel1_WaitCounter + PLY_AKG_Offset1b),a
        ld (PLY_AKG_Channel2_WaitCounter + PLY_AKG_Offset1b),a
        ld (PLY_AKG_Channel3_WaitCounter + PLY_AKG_Offset1b),a
        ld a,c
PLY_AKG_SetCurrentLineBeforeReadLine:
        ld (PLY_AKG_PatternDecreasingHeight + PLY_AKG_Offset1b),a


        ;Reads the new line (notes, effects, Special Tracks, etc.).
PLY_AKG_ReadLine:
        ;Reads the Speed Track.
                        IFDEF PLY_CFG_UseSpeedTracks            ;CONFIG SPECIFIC
        ;-------------------------------------------------------------------
        IFNDEF PLY_AKG_Rom
PLY_AKG_SpeedTrack_WaitCounter: ld a,0      ;Lines to wait?
        ELSE
        ld a,(PLY_AKG_SpeedTrack_WaitCounter)
        ENDIF
        sub 1
        jr nc,PLY_AKG_SpeedTrack_MustWait       ;Jump if there are still lines to wait.
        ;No more lines to wait. Reads a new data. It may be an event value or a wait value.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_SpeedTrack_PtTrack: ld hl,0
        ELSE
        ld hl,(PLY_AKG_SpeedTrack_PtTrack)
        ENDIF
        ld a,(hl)
        inc hl
        srl a           ;Bit 0: wait?
        jr c,PLY_AKG_SpeedTrack_StorePointerAndWaitCounter      ;Jump if wait: A is the wait value.
        ;Value found. If 0, escape value (rare).
        jr nz,PLY_AKG_SpeedTrack_NormalValue
        ;Escape code. Reads the right value.
        ld a,(hl)
        inc hl
PLY_AKG_SpeedTrack_NormalValue:
        ld (PLY_AKG_CurrentSpeed + PLY_AKG_Offset1b),a

        xor a                   ;Next time, a new value is read.
PLY_AKG_SpeedTrack_StorePointerAndWaitCounter:
        ld (PLY_AKG_SpeedTrack_PtTrack + PLY_AKG_Offset1b),hl
PLY_AKG_SpeedTrack_MustWait:
        ld (PLY_AKG_SpeedTrack_WaitCounter + PLY_AKG_Offset1b),a
PLY_AKG_SpeedTrack_End:
                        ENDIF ;PLY_CFG_UseSpeedTracks

        
   


        ;Reads the Event Track.
        ;-------------------------------------------------------------------
                        IFDEF PLY_CFG_UseEventTracks            ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
PLY_AKG_EventTrack_WaitCounter: ld a,0          ;Lines to wait?
        ELSE
        ld a,(PLY_AKG_EventTrack_WaitCounter)
        ENDIF
        sub 1
        jr nc,PLY_AKG_EventTrack_MustWait       ;Jump if there are still lines to wait.
        ;No more lines to wait. Reads a new data. It may be an event value or a wait value.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_EventTrack_PtTrack: ld hl,0
        ELSE
        ld hl,(PLY_AKG_EventTrack_PtTrack)
        ENDIF
        ld a,(hl)
        inc hl
        srl a           ;Bit 0: wait?
        jr c,PLY_AKG_EventTrack_StorePointerAndWaitCounter      ;Jump if wait: A is the wait value.
        ;Value found. If 0, escape value (rare).
        jr nz,PLY_AKG_EventTrack_NormalValue
        ;Escape code. Reads the right value.
        ld a,(hl)
        inc hl
PLY_AKG_EventTrack_NormalValue:
        ld (PLY_AKG_Event),a

        xor a                   ;Next time, a new value is read.
PLY_AKG_EventTrack_StorePointerAndWaitCounter:
        ld (PLY_AKG_EventTrack_PtTrack + PLY_AKG_Offset1b),hl
PLY_AKG_EventTrack_MustWait:
        ld (PLY_AKG_EventTrack_WaitCounter + PLY_AKG_Offset1b),a
PLY_AKG_EventTrack_End:
                        ENDIF ;PLY_CFG_UseEventTracks







        ;-------------------------------------------------------------------------
        ;Reads the possible Cell of the Channel 1, 2 and 3. Use a Macro for each channel, but the code is duplicated.
        ;-------------------------------------------------------------------------

        MACRO PLY_AKG_ReadTrack channelNumber

        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_WaitCounter: ld a,0      ;Lines to wait?
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_WaitCounter)
        ENDIF
        sub 1
        jr c,PLY_AKG_Channel{channelNumber}_ReadTrack
        ;Still some lines to wait.
        ld (PLY_AKG_Channel{channelNumber}_WaitCounter + PLY_AKG_Offset1b),a
        jp PLY_AKG_Channel{channelNumber}_ReadCellEnd
        
PLY_AKG_Channel{channelNumber}_ReadTrack:
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_PtTrack: ld hl,0      ;Points on the Cell to read.
        ELSE
        ld hl,(PLY_AKG_Channel{channelNumber}_PtTrack)
        ENDIF
        ;Reads note data. It can be a note, a wait...

        ld c,(hl)       ;C = data (b5-0) + effect? (b6) + new Instrument? (b7).
        inc hl
        ld a,c
        and %111111     ;A = data.
        cp 60           ;0-59: note. "cp" is preferred to "sub" so that the "note" branch (the slowest) is note-ready.
        jr c,PLY_AKG_Channel{channelNumber}_Note
        sub 60
        jp z,PLY_AKG_Channel{channelNumber}_MaybeEffects        ;60 = no note, but maybe effects.
        dec a
        jr z,PLY_AKG_Channel{channelNumber}_Wait                ;61 = wait, no effect.
        dec a
        jr z,PLY_AKG_Channel{channelNumber}_SmallWait           ;62 = small wait, no effect.
        ;63 = escape code for note, maybe effects.
        ;Reads the note in the next byte (HL has already been incremented).
        ld a,(hl)
        inc hl
        jr PLY_AKG_Channel{channelNumber}_AfterNoteKnown

        ;Small wait, no effect.
PLY_AKG_Channel{channelNumber}_SmallWait:
        ld a,c          ;Uses bit 6/7 to indicate how many lines to wait.
        rlca
        rlca
        and %11
        inc a         ;This wait start at 2 lines, to 5.
        ld (PLY_AKG_Channel{channelNumber}_WaitCounter + PLY_AKG_Offset1b),a
        jr PLY_AKG_Channel{channelNumber}_BeforeEnd_StoreCellPointer

        ;Wait, no effect.
PLY_AKG_Channel{channelNumber}_Wait:
        ld a,(hl)   ;Reads the wait value on the next byte (HL has already been incremented).
        ld (PLY_AKG_Channel{channelNumber}_WaitCounter + PLY_AKG_Offset1b),a
        inc hl
        jr PLY_AKG_Channel{channelNumber}_BeforeEnd_StoreCellPointer

        ;Little subcode put here, called just below. A bit dirty, but avoids long jump.
PLY_AKG_Channel{channelNumber}_SameInstrument:
        ;No new instrument. The instrument pointer must be reset.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_PtBaseInstrument: ld de,0
        ELSE
        ld de,(PLY_AKG_Channel{channelNumber}_PtBaseInstrument)
        ENDIF 
        ld (PLY_AKG_Channel{channelNumber}_PtInstrument + PLY_AKG_Offset1b),de
        jr PLY_AKG_Channel{channelNumber}_AfterInstrument

        ;A note has been found, plus maybe an Instrument and effects. A = note. C = still has the New Instrument/Effects flags.
PLY_AKG_Channel{channelNumber}_Note:
        if {channelNumber} == 1                 ;Declares this only for the first channel, else refers to it.
                IFNDEF PLY_AKG_Rom
PLY_AKG_BaseNoteIndex: add a,0                  ;The encoded note is only from a 4 octave range, but the first note depends on he best window, determined by the song generator.
                ELSE
                ld b,a
                ld a,(PLY_AKG_BaseNoteIndex + PLY_AKG_Offset1b)
                add a,b
                ENDIF
        else
                ld b,a
                ld a,(PLY_AKG_BaseNoteIndex + PLY_AKG_Offset1b)
                add a,b
        endif
PLY_AKG_Channel{channelNumber}_AfterNoteKnown:
                        IFDEF PLY_CFG_UseTranspositions                  ;CONFIG SPECIFIC
                                IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_Transposition: add a,0           ;Adds the Track transposition.
                                ELSE
                                ld b,a
                                ld a,(PLY_AKG_Channel{channelNumber}_Transposition + PLY_AKG_Offset1b)
                                add a,b
                                ENDIF
                        ENDIF ;PLY_CFG_UseTranspositions
        ld (PLY_AKG_Channel{channelNumber}_TrackNote + PLY_AKG_Offset1b),a
 
        ;HL = next data. C = data byte.
        rl c                ;New Instrument?
        jr nc,PLY_AKG_Channel{channelNumber}_SameInstrument
        ;Gets the new Instrument.
        ld a,(hl)
        inc hl
        exx
        if {channelNumber} == 1               ;Declares this only for the first channel, else refers to it.
                ld l,a
                ld h,0
                add hl,hl
                IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_InstrumentsTable: ld de,0           ;Points on the Instruments table of the music (set on song initialization).
                ELSE
                        ld de,(PLY_AKG_InstrumentsTable + PLY_AKG_Offset1b)
                ENDIF
                add hl,de
        else
                ld e,a
                ld d,0
                ld hl,(PLY_AKG_InstrumentsTable + PLY_AKG_Offset1b)           ;Points on the Instruments table of the music (set on song initialization).
                add hl,de
                add hl,de
        endif
                ld sp,hl
                pop hl
          
                ld a,(hl)       ;Gets the speed.
                inc hl
                        ;No need to store an "original speed" if "force instrument speed" effect is not used.
                        IFDEF PLY_CFG_UseEffect_ForceInstrumentSpeed            ;CONFIG SPECIFIC
                                ld (PLY_AKG_Channel{channelNumber}_InstrumentOriginalSpeed + PLY_AKG_Offset1b),a
                        ELSE
                                ld (PLY_AKG_Channel{channelNumber}_InstrumentSpeed + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseEffect_ForceInstrumentSpeed
                ld (PLY_AKG_Channel{channelNumber}_PtInstrument + PLY_AKG_Offset1b),hl
                ld (PLY_AKG_Channel{channelNumber}_PtBaseInstrument + PLY_AKG_Offset1b),hl   ;Useful when playing another note with the same instrument.
        exx
PLY_AKG_Channel{channelNumber}_AfterInstrument:

        ;There is a new note. The instrument pointer has already been reset.
        ;-------------------------------------------------------------------
        ;Instrument number is set.
        ;Arpeggio and Pitch Table are reset.
        
        ;HL must be preserved! But it is faster to use HL than DE when storing 16 bits value.
        ;So it is stored in DE for now.
        ex de,hl

        ;The track pitch and glide, instrument step are reset.
        xor a
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide        ;CONFIG SPECIFIC
        ld l,a
        ld h,a
        ld (PLY_AKG_Channel{channelNumber}_Pitch + PLY_AKG_Offset1b),hl
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld (PLY_AKG_Channel{channelNumber}_ArpeggioTableCurrentStep + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        ld (PLY_AKG_Channel{channelNumber}_PitchTableCurrentStep + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseEffect_PitchTable
        ld (PLY_AKG_Channel{channelNumber}_InstrumentStep + PLY_AKG_Offset2b),a
        
                        ;If the "force instrument speed" effect is used, the instrument speed must be reset to its original value.
                        IFDEF PLY_CFG_UseEffect_ForceInstrumentSpeed            ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_InstrumentOriginalSpeed ld a,0
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_InstrumentOriginalSpeed)
        ENDIF
        ld (PLY_AKG_Channel{channelNumber}_InstrumentSpeed + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_CFG_UseEffect_ForceInstrumentSpeed
        
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDown        ;CONFIG SPECIFIC
        ld a,PLY_AKG_OPCODE_OR_A
        ld (PLY_AKG_Channel{channelNumber}_IsPitch),a
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDown
        
        ;Resets the speed of the Arpeggio and the Pitch.
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld a,(PLY_AKG_Channel{channelNumber}_ArpeggioBaseSpeed)
        ld (PLY_AKG_Channel{channelNumber}_ArpeggioTableSpeed),a
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
                        IFDEF PLY_CFG_UseEffect_PitchTable        ;CONFIG SPECIFIC
        ld a,(PLY_AKG_Channel{channelNumber}_PitchBaseSpeed)
        ld (PLY_AKG_Channel{channelNumber}_PitchTableSpeed),a        
                        ENDIF ;PLY_CFG_UseEffect_PitchTable

                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld hl,(PLY_AKG_Channel{channelNumber}_ArpeggioTableBase)              ;Points to the first value of the Arpeggio.
        ld (PLY_AKG_Channel{channelNumber}_ArpeggioTable + PLY_AKG_Offset1b),hl
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
                        IFDEF PLY_CFG_UseEffect_PitchTable        ;CONFIG SPECIFIC
        ld hl,(PLY_AKG_Channel{channelNumber}_PitchTableBase)                 ;Points to the first value of the Pitch.
        ld (PLY_AKG_Channel{channelNumber}_PitchTable + PLY_AKG_Offset1b),hl
                        ENDIF ;PLY_CFG_UseEffect_PitchTable

        ex de,hl
        
                        IFDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
        ;Effects?
        rl c
        jp c,PLY_AKG_Channel{channelNumber}_ReadEffects
                        ENDIF ;PLY_CFG_UseEffects

        ;No effects. Nothing more to read for this cell.
PLY_AKG_Channel{channelNumber}_BeforeEnd_StoreCellPointer:
        ld (PLY_AKG_Channel{channelNumber}_PtTrack + PLY_AKG_Offset1b),hl
PLY_AKG_Channel{channelNumber}_ReadCellEnd:

        ENDM ;PLY_AKG_ReadTrack

        ;Generates the code for each channel, from the macro above.
        PLY_AKG_ReadTrack 1
        PLY_AKG_ReadTrack 2
        PLY_AKG_ReadTrack 3












        IFNDEF PLY_AKG_Rom
PLY_AKG_CurrentSpeed: ld a,0      ;>0.
        ELSE
        ld a,(PLY_AKG_CurrentSpeed)
        ENDIF
PLY_AKG_SetSpeedBeforePlayStreams:
        ld (PLY_AKG_TickDecreasingCounter + PLY_AKG_Offset1b),a







        ;-----------------------------------------------------------------------------------------
        ;Applies the trailing effects for channel 1, 2, 3. Uses a macro instead of duplicating the code.
        ;-----------------------------------------------------------------------------------------
        
        MACRO PLY_AKG_ApplyTrailingEffects channelNumber
        
        ;Use Volume slide?
        ;----------------------------
                IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_InvertedVolumeIntegerAndDecimal: ld hl,0
        ELSE
        ld hl,(PLY_AKG_Channel{channelNumber}_InvertedVolumeIntegerAndDecimal)
        ENDIF
PLY_AKG_Channel{channelNumber}_InvertedVolumeInteger: equ PLY_AKG_Channel{channelNumber}_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b + 1
                        IFDEF PLY_AKG_UseEffect_VolumeSlide             ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_IsVolumeSlide: or a                   ;Is there a Volume Slide ? Automodified. SCF if yes, OR A if not.
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_IsVolumeSlide)
        add a,a         ;Creates the carry or not.
        ENDIF
        jr nc,PLY_AKG_Channel{channelNumber}_VolumeSlide_End
        
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_VolumeSlideValue: ld de,0              ;May be negative.
        ELSE
        ld de,(PLY_AKG_Channel{channelNumber}_VolumeSlideValue)
        ENDIF
        add hl,de
        ;Went below 0?
        bit 7,h
        jr z,PLY_AKG_Channel{channelNumber}_VolumeNotOverflow
        ld h,0                  ;No need to set L to 0... Shouldn't make any hearable difference.
        jr PLY_AKG_Channel{channelNumber}_VolumeSetAgain
PLY_AKG_Channel{channelNumber}_VolumeNotOverflow:
        ;Higher than 15?
        ld a,h
        cp 16
        jr c,PLY_AKG_Channel{channelNumber}_VolumeSetAgain
        ld h,15        
PLY_AKG_Channel{channelNumber}_VolumeSetAgain:
        ld (PLY_AKG_Channel{channelNumber}_InvertedVolumeIntegerAndDecimal + PLY_AKG_Offset1b),hl
        
PLY_AKG_Channel{channelNumber}_VolumeSlide_End:
                        ENDIF ;PLY_AKG_UseEffect_VolumeSlide
        ld a,h
        ld (PLY_AKG_Channel{channelNumber}_GeneratedCurrentInvertedVolume + PLY_AKG_Offset1b),a
        
        
        
        
        
        ;Use Arpeggio table? OUT: C = value.
        ;----------------------------------------
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld c,0  ;Default value of the arpeggio.

        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_IsArpeggioTable: or a                   ;Is there an arpeggio table? Automodified. SCF if yes, OR A if not.
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_IsArpeggioTable)
        add a,a         ;Creates the carry or not.
        ENDIF
        jr nc,PLY_AKG_Channel{channelNumber}_ArpeggioTable_End

        ;We can read the Arpeggio table for a new value.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_ArpeggioTable: ld hl,0                 ;Points on the data, after the header.
        ELSE
        ld hl,(PLY_AKG_Channel{channelNumber}_ArpeggioTable)
        ENDIF
        ld a,(hl)
        cp -128                  ;Loop?
        jr nz,PLY_AKG_Channel{channelNumber}_ArpeggioTable_AfterLoopTest
        ;Loop. Where to?
        inc hl
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        ld a,(hl)               ;Reads the value. Safe, we know there is no loop here.
        
        ;HL = pointer on what is follows.
        ;A = value to use.
PLY_AKG_Channel{channelNumber}_ArpeggioTable_AfterLoopTest:
        ld c,a
        
        ;Checks the speed. If reached, the pointer can be saved to read a new value next time.
        ld a,(PLY_AKG_Channel{channelNumber}_ArpeggioTableSpeed)
        ld d,a
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_ArpeggioTableCurrentStep: ld a,0
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_ArpeggioTableCurrentStep)
        ENDIF
        inc a
        cp d               ;From 1 to 256.
        jr c,PLY_AKG_Channel{channelNumber}_ArpeggioTable_BeforeEnd_SaveStep  ;C, not NZ, because the current step may be higher than the limit if Force Speed effect is used.
        ;Stores the pointer to read a new value next time.
        inc hl
        ld (PLY_AKG_Channel{channelNumber}_ArpeggioTable + PLY_AKG_Offset1b),hl

        xor a
PLY_AKG_Channel{channelNumber}_ArpeggioTable_BeforeEnd_SaveStep:
        ld (PLY_AKG_Channel{channelNumber}_ArpeggioTableCurrentStep + PLY_AKG_Offset1b),a
PLY_AKG_Channel{channelNumber}_ArpeggioTable_End:
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio



        ;Use Pitch table? OUT: DE = pitch value.
        ;C must NOT be modified!
        ;-----------------------
        
dknr3 (void):
        ld de,0         ;Default value.
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_IsPitchTable: or a                   ;Is there an arpeggio table? Automodified. SCF if yes, OR A if not.
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_IsPitchTable)
        add a,a         ;Creates the carry or not.
        ENDIF
        jr nc,PLY_AKG_Channel{channelNumber}_PitchTable_End
        
        ;Read the Pitch table for a value.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_PitchTable: ld sp,0                 ;Points on the data, after the header.
        ELSE
        ld sp,(PLY_AKG_Channel{channelNumber}_PitchTable)
        ENDIF
        pop de                  ;Reads the value.
        pop hl                  ;Reads the pointer to the next value. Manages the loop automatically!
        
        ;Checks the speed. If reached, the pointer can be saved (advance in the Pitch).
        ld a,(PLY_AKG_Channel{channelNumber}_PitchTableSpeed)
        ld b,a
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_PitchTableCurrentStep: ld a,0
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_PitchTableCurrentStep)
        ENDIF
        inc a
        cp b                                                 ;From 1 to 256.
        jr c,PLY_AKG_Channel{channelNumber}_PitchTable_BeforeEnd_SaveStep  ;C, not NZ, because the current step may be higher than the limit if Force Speed effect is used.
        ;Advances in the Pitch.
        ld (PLY_AKG_Channel{channelNumber}_PitchTable + PLY_AKG_Offset1b),hl
        
        xor a
PLY_AKG_Channel{channelNumber}_PitchTable_BeforeEnd_SaveStep:
        ld (PLY_AKG_Channel{channelNumber}_PitchTableCurrentStep + PLY_AKG_Offset1b),a
PLY_AKG_Channel{channelNumber}_PitchTable_End:        
                        ENDIF ;PLY_CFG_UseEffect_PitchTable



        ;Pitch management. The Glide is embedded, but relies on the Pitch (Pitch can exist without Glide, but Glide can not without Pitch).
        ;Do NOT modify C or DE.
        ;------------------------------------------------------------------------------------------
                        IFNDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide        ;CONFIG SPECIFIC
dknr3 (void):   ld hl,0 ;No pitch.
                                IFNDEF PLY_AKG_Rom              ;Nothing to declare if ROM.
                                ;Some dirty duplication in case there is no pitch up/down/glide. The "real" vars are a bit below.
PLY_AKG_Channel{channelNumber}_SoundStream_RelativeModifierAddress:                 ;Put here, no need for better place (see the real label below, with the same name).
                                        IFDEF PLY_AKS_UseEffect_ArpeggioTableOrPitchTable       ;CONFIG SPECIFIC
                                        jr PLY_AKG_Channel{channelNumber}_AfterArpeggioPitchVariables
                                
                                                IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
dkbs (void):    ;Disark macro.
PLY_AKG_Channel{channelNumber}_ArpeggioTableSpeed: db 0
PLY_AKG_Channel{channelNumber}_ArpeggioBaseSpeed: db 0
PLY_AKG_Channel{channelNumber}_ArpeggioTableBase: dw 0
dkbe (void):    ;Disark macro.
                                                ENDIF ;PLY_AKS_UseEffect_Arpeggio
                                                IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
dkbs (void):    ;Disark macro.
PLY_AKG_Channel{channelNumber}_PitchTableSpeed: db 0
PLY_AKG_Channel{channelNumber}_PitchBaseSpeed: db 0
PLY_AKG_Channel{channelNumber}_PitchTableBase: dw 0
dkbe (void):    ;Disark macro.
                                                ENDIF ;PLY_CFG_UseEffect_PitchTable
PLY_AKG_Channel{channelNumber}_AfterArpeggioPitchVariables:
                                        ENDIF ;PLY_AKS_UseEffect_ArpeggioTableOrPitchTable
                                ENDIF ;PLY_AKG_ROM       
                        ELSE ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_Pitch: ld hl,0
PLY_AKG_Channel{channelNumber}_IsPitch: or a                          ;Is there a Pitch? Automodified. SCF if yes, OR A if not.
        ELSE
        ld hl,(PLY_AKG_Channel{channelNumber}_Pitch)
        ld a,(PLY_AKG_Channel{channelNumber}_IsPitch)
        add a,a         ;Creates the carry or not.
        ENDIF
        jr nc,PLY_AKG_Channel{channelNumber}_Pitch_End
        ;C must NOT be modified, stores it.
                                IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld ixl,c
                                ENDIF ;PLY_AKS_UseEffect_Arpeggio
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_PitchTrack: ld bc,0                    ;Value from the user. ALWAYS POSITIVE. Does not evolve. B is always 0.
        ELSE
        ld bc,(PLY_AKG_Channel{channelNumber}_PitchTrack)
        ENDIF

        or a                                            ;Required if the code is changed to sbc.
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_PitchTrackAddOrSbc_16bits: nop : add hl,bc          ;WILL BE AUTOMODIFIED to add or sbc. But SBC requires 2*8 bits! Damn.
        ELSE
        jp PLY_AKG_Channel{channelNumber}_PitchTrackAddOrSbc_16bits   ;Calls a code that holds the instruction.
PLY_AKG_Channel{channelNumber}_PitchTrackAddOrSbc_16bitsReturn:
        ENDIF
        
        ;Makes the decimal part evolves.
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalCounter: ld a,0
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstr: add a,0              ;Value from the user. WILL BE AUTOMODIFIED to add or sub.
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalValue: equ PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstr + 1
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_PitchTrackDecimalValue)
        ld b,a
        ld a,(PLY_AKG_Channel{channelNumber}_PitchTrackDecimalCounter)
        ;Add a,b or sub b? Lets the subcode decide. It will return just below.
        jp PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValue
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValueReturnAfterJp:
        ENDIF
        ld (PLY_AKG_Channel{channelNumber}_PitchTrackDecimalCounter + PLY_AKG_Offset1b),a

        jr nc,PLY_AKG_Channel{channelNumber}_PitchNoCarry
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAddOrSub: inc hl                   ;WILL BE AUTOMODIFIED to inc hl/dec hl
        ELSE
        jp PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAddOrSub   ;Calls a code that holds the instruction.
PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAddOrSubReturn:
        ENDIF
PLY_AKG_Channel{channelNumber}_PitchNoCarry:
        ld (PLY_AKG_Channel{channelNumber}_Pitch + PLY_AKG_Offset1b),hl

        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_SoundStream_RelativeModifierAddress:                   ;This must be placed at the any location to allow reaching the variables via IX/IY.
        ENDIF
                                IFDEF PLY_CFG_UseEffect_PitchGlide        ;CONFIG SPECIFIC
        ;Glide?
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_GlideDirection: ld a,0         ;0 = no glide. 1 = glide/pitch up. 2 = glide/pitch down.
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_GlideDirection)
        ENDIF
        or a                                    ;Is there a Glide?
        jr z,PLY_AKG_Channel{channelNumber}_Glide_End

        ld (PLY_AKG_Channel{channelNumber}_Glide_SaveHL + PLY_AKG_Offset1b),hl
        ld c,l
        ld b,h
        ;Finds the period of the current note.
        ex af,af'
                ld a,(PLY_AKG_Channel{channelNumber}_TrackNote + PLY_AKG_Offset1b)
                add a,a                                         ;Encoded on 7 bits, so no problem.
                ld l,a
        ex af,af'
        ld h,0
        ld sp,PLY_AKG_PeriodTable
        add hl,sp
        ld sp,hl
        pop hl                                          ;HL = current note period.
        dec sp
        dec sp                                          ;We will need this value if the glide is over, it is faster to reuse the stack.
        
        add hl,bc                                       ;HL is now the current period (note period + track pitch).
        
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_GlideToReach: ld bc,0                  ;Period to reach (note given by the user, converted to period).
        ELSE
        ld bc,(PLY_AKG_Channel{channelNumber}_GlideToReach)
        ENDIF
        ;Have we reached the glide destination?
        ;Depends on the direction.        
        rra                                             ;If 1, the carry is set. If 2, no.
        jr nc,PLY_AKG_Channel{channelNumber}_GlideDownCheck
        ;Glide up. Check.
        ;The glide period should be lower than the current pitch.
        or a
        sbc hl,bc
        jr nc,PLY_AKG_Channel{channelNumber}_Glide_BeforeEnd           ;If not reached yet, continues the pitch.
        jr PLY_AKG_Channel{channelNumber}_GlideOver

PLY_AKG_Channel{channelNumber}_GlideDownCheck:
        ;The glide period should be higher than the current pitch.
        sbc hl,bc                                       ;No carry, no need to remove it.
        jr c,PLY_AKG_Channel{channelNumber}_Glide_BeforeEnd           ;If not reached yet, continues the pitch.
PLY_AKG_Channel{channelNumber}_GlideOver:
        ;The glide is over. However, it may be over, so we can't simply use the current pitch period. We have to set the exact needed value.
        ld l,c
        ld h,b
        pop bc
        or a
        sbc hl,bc
        
        ld (PLY_AKG_Channel{channelNumber}_Pitch + PLY_AKG_Offset1b),hl
        ld a,PLY_AKG_OPCODE_OR_A
        ld (PLY_AKG_Channel{channelNumber}_IsPitch),a
        ;Skips the HL restoration, the one we have is fine and will give us the right pitch to use.
        jr PLY_AKG_Channel{channelNumber}_Glide_End
                                ELSE
        IFNDEF PLY_AKG_Rom
                ;Skips the variables below, if there are present.
                                        IFDEF PLY_AKS_UseEffect_ArpeggioTableOrPitchTable       ;CONFIG SPECIFIC
                jr PLY_AKG_Channel{channelNumber}_AfterArpeggioPitchVariables
                                        ENDIF ;PLY_AKS_UseEffect_ArpeggioTableOrPitchTable
        ENDIF ;PLY_AKG_Rom
                                ENDIF ;PLY_CFG_UseEffect_PitchGlide
        ;A small place to stash some vars which have to be within relative range. Dirty, but no choice.
        ;Note that the vars just below are duplicated due to the conditional assembling (they are a bit above).
        IFNDEF PLY_AKG_Rom
                                IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
dkbs (void):    ;Disark macro.
PLY_AKG_Channel{channelNumber}_ArpeggioTableSpeed: db 0
PLY_AKG_Channel{channelNumber}_ArpeggioBaseSpeed: db 0
PLY_AKG_Channel{channelNumber}_ArpeggioTableBase: dw 0
dkbe (void):    ;Disark macro.
                                ENDIF ;PLY_AKS_UseEffect_Arpeggio
                                IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
dkbs (void):    ;Disark macro.
PLY_AKG_Channel{channelNumber}_PitchTableSpeed: db 0
PLY_AKG_Channel{channelNumber}_PitchBaseSpeed: db 0
PLY_AKG_Channel{channelNumber}_PitchTableBase: dw 0
dkbe (void):    ;Disark macro.
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
PLY_AKG_Channel{channelNumber}_AfterArpeggioPitchVariables:
        ENDIF ;PLY_AKG_Rom

                                IFDEF PLY_CFG_UseEffect_PitchGlide        ;CONFIG SPECIFIC
PLY_AKG_Channel{channelNumber}_Glide_BeforeEnd:
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_Glide_SaveHL: ld hl,0               ;Restores HL.
        ELSE
        ld hl,(PLY_AKG_Channel{channelNumber}_Glide_SaveHL)
        ENDIF
PLY_AKG_Channel{channelNumber}_Glide_End:
                                ENDIF ;PLY_CFG_UseEffect_PitchGlide
                        
                                IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld c,ixl                                        ;Restores C (arp), saved before.
                                ENDIF ;PLY_AKS_UseEffect_Arpeggio

PLY_AKG_Channel{channelNumber}_Pitch_End:
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
                        
                        
        add hl,de                               ;Adds the Pitch Table value.
        ld (PLY_AKG_Channel{channelNumber}_GeneratedCurrentPitch + PLY_AKG_Offset1b),hl
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld a,c
        ld (PLY_AKG_Channel{channelNumber}_GeneratedCurrentArpNote + PLY_AKG_Offset1b),a
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio

        ENDM ;PLY_AKG_ApplyTrailingEffects

        ;Applies the macro for each channel.
        PLY_AKG_ApplyTrailingEffects 1
        PLY_AKG_ApplyTrailingEffects 2
        PLY_AKG_ApplyTrailingEffects 3













        ;The stack must NOT be diverted during the Play Streams!
        ld sp,(PLY_AKG_SaveSP + PLY_AKG_Offset1b)


;-------------------------------------------------------------------------------------
;Plays the instrument on channel 1, 2, 3. The PSG registers related to the channels are set.
;A macro is used instead of duplicating the code.
;-------------------------------------------------------------------------------------

        MACRO PLY_AKG_PlayInstrument channelNumber

        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_PlayInstrument_RelativeModifierAddress:                   ;This must be placed at the any location to allow reaching the variables via IX/IY.
        ENDIF
        
        ;What note to play?
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_GeneratedCurrentPitch: ld hl,0 ;The pitch to add to the real note, according to the Pitch Table + Pitch/Glide effect.
        ELSE
        ld hl,(PLY_AKG_Channel{channelNumber}_GeneratedCurrentPitch)
        ENDIF
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_TrackNote: ld a,0
PLY_AKG_Channel{channelNumber}_GeneratedCurrentArpNote: add 0                           ;Adds the arpeggio value.
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_TrackNote)
        ld e,a
        ld a,(PLY_AKG_Channel{channelNumber}_GeneratedCurrentArpNote)
        add a,e
        ENDIF
                ld e,a
                ld d,0
                        ELSE ;PLY_AKS_UseEffect_Arpeggio
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel{channelNumber}_TrackNote: ld de,0               ;Not automodified, stays this way.
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_TrackNote)        ;In ROM, MUST pass by a variable anyway to be analog to if Arpeggio is used (see above).
        ld e,a
        ld d,0
        ENDIF
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
        exx
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_InstrumentStep: ld iyl,0
dknr3 (void):
PLY_AKG_Channel{channelNumber}_PtInstrument: ld hl,0       ;Instrument data to read (past the header).
                if {channelNumber} == 1         ;Different code for the first channel.
PLY_AKG_Channel{channelNumber}_GeneratedCurrentInvertedVolume: ld de,%11100000 * 256 + 15             ;R7, shift twice TO THE LEFT. By default, the noise is cut (111), the sound is on (most usual case).
                else
PLY_AKG_Channel{channelNumber}_GeneratedCurrentInvertedVolume: ld e,15
                nop                     ;Stupid, but required for relative registers to reach addresses independently of the channels.
                endif
        ELSE
        ld a,(PLY_AKG_Channel{channelNumber}_InstrumentStep)
        ld iyl,a
        ld hl,(PLY_AKG_Channel{channelNumber}_PtInstrument)
        ld a,(PLY_AKG_Channel{channelNumber}_GeneratedCurrentInvertedVolume)
        ld e,a
        if {channelNumber} == 1
                ;For the first channel, sets the R7 value to no noise, all channel on by default ().
                ld d,%11100000
        endif
        ENDIF
        
;       D = Reg7
;       E = inverted volume.
;       D' = 0, E' = note (instrument + Track transposition).
;       HL' = track pitch.

        call PLY_AKG_ReadInstrumentCell

        ;The new and increased Instrument pointer is stored only if its speed has been reached.
        IFDEF PLY_AKG_Rom
        ld a,(PLY_AKG_Channel{channelNumber}_InstrumentSpeed)
        ld b,a
        ENDIF
        ld a,iyl
        inc a
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel{channelNumber}_InstrumentSpeed: cp 0          ;(>0)
        ELSE
        cp b
        ENDIF
        jr c,PLY_AKG_Channel{channelNumber}_SetInstrumentStep         ;Checks C, not only NZ because since the speed can be changed via an effect, the step can get beyond the limit, this must be taken in account.
        ;The speed is reached. We can go to the next line on the next frame.
        ld (PLY_AKG_Channel{channelNumber}_PtInstrument + PLY_AKG_Offset1b),hl
        xor a
PLY_AKG_Channel{channelNumber}_SetInstrumentStep:
        ld (PLY_AKG_Channel{channelNumber}_InstrumentStep + PLY_AKG_Offset2b),a

        
        ;Saves the software period and volume for the PSG to send later.
        ld a,e
        ld (PLY_AKG_PSGReg{{channelNumber} + 7}),a          ;Reaches register/label 8/9/10.
        
        if {channelNumber} != 3
                IFDEF PLY_AKG_HARDWARE_CPC
                        srl d           ;Shift D to the right to let room for the other channels. Use SRL, not RR, to make sure bit 6 is 0 at the end (else, no more keyboard on CPC!).
                ELSE
                        IFDEF PLY_AKG_HARDWARE_MSX
                                if {channelNumber} == 1
                                        srl d           ;R7 bit 6 on MSX must be 0.
                                else
                                        scf             ;R7 bit 7 on MSX must be 1.
                                        rr d
                                endif
                        ELSE
                                rr d            ;On other platform, we don't care.
                        ENDIF
                ENDIF


        else
                ;Gets the R7.
                ld a,d
        endif
        
        exx
                if {channelNumber} == 1
                        ld (PLY_AKG_PSGReg01_Instr + PLY_AKG_Offset1b),hl
                elseif {channelNumber} == 2
                        ld (PLY_AKG_PSGReg23_Instr + PLY_AKG_Offset1b),hl
                elseif {channelNumber} == 3
                        ld (PLY_AKG_PSGReg45_Instr + PLY_AKG_Offset1b),hl
                endif

        ENDM ;PLY_AKG_PlayInstrument
     
        
        ;Generates the code for all channels using the macro above.
        PLY_AKG_PlayInstrument 1
        PLY_AKG_PlayInstrument 2
        PLY_AKG_PlayInstrument 3
        
        
        
 
          
;Plays the sound effects, if desired.
;-------------------------------------------
        IFDEF PLY_AKG_MANAGE_SOUND_EFFECTS
                ;IN : A = R7
                ;OUT: A = R7, possibly modified.
                call PLY_AKG_PlaySoundEffectsStream
        ENDIF ;PLY_AKG_MANAGE_SOUND_EFFECTS
     


; -----------------------------------------------------------------------------------
; PSG access.
; -----------------------------------------------------------------------------------

;Sends the registers to the PSG. Only general registers are sent, the specific ones have already been sent.
;IN:    A = R7.
PLY_AKG_SendPSGRegisters:
        IFDEF PLY_AKG_HARDWARE_CPC
dknr3 (void):   ld bc,#f680
                ld e,#c0
        	out (c),e	;#f6c0          ;Madram's trick requires to start with this. out (c),b works, but will activate K7's relay! Not clean.
        exx
dknr3 (void):   ld bc,#f401                     ;C is the PSG register.

        ;Register 0 and 1.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg01_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg01_Instr)
        ENDIF
        out (c),0                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),l                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),h                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
     
        ;Register 2 and 3.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg23_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg23_Instr)
        ENDIF
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),l                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),h                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        ;Register 4 and 5.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg45_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg45_Instr)
        ENDIF
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),l                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),h                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        ;Register 6.
                        IFDEF PLY_AKG_Use_NoiseRegister         ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg6_8_Instr: ld hl,0          ;L is R6, H is R8. Faster to set a 16 bits register than 2 8-bit.
PLY_AKG_PSGReg6: equ PLY_AKG_PSGReg6_8_Instr + 1
PLY_AKG_PSGReg8: equ PLY_AKG_PSGReg6_8_Instr + 2
        ELSE
        ld hl,(PLY_AKG_PSGReg6_8_Instr)
        ENDIF
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),l                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
                        ELSE
                ;No noise. But R8 must still be set.
        IFNDEF PLY_AKG_Rom
PLY_AKG_PSGReg8_Instr: ld h,0
PLY_AKG_PSGReg8: equ PLY_AKG_PSGReg8_Instr + 1
        ELSE
        ld hl,(PLY_AKG_PSGReg6_8_Instr) ;L was not useful, but A must not be modified yet.
        ENDIF
                inc c
                        ENDIF ;PLY_AKG_Use_NoiseRegister
                                
        ;Register 7. The value is A.
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),a                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        ;Register 8. The value is loaded above via HL.
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),h                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx

        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg9_10_Instr: ld hl,0          ;L is R9, H is R10. Faster to set a 16 bits register than 2 8-bit.
PLY_AKG_PSGReg9: equ PLY_AKG_PSGReg9_10_Instr + 1
PLY_AKG_PSGReg10: equ PLY_AKG_PSGReg9_10_Instr + 2
        ELSE
        ld hl,(PLY_AKG_PSGReg9_10_Instr)
        ENDIF
        ;Register 9.
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),l                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
        ;Register 10.
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),h                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
        
                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        ;Register 11 and 12.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGHardwarePeriod_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGHardwarePeriod_Instr)
        ENDIF
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),l                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx  

        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),h                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        exx
                        ENDIF ;PLY_CFG_UseHardwareSounds
        ENDIF
        IFDEF PLY_AKG_HARDWARE_SPECTRUM_OR_PENTAGON
        
        ex af,af'       ;Saves R7.
dknr3 (void): ld de,#bfff
dknr3 (void): ld bc,#fffd
        
        ld a,1          ;Register.
        
        ;Register 0 and 1.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg01_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg01_Instr)
        ENDIF
        out (c),0       ;#fffd + register.
        ld b,d
        out (c),l       ;#bffd + value
        ld b,e
        
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
      
        ;Register 2 and 3.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg23_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg23_Instr)
        ENDIF
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),l       ;#bffd + value
        ld b,e
        
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
        
        ;Register 4 and 5.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg45_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg45_Instr)
        ENDIF
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),l       ;#bffd + value
        ld b,e
        
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
        
        ;Register 6.
                        IFDEF PLY_AKG_Use_NoiseRegister         ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg6_8_Instr: ld hl,0          ;L is R6, H is R8. Faster to set a 16 bits register than 2 8-bit.
PLY_AKG_PSGReg6: equ PLY_AKG_PSGReg6_8_Instr + 1
PLY_AKG_PSGReg8: equ PLY_AKG_PSGReg6_8_Instr + 2
        ELSE
        ld hl,(PLY_AKG_PSGReg6_8_Instr)
        ENDIF
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),l       ;#bffd + value
        ld b,e
                        ELSE
                ;No noise. But R8 must still be set.
        IFNDEF PLY_AKG_Rom
PLY_AKG_PSGReg8_Instr: ld h,0
PLY_AKG_PSGReg8: equ PLY_AKG_PSGReg8_Instr + 1
        ELSE
        ld hl,(PLY_AKG_PSGReg6_8_Instr)         ;L not useful, but A needs to be not modified.
        ENDIF
                inc a
                        ENDIF ;PLY_AKG_Use_NoiseRegister
     
        ;Register 7. The value is A.
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        ex af,af'       ;Retrieves R7.
        out (c),a       ;#bffd + value
        ex af,af'
        ld b,e
        
        ;Register 8. The value is loaded above via HL.
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
        
        ;Register 9 and 10.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg9_10_Instr: ld hl,0
PLY_AKG_PSGReg9: equ PLY_AKG_PSGReg9_10_Instr + 1
PLY_AKG_PSGReg10: equ PLY_AKG_PSGReg9_10_Instr + 2
        ELSE
        ld hl,(PLY_AKG_PSGReg9_10_Instr)
        ENDIF
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),l       ;#bffd + value
        ld b,e
        
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
        
                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        ;Register 11 and 12.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGHardwarePeriod_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGHardwarePeriod_Instr)
        ENDIF
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),l       ;#bffd + value
        ld b,e
        
        inc a
        out (c),a       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
                        ENDIF ;PLY_CFG_UseHardwareSounds

        ENDIF
        IFDEF PLY_AKG_HARDWARE_MSX
       
        ld b,a          ;Preserves R7.
        ld a,7
        out (#a0),a     ;Register.
        ld a,b
        out (#a1),a     ;Value.

        IFNDEF PLY_AKG_Rom
dknr3 (void):      
PLY_AKG_PSGReg01_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg01_Instr)
        ENDIF
        xor a
        out (#a0),a     ;Register.
        ld a,l
        out (#a1),a     ;Value.

        ld a,1
        out (#a0),a     ;Register.
        ld a,h
        out (#a1),a     ;Value.
        
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg23_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg23_Instr)
        ENDIF
        ld a,2
        out (#a0),a     ;Register.
        ld a,l
        out (#a1),a     ;Value.

        ld a,3
        out (#a0),a     ;Register.
        ld a,h
        out (#a1),a     ;Value.
        
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg45_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGReg45_Instr)
        ENDIF
        ld a,4
        out (#a0),a     ;Register.
        ld a,l
        out (#a1),a     ;Value.

        ld a,5
        out (#a0),a     ;Register.
        ld a,h
        out (#a1),a     ;Value.
        
        ;Register 6.
                        IFDEF PLY_AKG_Use_NoiseRegister         ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg6_8_Instr: ld hl,0          ;L is R6, H is R8. Faster to set a 16 bits register than 2 8-bit.
PLY_AKG_PSGReg6: equ PLY_AKG_PSGReg6_8_Instr + 1
PLY_AKG_PSGReg8: equ PLY_AKG_PSGReg6_8_Instr + 2
        ELSE
        ld hl,(PLY_AKG_PSGReg6_8_Instr)
        ENDIF
        ld a,6
        out (#a0),a     ;Register.
        ld a,l
        out (#a1),a     ;Value.
        
        ld a,8
        out (#a0),a     ;Register.
        ld a,h
        out (#a1),a     ;Value.
                        ELSE
                ;No noise. Takes care of R8.
                ld a,8
                out (#a0),a     ;Register.
        IFNDEF PLY_AKG_Rom
PLY_AKG_PSGReg8_Instr: ld a,0
PLY_AKG_PSGReg8: equ PLY_AKG_PSGReg8_Instr + 1
        ELSE
        ld a,(PLY_AKG_PSGReg8)
        ENDIF
                out (#a1),a     ;Value.
                        ENDIF ;PLY_AKG_Use_NoiseRegister
        
        ;Register 9 and 10.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGReg9_10_Instr: ld hl,0
PLY_AKG_PSGReg9: equ PLY_AKG_PSGReg9_10_Instr + 1
PLY_AKG_PSGReg10: equ PLY_AKG_PSGReg9_10_Instr + 2
        ELSE
        ld hl,(PLY_AKG_PSGReg9_10_Instr)
        ENDIF
        ld a,9
        out (#a0),a     ;Register.
        ld a,l
        out (#a1),a     ;Value.
        
        ld a,10
        out (#a0),a     ;Register.
        ld a,h
        out (#a1),a     ;Value.
        
                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        ;Register 11 and 12.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PSGHardwarePeriod_Instr: ld hl,0
        ELSE
        ld hl,(PLY_AKG_PSGHardwarePeriod_Instr)
        ENDIF
        ld a,11
        out (#a0),a     ;Register.
        ld a,l
        out (#a1),a     ;Value.
        
        ld a,12
        out (#a0),a     ;Register.
        ld a,h
        out (#a1),a     ;Value.
                        ENDIF ;PLY_CFG_UseHardwareSounds
        
        ENDIF
        
        
                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        ;R13.
        IFDEF PLY_AKG_HARDWARE_MSX
        ld a,13         ;Selects R13 now, even if not changed, because A will be modified.
        out (#a0),a     ;Register.
        ENDIF
        IFDEF PLY_AKG_HARDWARE_SPECTRUM_OR_PENTAGON
        inc a           ;Selects R13 now, even if not changed, because A will be modified.
        out (c),a       ;#fffd + register.
        ENDIF
                                IFDEF PLY_CFG_UseRetrig         ;CONFIG SPECIFIC
        IFNDEF PLY_AKG_Rom
PLY_AKG_PSGReg13_OldValue: ld a,255
PLY_AKG_Retrig: or 0                    ;0 = no retrig. Else, should be >0xf to be sure the old value becomes a sentinel (i.e. unreachable) value.
PLY_AKG_PSGReg13_Instr: ld l,0          ;Register 13.
        ELSE
        ld a,(PLY_AKG_PSGReg13_Instr)
        ld l,a
        ld a,(PLY_AKG_Retrig)
        ld h,a
        ld a,(PLY_AKG_PSGReg13_OldValue)
        or h
        ENDIF
        cp l                            ;Is the new value still the same? If yes, the new value must not be set again.
        jr z,PLY_AKG_PSGReg13_End
        ;Different R13.
        ld a,l
                                ELSE ;PLY_CFG_UseRetrig
        IFNDEF PLY_AKG_Rom
PLY_AKG_PSGReg13_Instr: ld a,0          ;Register 13.
PLY_AKG_PSGReg13_OldValue: cp 255
        ELSE
        ld a,(PLY_AKG_PSGReg13_OldValue)
        ld l,a
        ld a,(PLY_AKG_PSGReg13_Instr)
        cp l
        ENDIF
        jr z,PLY_AKG_PSGReg13_End
                                ENDIF ;PLY_CFG_UseRetrig         ;CONFIG SPECIFIC
        ld (PLY_AKG_PSGReg13_OldValue + PLY_AKG_Offset1b),a

        
        IFDEF PLY_AKG_HARDWARE_CPC
        inc c
        out (c),c                       ;#f400 + register.
        exx
                out (c),0               ;#f600.
        exx
        out (c),a                       ;#f400 + value.
        exx
                out (c),c               ;#f680.
                out (c),e               ;#f6c0.
        ;exx
        
        ENDIF
        IFDEF PLY_AKG_HARDWARE_MSX
        out (#a1),a     ;Value.
        ENDIF
        IFDEF PLY_AKG_HARDWARE_SPECTRUM_OR_PENTAGON
        ld b,d
        out (c),a       ;#bffd + value
        
        ENDIF
                                IFDEF PLY_CFG_UseRetrig         ;CONFIG SPECIFIC
        xor a
        ld (PLY_AKG_Retrig + PLY_AKG_Offset1b),a
                                ENDIF ;PLY_CFG_UseRetrig
PLY_AKG_PSGReg13_End:
                        ENDIF ;PLY_CFG_UseHardwareSounds
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_SaveSP: ld sp,0
        ELSE
        ld sp,(PLY_AKG_SaveSp)
        ENDIF
        
        ret
        













;Channel1/2/3 sub-codes. Uses a macro to mutualize the code.
;-----------------------------------------------------------

        MACRO PLY_AKG_ChannelSubcodes channelNumber

PLY_AKG_Channel{channelNumber}_MaybeEffects:
        ;There is one wait in all cases.
        ;xor a                  ;A is supposed to be 0.
        ld (PLY_AKG_Channel{channelNumber}_WaitCounter + PLY_AKG_Offset1b),a
                        IFNDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
        jp PLY_AKG_Channel{channelNumber}_BeforeEnd_StoreCellPointer
                        ELSE
        bit 6,c         ;Effects?
        jp z,PLY_AKG_Channel{channelNumber}_BeforeEnd_StoreCellPointer
        ;Manage effects.
        
;Reads the effects.
;IN:    HL = Points on the effect blocks
;OUT:   HL = Points after on the effect blocks
PLY_AKG_Channel{channelNumber}_ReadEffects:
        ld iy,PLY_AKG_Channel{channelNumber}_SoundStream_RelativeModifierAddress
        ld ix,PLY_AKG_Channel{channelNumber}_PlayInstrument_RelativeModifierAddress
        ld de,PLY_AKG_Channel{channelNumber}_BeforeEnd_StoreCellPointer
        ;Only adds a jump if this is not the last channel, as the code only need to jump below.
        if {channelNumber} != 3
                jr PLY_AKG_Channel_ReadEffects
        endif
                        ENDIF ;PLY_CFG_UseEffects
PLY_AKG_Channel{channelNumber}_ReadEffectsEnd:
        ENDM ;PLY_AKG_ChannelSubcodes

        ;Generates the code thanks to the macro declare above.
        PLY_AKG_ChannelSubcodes 1
        PLY_AKG_ChannelSubcodes 2
        PLY_AKG_ChannelSubcodes 3

        ;** NO CODE between the code above and below! **
                    
                        IFDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
;IN:    HL = Points on the effect blocks
;       DE = Where to go to when over.
;       IX = Address from which the data of the instrument are modified.
;       IY = Address from which data of the channels (pitch, volume, etc) are modified.
;OUT:   HL = Points after on the effect blocks
PLY_AKG_Channel_ReadEffects:
        assert $ == PLY_AKG_Channel3_ReadEffectsEnd             ;Makes sure this code is directly below the one above.
        
        IFNDEF PLY_AKG_Rom
                ld (PLY_AKG_Channel_ReadEffects_EndJump + PLY_AKG_Offset1b),de
        ELSE
                ld (PLY_AKG_Channel_ReadEffects_EndJumpInstrAndAddress + 1),de
        ENDIF
        ;HL will be very useful, so we store the pointer in DE.
        ex de,hl

        ;Reads the effect block. It may be an index or a relative address.        
        ld a,(de)
        inc de
        sla a
        jr c,PLY_AKG_Channel_ReadEffects_RelativeAddress
        ;Index.
        exx
                ld l,a
                ld h,0

        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel_ReadEffects_EffectBlocks1: ld de,0
        ELSE
        ld de,(PLY_AKG_Channel_ReadEffects_EffectBlocks1)
        ENDIF
                add hl,de               ;The index is already *2.
                ld e,(hl)               ;Gets the address referred by the table.
                inc hl
                ld d,(hl)
PLY_AKG_Channel_RE_EffectAddressKnown:
                ;DE points on the current effect block header/data.
                ld a,(de)               ;Gets the effect number/more effect flag.
                inc de
                ld (PLY_AKG_Channel_RE_ReadNextEffectInBlock + PLY_AKG_Offset1b),a     ;Stores the flag indicating whether there are more effects.
                
                ;Gets the effect number.
                and %11111110
                ld l,a
                ld h,0
                ld sp,PLY_AKG_EffectTable
                add hl,sp                ;Effect is already * 2.
                ld sp,hl                ;Jumps to the effect code.
                ret
                ;All the effects return here.
PLY_AKG_Channel_RE_EffectReturn:
                ;Is there another effect?
        IFNDEF PLY_AKG_Rom
PLY_AKG_Channel_RE_ReadNextEffectInBlock: ld a,0                ;Bit 0 indicates whether there are more effects.
        ELSE
                ld a,(PLY_AKG_Channel_RE_ReadNextEffectInBlock)
        ENDIF
                rra
                jr c,PLY_AKG_Channel_RE_EffectAddressKnown
                ;No more effects.
        exx
        
        ;Put back in HL the point on the Track Cells.
        ex de,hl
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel_ReadEffects_EndJump: jp 0        ;PLY_AKG_Channel1/2/3_BeforeEnd_StoreCellPointer
        ELSE
        jp PLY_AKG_Channel_ReadEffects_EndJumpInstrAndAddress
        ENDIF

PLY_AKG_Channel_ReadEffects_RelativeAddress:
        srl a           ;A was the relative MSB. Only 7 relevant bits.
        exx
                ld h,a
        exx
        ld a,(de)       ;Reads the relative LSB.
        inc de
        exx
                ld l,a
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Channel_ReadEffects_EffectBlocks2: ld de,0
        ELSE
        ld de,(PLY_AKG_Channel_ReadEffects_EffectBlocks1)       ;In ROM, reads the first value, it is the same. Duplicating it is only an optimization for RAM player to avoid reading memory.
        ENDIF
                add hl,de
                jr PLY_AKG_Channel_RE_EffectAddressKnown
                        ENDIF ;PLY_CFG_UseEffects





;---------------------------------
;Codes that read InstrumentCells.
;IN:    HL = pointer on the Instrument data cell to read.
;       IX = can be modified.
;       IYL = Instrument step (>=0). Useful for retrig.
;       SP = normal use of the stack, do not pervert it!
;       D = register 7, as if it was the channel 3 (so, bit 2 and 5 filled only).
;             By default, the noise is OFF, the sound is ON, so no need to do anything if these values match.
;       E = inverted volume.
;       A = SET BELOW: first byte of the data, shifted of 3 bits to the right.
;       B = SET BELOW: first byte of the data, unmodified.
;       HL' = track pitch.
;       DE' = 0 / note (instrument + Track transposition).
;       BC' = temp, use at will.

;OUT:   HL = new pointer on the Instrument (may be on the empty sound). If not relevant, any value can be returned, it doesn't matter.
;       IYL = Not 0 if retrig for this channel.
;       D = register 7, updated, as if it was the channel 1 (so, bit 2 and 5 filled only).
;       E = volume to encode (0-16).
;       HL' = software period. If not relevant, do not set it.
;       DE' = output period.

PLY_AKG_BitForSound: equ 2
PLY_AKG_BitForNoise: equ 5


PLY_AKG_ReadInstrumentCell:
        ld a,(hl)               ;Gets the first byte of the cell.
        inc hl
        ld b,a                  ;Stores the first byte, handy in many cases.
        
        ;What type if the cell?
        rra
        jp c,PLY_AKG_S_Or_H_Or_SaH_Or_EndWithLoop
        ;No Soft No Hard, or Soft To Hard, or Hard To Soft, or End without loop.
        rra
        IFNDEF PLY_AKG_Rom
                jr c,PLY_AKG_StH_Or_EndWithoutLoop
        ELSE
                jp c,PLY_AKG_StH_Or_EndWithoutLoop
        ENDIF
        ;No Soft No Hard, or Hard to Soft.
        rra
                        IFDEF PLY_CFG_HardToSoft       ;CONFIG SPECIFIC
        jr c,PLY_AKG_HardToSoft
                        ENDIF ;PLY_CFG_HardToSoft
        
        
        
        
        
        
        ;-------------------------------------------------
        ;"No soft, no hard".
        ;-------------------------------------------------
PLY_AKG_NoSoftNoHard:
        and %1111               ;Necessary, we don't know what crap is in the 4th bit of A.
        sub e                   ;Decreases the volume, watching for overflow.
        jr nc,$ + 3
        xor a
        
        ld e,a                  ;Sets the volume.

                        IFDEF PLY_CFG_NoSoftNoHard_Noise                ;CONFIG SPECIFIC
        rl b            ;Noise?
        jr nc,PLY_AKG_NSNH_NoNoise
        ;Noise.
        ld a,(hl)
        inc hl
        ld (PLY_AKG_PSGReg6),a
        set PLY_AKG_BitForSound,d      ;Noise, no sound (both non-default values).
        res PLY_AKG_BitForNoise,d
        ret
PLY_AKG_NSNH_NoNoise:
                        ENDIF ;PLY_CFG_NoSoftNoHard_Noise
        set PLY_AKG_BitForSound,d      ;No noise (default), no sound.
        ret







        ;-------------------------------------------------
        ;"Soft only".
        ;-------------------------------------------------
                        IFDEF PLY_CFG_SoftOnly          ;CONFIG SPECIFIC
PLY_AKG_Soft:
        ;Calculates the volume.
        and %1111               ;Necessary, we don't know what crap is in the 4th bit of A.
        
        sub e                   ;Decreases the volume, watching for overflow.
        jr nc,$ + 3             ;Checks for overflow.
        xor a
    
        ld e,a                  ;Sets the volume.
                        ENDIF ;PLY_CFG_SoftOnly
                        IFDEF PLY_AKG_UseSoftOnlyOrHardOnly     ;CONFIG SPECIFIC
PLY_AKG_SoftOnly_HardOnly_TestSimple_Common:        ;This code is also used by "Hard only".
        ;Simple sound? Gets the bit, let the subroutine do the job.
        rl b
        jr nc,PLY_AKG_S_NotSimple
        ;Simple.
        ld c,0                  ;This will force the noise to 0.
        jr PLY_AKG_S_AfterSimpleTest
PLY_AKG_S_NotSimple:
        ;Not simple. Reads and keeps the next byte, containing the noise. WARNING, the following code must NOT modify the Carry!
        ld b,(hl)
        ld c,b
        inc hl
PLY_AKG_S_AfterSimpleTest:

        call PLY_AKG_S_Or_H_CheckIfSimpleFirst_CalculatePeriod
        
                                IFDEF PLY_AKG_UseSoftOnlyOrHardOnly_Noise       ;CONFIG SPECIFIC
        ;Noise?
        ld a,c
        and %11111
        ret z                                   ;if noise not present, sound present, we can stop here, R7 is fine.
        ;Noise is present.
        ld (PLY_AKG_PSGReg6),a
        res PLY_AKG_BitForNoise,d               ;Noise present.
                                ENDIF ;PLY_AKG_UseSoftOnlyOrHardOnly_Noise
        ret
                        ENDIF ;PLY_AKG_UseSoftOnlyOrHardOnly
        




        ;-------------------------------------------------
        ;"Hard to soft".
        ;-------------------------------------------------
                        IFDEF PLY_CFG_HardToSoft       ;CONFIG SPECIFIC
PLY_AKG_HardToSoft:
        call PLY_AKG_StoH_HToS_SandH_Common
        ;We have the ratio jump calculated and the primary period too. It must be divided to get the software frequency.
        
        IFNDEF PLY_AKG_Rom
        ld (PLY_AKG_HS_JumpRatio + 1),a
        ELSE
        ;Stores where to jump after the JumpRatio label. Only BC' is free...
        exx
                ld bc,PLY_AKG_HS_JumpRatio
                add a,c
                ld c,a
                ld a,b
                adc a,0
                ld b,a
                ld (PLY_AKG_TempPlayInstrumentJumpInstrAndAddress + 1),bc         ;The first byte has a jump.
        exx
        ENDIF
        
        ;Gets B, we need the bit to know if a software pitch shift is added.
                                IFDEF PLY_CFG_HardToSoft_SoftwarePitch  ;CONFIG SPECIFIC
        ld a,b
                                ENDIF ;PLY_CFG_HardToSoft_SoftwarePitch
        exx
                ;The hardware period can be stored.
                ld (PLY_AKG_PSGHardwarePeriod_Instr + PLY_AKG_Offset1b),hl
        IFNDEF PLY_AKG_Rom
PLY_AKG_HS_JumpRatio: jr $ + 2               ;Automodified by the line above to jump on the right code.
        ELSE
                jp PLY_AKG_TempPlayInstrumentJumpInstrAndAddress        ;If ROM, jumps to the buffer, it will jump back just after according to the ratio.
PLY_AKG_HS_JumpRatio:
        ENDIF
                sla l
                rl h
                sla l
                rl h
                sla l
                rl h
                sla l
                rl h
                sla l
                rl h
                sla l
                rl h
                sla l
                rl h
                ;Any Software pitch shift?
                                IFDEF PLY_CFG_HardToSoft_SoftwarePitch  ;CONFIG SPECIFIC
                rla
                jr nc,PLY_AKG_SH_NoSoftwarePitchShift
;Pitch shift. Reads it.
        exx
        ld a,(hl)
        inc hl
        exx
                add a,l
                ld l,a
        exx
        ld a,(hl)
        inc hl
        exx
                adc a,h
                ld h,a        
PLY_AKG_SH_NoSoftwarePitchShift:
                                ENDIF ;PLY_CFG_HardToSoft_SoftwarePitch
        exx
        
        ret
                        ENDIF ;PLY_CFG_HardToSoft
        


        ;-------------------------------------------------
        ;End without loop. Put here to satisfy the JR range below.
        ;-------------------------------------------------
PLY_AKG_EndWithoutLoop:
        ;Loops to the "empty" instrument, and makes another iteration.
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_EmptyInstrumentDataPt: ld hl,0
        ELSE
        ld hl,(PLY_AKG_EmptyInstrumentDataPt)
        ENDIF
        ;No need to read the data, consider a void value.
        inc hl
        xor a
        ld b,a
        IFNDEF PLY_AKG_Rom
                jr PLY_AKG_NoSoftNoHard
        ELSE
                jp PLY_AKG_NoSoftNoHard
        ENDIF
        
        
        
        ;-----------------------------------------
PLY_AKG_StH_Or_EndWithoutLoop:
        rra
                        IFNDEF PLY_CFG_SoftToHard                ;CONFIG SPECIFIC
        jr PLY_AKG_EndWithoutLoop
                        ELSE
        jr c,PLY_AKG_EndWithoutLoop
        
        ;-------------------------------------------------
        ;"Soft to Hard".
        ;-------------------------------------------------
                        
        call PLY_AKG_StoH_HToS_SandH_Common
        ;We have the ratio jump calculated and the primary period too. It must be divided to get the hardware frequency.

        IFNDEF PLY_AKG_Rom
        ld (PLY_AKG_SH_JumpRatio + 1),a
        ELSE
        ;Stores where to jump after the JumpRatio label. Only BC' is free...
        exx
                ld bc,PLY_AKG_SH_JumpRatio
                add a,c
                ld c,a
                ld a,b
                adc a,0
                ld b,a
                ld (PLY_AKG_TempPlayInstrumentJumpInstrAndAddress + 1),bc         ;The first byte has a jump.
        exx
        ENDIF
        
        ;Gets B, we need the bit to know if a hardware pitch shift is added.
                                IFDEF PLY_CFG_SoftToHard_HardwarePitch          ;CONFIG SPECIFIC
        ld a,b
                                ENDIF ;PLY_CFG_SoftToHard_HardwarePitch
        exx
                ;Saves the original frequency in DE.
                ld e,l
                ld d,h
        IFNDEF PLY_AKG_Rom
PLY_AKG_SH_JumpRatio: jr $ + 2               ;Automodified by the line above to jump on the right code.
        ELSE
                jp PLY_AKG_TempPlayInstrumentJumpInstrAndAddress        ;If ROM, jumps to the buffer, it will jump back just after according to the ratio.
PLY_AKG_SH_JumpRatio:
        ENDIF
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                jr nc,PLY_AKG_SH_JumpRatioEnd
                inc hl
PLY_AKG_SH_JumpRatioEnd:
                                IFDEF PLY_CFG_SoftToHard_HardwarePitch          ;CONFIG SPECIFIC
                ;Any Hardware pitch shift?
                rla
                jr nc,PLY_AKG_SH_NoHardwarePitchShift
                ;Pitch shift. Reads it.
        exx
        ld a,(hl)
        inc hl
        exx
                add a,l
                ld l,a
        exx
        ld a,(hl)
        inc hl
        exx
                adc a,h
                ld h,a        
PLY_AKG_SH_NoHardwarePitchShift:
                                ENDIF ;PLY_CFG_SoftToHard_HardwarePitch
                ld (PLY_AKG_PSGHardwarePeriod_Instr + PLY_AKG_Offset1b),hl
                
                ;Put back the frequency in HL.
                ex de,hl
        exx
        
        ret
                        ENDIF ;PLY_CFG_SoftToHard
        
        
        
       
PLY_AKG_S_Or_H_Or_SaH_Or_EndWithLoop:
        ;Second bit of the type.
        rra
        jr c,PLY_AKG_H_Or_EndWithLoop
        ;Third bit of the type.
        rra
                        IFDEF PLY_CFG_SoftOnly          ;CONFIG SPECIFIC
        jp nc,PLY_AKG_Soft
                        ENDIF ;PLY_CFG_SoftOnly
        
                        IFDEF PLY_CFG_SoftAndHard       ;CONFIG SPECIFIC
        ;-------------------------------------------------
        ;"Soft and Hard".
        ;-------------------------------------------------
        exx
                push hl         ;Saves the note and track pitch, because the first pass below will modify it, we need it for the second pass.
                push de
        exx
        
        call PLY_AKG_StoH_HToS_SandH_Common
        ;We have now calculated the hardware frequency. Stores it.
        exx
                ld (PLY_AKG_PSGHardwarePeriod_Instr + PLY_AKG_Offset1b),hl
                
                pop de          ;Get back the note and track pitch for the second pass.
                pop hl
        exx
        
        
        ;Now calculate the software frequency.
        rl b            ;Simple sound? Used by the sub-code.
        jp PLY_AKG_S_Or_H_CheckIfSimpleFirst_CalculatePeriod    ;That's all!
                        ENDIF ;PLY_CFG_SoftAndHard
                
        
        

        
PLY_AKG_H_Or_EndWithLoop:
                        IFDEF PLY_CFG_HardOnly          ;CONFIG SPECIFIC
        ;Third bit of the type. Only used for HardOnly, not in case of EndWithLoop.
        rra
                                IFDEF PLY_CFG_UseInstrumentLoopTo       ;CONFIG SPECIFIC
        ;Ok to remove this jump if PLY_CFG_HardOnly variable absent, it will directly go to the code below.
        jr c,PLY_AKG_EndWithLoop
                                ENDIF

        ;-------------------------------------------------
        ;"Hard only".
        ;-------------------------------------------------
        
        ld e,16                 ;Sets the hardware volume.

        ;Retrig?
        rra
                                IFDEF PLY_CFG_HardOnly_Retrig           ;CONFIG SPECIFIC
        jr nc,PLY_AKG_H_AfterRetrig
        ld c,a
        ;Retrig is only set if we are on the first step of the instrument!
        ld a,iyl
        or a
        jr nz,PLY_AKG_H_RetrigEnd
        ld a,e
        ld (PLY_AKG_Retrig + PLY_AKG_Offset1b),a
PLY_AKG_H_RetrigEnd:
        ld a,c
PLY_AKG_H_AfterRetrig:
                                ENDIF ;PLY_CFG_HardOnly_Retrig

        ;Calculates the hardware envelope. The value given is from 8-15, but encoded as 0-7.
        and %111
        add a,8
        ld (PLY_AKG_PSGReg13_Instr + PLY_AKG_Offset1b),a

        ;Use the code of Soft Only to calculate the period and the noise.
        call PLY_AKG_SoftOnly_HardOnly_TestSimple_Common

        ;The period is actually an hardware period. We don't care about the software period, the sound channel is cut.
        exx
                ld (PLY_AKG_PSGHardwarePeriod_Instr + PLY_AKG_Offset1b),hl
        exx
        
        ;Stops the sound.
        set PLY_AKG_BitForSound,d

        ret
                        ENDIF ;PLY_CFG_HardOnly
        
        ;** WARNING! ** Do not put instructions here between HardOnly and EndWithLoop, else conditional assembling will fail.
        
        ;-------------------------------------------------
        ;End with loop.
        ;-------------------------------------------------
                        IFDEF PLY_CFG_UseInstrumentLoopTo       ;CONFIG SPECIFIC
PLY_AKG_EndWithLoop:
        ;Loops to the encoded pointer, and makes another iteration.
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        jp PLY_AKG_ReadInstrumentCell
                        ENDIF ;PLY_CFG_UseInstrumentLoopTo
                        



     
;Common code for calculating the period, regardless of Soft or Hard. The same register constraints as the methods above apply.
;IN:    HL = the next bytes to read.
;       HL' = note + transposition.
;       B = contains three bits:
;               b7: forced period? (if yes, the two other bits are irrelevant)
;               b6: arpeggio?
;               b5: pitch?
;       C = do not modify.
;       Carry: Simple sound?
;OUT:   B = shift three times to the left.
;       C = unmodified.
;       HL = advanced.
;       HL' = calculated period.
PLY_AKG_S_Or_H_CheckIfSimpleFirst_CalculatePeriod:

        ;Simple sound? Checks the carry.
                        IFDEF PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs     ;CONFIG SPECIFIC
        jr nc,PLY_AKG_S_Or_H_NextByte
                        ENDIF ;PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs
        ;No more bytes to read, the sound is "simple". The software period must still be calculated.
        ;Calculates the note period from the note of the track. This is the same code as below.
        exx
                ex de,hl                        ;Now HL = track note + transp, DE is track pitch.
                add hl,hl
                ld bc,PLY_AKG_PeriodTable
                add hl,bc
           
                ld a,(hl)
                inc hl
                ld h,(hl)
                ld l,a
                add hl,de                       ;Adds the track pitch.
        exx
        ;Important: the bits must be shifted so that B is in the same state as if it were not a "simple" sound.
        rl b
        rl b
        rl b
        ;No need to modify R7.
        ret
        
                        IFDEF PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs     ;CONFIG SPECIFIC
PLY_AKG_S_Or_H_NextByte:
        ;Not simple. Reads the next bits to know if there is pitch/arp/forced software period.        
        ;Forced period?
        rl b
                        IFDEF PLY_AKG_UseInstrumentForcedPeriods          ;CONFIG SPECIFIC
        jr c,PLY_AKG_S_Or_H_ForcedPeriod
                        ENDIF ;PLY_AKG_UseInstrumentForcedPeriods
        ;No forced period. Arpeggio?
        rl b
                        IFDEF PLY_AKG_UseInstrumentArpeggios              ;CONFIG SPECIFIC
        jr nc,PLY_AKG_S_Or_H_AfterArpeggio
        ld a,(hl)
        inc hl
        exx
                add a,e                         ;We don't care about overflow, no time for that.
                ld e,a
        exx
PLY_AKG_S_Or_H_AfterArpeggio:
                        ENDIF ;PLY_AKG_UseInstrumentArpeggios
        ;Pitch?
        rl b
                        IFDEF PLY_AKG_UseInstrumentPitchs                 ;CONFIG SPECIFIC
        jr nc,PLY_AKG_S_Or_H_AfterPitch
        ;Reads the pitch. Slow, but shouldn't happen so often.
        ld a,(hl)
        inc hl
        exx
                add a,l
                ld l,a                          ;Adds the cell pitch to the track pitch, in two passes.
        exx
        ld a,(hl)
        inc hl
        exx
                adc a,h
                ld h,a
        exx
PLY_AKG_S_Or_H_AfterPitch:
                        ENDIF ;PLY_AKG_UseInstrumentPitchs
        
        ;Calculates the note period from the note of the track.
        exx
                ex de,hl                        ;Now HL = track note + transp, DE is track pitch.
                add hl,hl
                ld bc,PLY_AKG_PeriodTable
                add hl,bc
                
                ld a,(hl)
                inc hl
                ld h,(hl)
                ld l,a
                add hl,de                       ;Adds the track pitch.
        exx

        ret
                        ENDIF ;PLY_AKG_UseInstrumentForcedPeriodsOrArpeggiosOrPitchs


                        IFDEF PLY_AKG_UseInstrumentForcedPeriods          ;CONFIG SPECIFIC
PLY_AKG_S_Or_H_ForcedPeriod:
        ;Reads the period. A bit slow, but doesn't happen often.
        ld a,(hl)
        inc hl
        exx
                ld l,a
        exx
        ld a,(hl)
        inc hl
        exx
                ld h,a
        exx

        ;The pitch and arpeggios have been skipped, since the period is forced, the bits must be compensated.
        rl b
        rl b
        ret
                        ENDIF ;PLY_AKG_UseInstrumentForcedPeriods
        
        ;------------------------------------------------------------------
;Common code for SoftToHard and HardToSoft, and even Soft And Hard. The same register constraints as the methods above apply.
;OUT:   HL' = frequency.
;       A = shifted inverted ratio (xxx000), ready to be used in a JR to multiply/divide the frequency.
;       B = bit states, shifted four times to the left (for StoH/HtoS, the msb will be "pitch shift?") (hardware for SoftTohard, software for HardToSoft).
                        IFDEF PLY_CFG_UseHardwareSounds                 ;CONFIG SPECIFIC
PLY_AKG_StoH_HToS_SandH_Common:
        ld e,16                 ;Sets the hardware volume.

        ;Retrig?
        rra
                                IFDEF PLY_AKG_UseRetrig_StoH_HtoS_SandH         ;CONFIG SPECIFIC
        jr nc,PLY_AKG_SHoHS_AfterRetrig
        ld c,a
        ;Retrig is only set if we are on the first step of the instrument!
        ld a,iyl
        or a
        jr nz,PLY_AKG_SHoHS_RetrigEnd
        dec a
        ld (PLY_AKG_Retrig + PLY_AKG_Offset1b),a
PLY_AKG_SHoHS_RetrigEnd:
        ld a,c
PLY_AKG_SHoHS_AfterRetrig:
                                ENDIF ;PLY_AKG_UseRetrig_StoH_HtoS_SandH

        ;Calculates the hardware envelope. The value given is from 8-15, but encoded as 0-7.
        and %111
        add a,8
        ld (PLY_AKG_PSGReg13_Instr + PLY_AKG_Offset1b),a
        
        ;Noise? If yes, reads the next byte.
        rl b
                                IFDEF PLY_AKG_UseNoise_StoH_HtoS_SandH          ;CONFIG SPECIFIC
        jr nc,PLY_AKG_SHoHS_AfterNoise
        ;Noise is present.
        ld a,(hl)
        inc hl
        ld (PLY_AKG_PSGReg6),a
        res PLY_AKG_BitForNoise, d              ;Noise present.
PLY_AKG_SHoHS_AfterNoise:
                                ENDIF ;PLY_AKG_UseNoise_StoH_HtoS_SandH

        ;Read the next data byte.
        ld c,(hl)               ;C = ratio, kept for later.
        ld b,c
        inc hl
        
        rl b                    ;Simple (no need to test the other bits)? The carry is transmitted to the called code below.
        ;Call another common subcode.
        call PLY_AKG_S_Or_H_CheckIfSimpleFirst_CalculatePeriod
        ;Let's calculate the hardware frequency from it.
        ld a,c                  ;Gets the ratio.
        rla
        rla
        and %11100
        
        ret
                        ENDIF ;PLY_CFG_UseHardwareSounds
        

        




        
; -----------------------------------------------------------------------------------
; Effects management.
; -----------------------------------------------------------------------------------
                        IFDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
;All the effects code.
PLY_AKG_EffectTable:
dkps (void):    ;Disark macro.
                        IFDEF PLY_CFG_UseEffect_Reset           ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_ResetFullVolume                               ;0
        dw PLY_AKG_Effect_Reset                                         ;1
                        ELSE
                dw 0
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_Reset
        
                        IFDEF PLY_CFG_UseEffect_SetVolume       ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_Volume                                        ;2
                        ELSE
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_SetVolume
                        
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_ArpeggioTable                                 ;3
        dw PLY_AKG_Effect_ArpeggioTableStop                             ;4
                        ELSE
                dw 0
                dw 0
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_PitchTable                                    ;5
        dw PLY_AKG_Effect_PitchTableStop                                ;6
                        ELSE
                dw 0
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_PitchTable
                        IFDEF PLY_AKG_UseEffect_VolumeSlide     ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_VolumeSlide                                   ;7
        dw PLY_AKG_Effect_VolumeSlideStop                               ;8
                        ELSE
                dw 0
                dw 0
                        ENDIF ;PLY_AKG_UseEffect_VolumeSlide
        
                        IFDEF PLY_CFG_UseEffect_PitchUp         ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_PitchUp                                       ;9
                        ELSE
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_PitchUp
                        IFDEF PLY_CFG_UseEffect_PitchDown        ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_PitchDown                                     ;10
                        ELSE
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_PitchDown
                        
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide    ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_PitchStop                                     ;11
                        ELSE
                dw 0
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
                        
                        IFDEF PLY_CFG_UseEffect_PitchGlide              ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_GlideWithNote                                 ;12
        dw PLY_AKG_Effect_GlideSpeed                                    ;13
                        ELSE
                dw 0
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_PitchGlide
        
        
                        IFDEF PLY_CFG_UseEffect_Legato          ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_Legato                                        ;14
                        ELSE
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_Legato

                        IFDEF PLY_CFG_UseEffect_ForceInstrumentSpeed            ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_ForceInstrumentSpeed                          ;15
                        ELSE
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_ForceInstrumentSpeed
                        
                        IFDEF PLY_CFG_UseEffect_ForceArpeggioSpeed              ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_ForceArpeggioSpeed                            ;16
                        ELSE
                dw 0
                        ENDIF ;PLY_CFG_UseEffect_ForceArpeggioSpeed
                        
                        IFDEF PLY_CFG_UseEffect_ForcePitchTableSpeed    ;CONFIG SPECIFIC
        dw PLY_AKG_Effect_ForcePitchSpeed                               ;17
                        ENDIF ;PLY_CFG_UseEffect_ForcePitchTableSpeed
                        ;Last effect: no need to use padding with dw.
dkpe (void):    ;Disark macro.
        
;Effects.
;----------------------------------------------------------------
;For all effects:
;IN:    DE' = Points on the data of this effect.
;       IX = Address from which the data of the instrument are modified.
;       IY = Address from which the data of the channels (pitch, volume, etc) are modified.
;       HL = Must NOT be modified.
;       WARNING, we are on auxiliary registers!

;       SP = Can be modified at will.

;OUT:   DE' = Points after on the data of this effect.
;       WARNING, remains on auxiliary registers!
;----------------------------------------------------------------

                        IFDEF PLY_CFG_UseEffect_Reset           ;CONFIG SPECIFIC
PLY_AKG_Effect_ResetFullVolume:
        xor a           ;The inverted volume is 0 (full volume).
        jr PLY_AKG_Effect_ResetVolume_AfterReading
        
PLY_AKG_Effect_Reset:
        ld a,(de)       ;Reads the inverted volume.
        inc de
PLY_AKG_Effect_ResetVolume_AfterReading:
        ld (iy + PLY_AKG_Channel1_InvertedVolumeInteger - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
        
        ;The current pitch is reset.
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide        ;CONFIG SPECIFIC
        xor a
        ld (iy + PLY_AKG_Channel1_Pitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        ld (iy + PLY_AKG_Channel1_Pitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1),a
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide

        ld a,PLY_AKG_OPCODE_OR_A
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide        ;CONFIG SPECIFIC
        ld (iy + PLY_AKG_Channel1_IsPitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        ld (iy + PLY_AKG_Channel1_IsPitchTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
                        ENDIF ;PLY_CFG_UseEffect_PitchTable
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
        ld (iy + PLY_AKG_Channel1_IsArpeggioTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio
                        IFDEF PLY_AKG_UseEffect_VolumeSlide             ;CONFIG SPECIFIC
        ld (iy + PLY_AKG_Channel1_IsVolumeSlide - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
                        ENDIF ;PLY_AKG_UseEffect_VolumeSlide
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_Reset
                        
                        

                        IFDEF PLY_CFG_UseEffect_SetVolume       ;CONFIG SPECIFIC
PLY_AKG_Effect_Volume:
        ld a,(de)       ;Reads the inverted volume.
        inc de
        
        ld (iy + PLY_AKG_Channel1_InvertedVolumeInteger - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
        
                        IFDEF PLY_AKG_UseEffect_VolumeSlide     ;CONFIG SPECIFIC
        ld (iy + PLY_AKG_Channel1_IsVolumeSlide - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_OR_A
                        ENDIF ;PLY_AKG_UseEffect_VolumeSlide
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_SetVolume
        
        
                        IFDEF PLY_AKS_UseEffect_Arpeggio        ;CONFIG SPECIFIC
PLY_AKG_Effect_ArpeggioTable:
        ld a,(de)       ;Reads the arpeggio table index.
        inc de
        
        ;Finds the address of the Arpeggio.
        ld l,a
        ld h,0
        add hl,hl
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_ArpeggiosTable: ld bc,0
        ELSE
        ld bc,(PLY_AKG_ArpeggiosTable)
        ENDIF
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)
        inc hl
        
        ;Reads the speed.
        ld a,(bc)
        inc bc
        ld (iy + PLY_AKG_Channel1_ArpeggioTableSpeed - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0),a
        ld (iy + PLY_AKG_Channel1_ArpeggioBaseSpeed - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0),a
        
        ld (iy + PLY_AKG_Channel1_ArpeggioTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),c
        ld (iy + PLY_AKG_Channel1_ArpeggioTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1),b
        ld (iy + PLY_AKG_Channel1_ArpeggioTableBase - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0),c
        ld (iy + PLY_AKG_Channel1_ArpeggioTableBase - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 1),b
        
        ld (iy + PLY_AKG_Channel1_IsArpeggioTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_SCF
        xor a
        ld (iy + PLY_AKG_Channel1_ArpeggioTableCurrentStep - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        
        jp PLY_AKG_Channel_RE_EffectReturn

PLY_AKG_Effect_ArpeggioTableStop:
        ld (iy + PLY_AKG_Channel1_IsArpeggioTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_OR_A
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_AKS_UseEffect_Arpeggio


                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
;Pitch table. Followed by the Pitch Table index.
PLY_AKG_Effect_PitchTable:
        ld a,(de)       ;Reads the Pitch table index.
        inc de
        
        ;Finds the address of the Pitch.
        ld l,a
        ld h,0
        add hl,hl
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_PitchesTable: ld bc,0
        ELSE
        ld bc,(PLY_AKG_PitchesTable)
        ENDIF
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)
        inc hl
        
        ;Reads the speed.
        ld a,(bc)
        inc bc
        ld (iy + PLY_AKG_Channel1_PitchTableSpeed - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
        ld (iy + PLY_AKG_Channel1_PitchBaseSpeed - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
        
        ld (iy + PLY_AKG_Channel1_PitchTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),c
        ld (iy + PLY_AKG_Channel1_PitchTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1),b
        ld (iy + PLY_AKG_Channel1_PitchTableBase - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0),c
        ld (iy + PLY_AKG_Channel1_PitchTableBase - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 1),b
        
        ld (iy + PLY_AKG_Channel1_IsPitchTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_SCF
        
        xor a
        ld (iy + PLY_AKG_Channel1_PitchTableCurrentStep - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_PitchTable
        
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
;Stops the pitch table.        
PLY_AKG_Effect_PitchTableStop:
        ;Only the pitch is stopped, but the value remains.
        ld (iy + PLY_AKG_Channel1_IsPitchTable - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_OR_A
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_PitchTable

                        IFDEF PLY_AKG_UseEffect_VolumeSlide     ;CONFIG SPECIFIC
;Volume slide effect. Followed by the volume, as a word.
PLY_AKG_Effect_VolumeSlide:
        ld a,(de)               ;Reads the slide.
        inc de
        ld (iy + PLY_AKG_Channel1_VolumeSlideValue - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        ld a,(de)
        inc de
        ld (iy + PLY_AKG_Channel1_VolumeSlideValue - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1),a
        
        ld (iy + PLY_AKG_Channel1_IsVolumeSlide - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_SCF
        jp PLY_AKG_Channel_RE_EffectReturn
        
;Volume slide stop effect.
PLY_AKG_Effect_VolumeSlideStop:
        ;Only stops the slide, don't reset the value.
        ld (iy + PLY_AKG_Channel1_IsVolumeSlide - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_OR_A
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_AKG_UseEffect_VolumeSlide
  
;Pitch track effect. Followed by the pitch, as a word.
                        IFDEF PLY_CFG_UseEffect_PitchDown        ;CONFIG SPECIFIC
PLY_AKG_Effect_PitchDown:
        ;Changes the sign of the operations.
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_ADD_HL_BC_MSB
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 1), PLY_AKG_OPCODE_ADD_HL_BC_LSB
        ld (iy + PLY_AKG_Channel1_PitchTrackDecimalInstr - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_ADD_A_IMMEDIATE
        ld (iy + PLY_AKG_Channel1_PitchTrackIntegerAddOrSub - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_INC_HL
                        ENDIF ;PLY_CFG_UseEffect_PitchDown
                        IFDEF PLY_AKS_UseEffect_PitchUpOrDown        ;CONFIG SPECIFIC
PLY_AKG_Effect_PitchUpDown_Common:              ;The Pitch up will jump here.
        ;Authorizes the pitch, disabled the glide.        
        ld (iy + PLY_AKG_Channel1_IsPitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_SCF
                        IFDEF PLY_CFG_UseEffect_PitchGlide           ;CONFIG SPECIFIC
        ld (iy + PLY_AKG_Channel1_GlideDirection - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),0
                        ENDIF ;PLY_CFG_UseEffect_PitchGlide

        ld a,(de)       ;Reads the Pitch.
        inc de
        ld (iy + PLY_AKG_Channel1_PitchTrackDecimalValue - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
        ld a,(de)
        inc de
        ld (iy + PLY_AKG_Channel1_PitchTrack - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDown
        
                        IFDEF PLY_CFG_UseEffect_PitchUp        ;CONFIG SPECIFIC
PLY_AKG_Effect_PitchUp:
        ;Changes the sign of the operations.
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_SBC_HL_BC_MSB
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 1), PLY_AKG_OPCODE_SBC_HL_BC_LSB
        ld (iy + PLY_AKG_Channel1_PitchTrackDecimalInstr - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_SUB_IMMEDIATE
        ld (iy + PLY_AKG_Channel1_PitchTrackIntegerAddOrSub - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_DEC_HL
        jr PLY_AKG_Effect_PitchUpDown_Common
                        ENDIF ;PLY_CFG_UseEffect_PitchUp

                        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide    ;CONFIG SPECIFIC
;Pitch track stop. Used by Pitch up/down/glide.
PLY_AKG_Effect_PitchStop:
        ;Only stops the pitch, don't reset the value. No need to reset the Glide either.
        ld (iy + PLY_AKG_Channel1_IsPitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),PLY_AKG_OPCODE_OR_A
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
        
                        IFDEF PLY_CFG_UseEffect_PitchGlide        ;CONFIG SPECIFIC
;Glide, with a note.
PLY_AKG_Effect_GlideWithNote:
        ;Reads the note to reach.
        ld a,(de)
        inc de
        ld (PLY_AKG_Effect_GlideWithNoteSaveDE + PLY_AKG_Offset1b),de                        ;Have to save, no more registers. Damn.
        ;Finds the period related to the note, stores it.
        add a,a                 ;The note is 7 bits only, so it fits.
        ld l,a
        ld h,0
        ld bc,PLY_AKG_PeriodTable
        add hl,bc
        
        ld sp,hl
        pop de                  ;DE = period to reach.
        ld (iy + PLY_AKG_Channel1_GlideToReach - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),e
        ld (iy + PLY_AKG_Channel1_GlideToReach - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1),d
        
        ;Calculates the period of the current note to calculate the difference.
        ld a,(ix + PLY_AKG_Channel1_TrackNote - PLY_AKG_Channel1_PlayInstrument_RelativeModifierAddress + PLY_AKG_Offset1b)
        add a,a
        ld l,a
        ld h,0
        add hl,bc
        
        ld sp,hl
        pop hl                  ;HL = current period.
        ;Adds the current Track Pitch to have the current period, else the direction may be biased.
        ld c,(iy + PLY_AKG_Channel1_Pitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b)
        ld b,(iy + PLY_AKG_Channel1_Pitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1)
        add hl,bc
        
        ;What is the difference?
        or a
        sbc hl,de
        IFNDEF PLY_AKG_Rom
dknr3 (void):
PLY_AKG_Effect_GlideWithNoteSaveDE: ld de,0                   ;Retrieves DE. This does not modified the Carry.
        ELSE
        ld de,(PLY_AKG_Effect_GlideWithNoteSaveDE)
        ENDIF
        jr c,PLY_AKG_Effect_Glide_PitchDown
        ;Pitch up.
        ld (iy + PLY_AKG_Channel1_GlideDirection - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),1
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_SBC_HL_BC_MSB
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 1), PLY_AKG_OPCODE_SBC_HL_BC_LSB
        ld (iy + PLY_AKG_Channel1_PitchTrackDecimalInstr - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_SUB_IMMEDIATE
        ld (iy + PLY_AKG_Channel1_PitchTrackIntegerAddOrSub - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_DEC_HL
        
        ;Reads the Speed, which is actually the "pitch".
PLY_AKG_Effect_Glide_ReadSpeed:
PLY_AKG_Effect_GlideSpeed:                      ;This is an effect.
        ld a,(de)
        inc de
        ld (iy + PLY_AKG_Channel1_PitchTrackDecimalValue - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a      ;No offset, the value is directly targeted.
        ld a,(de)
        inc de
        ld (iy + PLY_AKG_Channel1_PitchTrack - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        
        ;Enables the pitch, as the Glide relies on it. The Glide is enabled below, via its direction.
        ld a,PLY_AKG_OPCODE_SCF
        ld (iy + PLY_AKG_Channel1_IsPitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a

        jp PLY_AKG_Channel_RE_EffectReturn
PLY_AKG_Effect_Glide_PitchDown:
        ;Pitch down.
        ld (iy + PLY_AKG_Channel1_GlideDirection - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),2
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_ADD_HL_BC_MSB
        ld (iy + PLY_AKG_Channel1_PitchTrackAddOrSbc_16bits - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 1), PLY_AKG_OPCODE_ADD_HL_BC_LSB
        ld (iy + PLY_AKG_Channel1_PitchTrackDecimalInstr - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_ADD_A_IMMEDIATE
        ld (iy + PLY_AKG_Channel1_PitchTrackIntegerAddOrSub - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + 0), PLY_AKG_OPCODE_INC_HL
        jr PLY_AKG_Effect_Glide_ReadSpeed
                        ENDIF ;PLY_CFG_UseEffect_PitchGlide
        
        
                        IFDEF PLY_CFG_UseEffect_Legato          ;CONFIG SPECIFIC
;Legato. Followed by the note to play.        
PLY_AKG_Effect_Legato:
        ;Reads and sets the new note to play.
        ld a,(de)
        inc de
        ld (ix + PLY_AKG_Channel1_TrackNote - PLY_AKG_Channel1_PlayInstrument_RelativeModifierAddress + PLY_AKG_Offset1b),a
        
        ;Stops the Pitch effect, resets the Pitch.
                                IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide    ;CONFIG SPECIFIC
        ld a,PLY_AKG_OPCODE_OR_A
        ld (iy + PLY_AKG_Channel1_IsPitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
        xor a
        ld (iy + PLY_AKG_Channel1_Pitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b),a
        ld (iy + PLY_AKG_Channel1_Pitch - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress + PLY_AKG_Offset1b + 1),a
                                ENDIF ;PLY_AKS_UseEffect_PitchUpOrDownOrGlide
                                
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_Legato


                        IFDEF PLY_CFG_UseEffect_ForceInstrumentSpeed    ;CONFIG SPECIFIC
;Forces the Instrument Speed. Followed by the speed.
PLY_AKG_Effect_ForceInstrumentSpeed:
        ;Reads and sets the new speed.
        ld a,(de)
        inc de
        ld (ix + PLY_AKG_Channel1_InstrumentSpeed - PLY_AKG_Channel1_PlayInstrument_RelativeModifierAddress + PLY_AKG_Offset1b),a
        
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_ForceInstrumentSpeed
        
                        
                        IFDEF PLY_CFG_UseEffect_ForceArpeggioSpeed      ;CONFIG SPECIFIC
;Forces the Arpeggio Speed. Followed by the speed.
PLY_AKG_Effect_ForceArpeggioSpeed:
                                IFDEF PLY_AKS_UseEffect_Arpeggio                ;CONFIG SPECIFIC
                                ;Is IT possible to use a Force Arpeggio even if there is no Arpeggio. Unlikely, but...
        ;Reads and sets the new speed.
        ld a,(de)
        inc de
        ld (iy + PLY_AKG_Channel1_ArpeggioTableSpeed - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
                                ELSE
                inc de
                                ENDIF ;PLY_AKS_UseEffect_Arpeggio
        
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_ForceArpeggioSpeed

                        IFDEF PLY_CFG_UseEffect_ForcePitchTableSpeed    ;CONFIG SPECIFIC
;Forces the Pitch Speed. Followed by the speed.
PLY_AKG_Effect_ForcePitchSpeed:
                                IFDEF PLY_CFG_UseEffect_PitchTable                ;CONFIG SPECIFIC
                                ;Is IT possible to use a Force Arpeggio even if there is no Arpeggio. Unlikely, but...
        ;Reads and sets the new speed.
        ld a,(de)
        inc de
        ld (iy + PLY_AKG_Channel1_PitchTableSpeed - PLY_AKG_Channel1_SoundStream_RelativeModifierAddress),a
                                ELSE
                inc de
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
        
        jp PLY_AKG_Channel_RE_EffectReturn
                        ENDIF ;PLY_CFG_UseEffect_ForcePitchTableSpeed
        
                        ENDIF ;PLY_CFG_UseEffects                ;CONFIG SPECIFIC

        

                        IFDEF PLY_CFG_UseEventTracks            ;CONFIG SPECIFIC
                        IFNDEF PLY_AKG_Rom
dkbs (void):    ;Disark macro.
PLY_AKG_Event: db 0         ;Possible event sent from the music for the caller to interpret.
dkbe (void):    ;Disark macro.
                        ENDIF
                        ENDIF ;PLY_CFG_UseEventTracks




;The period table for each note (from 0 to 127 included).
PLY_AKG_PeriodTable:
dkws (void):    ;Disark macro.
        IFDEF PLY_AKG_HARDWARE_CPC
        ;PSG running to 1000000 Hz.
        dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025          ;0
        dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012          ;12
        dw 956,902,851,804,758,716,676,638,602,568,536,506                      ;24
        dw 478,451,426,402,379,358,338,319,301,284,268,253                      ;36
        dw 239,225,213,201,190,179,169,159,150,142,134,127                      ;48
        dw 119,113,106,100,95,89,84,80,75,71,67,63                              ;60
        dw 60,56,53,50,47,45,42,40,38,36,34,32                                  ;72
        dw 30,28,27,25,24,22,21,20,19,18,17,16                                  ;84
        dw 15,14,13,13,12,11,11,10,9,9,8,8                                      ;96
        dw 7,7,7,6,6,6,5,5,5,4,4,4                                              ;108
        dw 4,4,3,3,3,3,3,2 ;,2,2,2,2                                            ;120 -> 127
        ENDIF
        IFDEF PLY_AKG_HARDWARE_SPECTRUM_OR_MSX
        ;PSG running to 1773400 Hz.
	dw 6778, 6398, 6039, 5700, 5380, 5078, 4793, 4524, 4270, 4030, 3804, 3591	; Octave 0
	dw 3389, 3199, 3019, 2850, 2690, 2539, 2397, 2262, 2135, 2015, 1902, 1795	; Octave 1
	dw 1695, 1599, 1510, 1425, 1345, 1270, 1198, 1131, 1068, 1008, 951, 898	; Octave 2
	dw 847, 800, 755, 712, 673, 635, 599, 566, 534, 504, 476, 449	; Octave 3
	dw 424, 400, 377, 356, 336, 317, 300, 283, 267, 252, 238, 224	; Octave 4
	dw 212, 200, 189, 178, 168, 159, 150, 141, 133, 126, 119, 112	; Octave 5
	dw 106, 100, 94, 89, 84, 79, 75, 71, 67, 63, 59, 56	; Octave 6
	dw 53, 50, 47, 45, 42, 40, 37, 35, 33, 31, 30, 28	; Octave 7
	dw 26, 25, 24, 22, 21, 20, 19, 18, 17, 16, 15, 14	; Octave 8
	dw 13, 12, 12, 11, 11, 10, 9, 9, 8, 8, 7, 7	; Octave 9
	dw 7, 6, 6, 6, 5, 5, 5, 4	; Octave 10
        ENDIF
        IFDEF PLY_AKG_HARDWARE_PENTAGON
        ;PSG running to 1750000 Hz.
        dw 6689, 6314, 5959, 5625, 5309, 5011, 4730, 4464, 4214, 3977, 3754, 3543	; Octave 0
	dw 3344, 3157, 2980, 2812, 2655, 2506, 2365, 2232, 2107, 1989, 1877, 1772	; Octave 1
	dw 1672, 1578, 1490, 1406, 1327, 1253, 1182, 1116, 1053, 994, 939, 886	; Octave 2
	dw 836, 789, 745, 703, 664, 626, 591, 558, 527, 497, 469, 443	; Octave 3
	dw 418, 395, 372, 352, 332, 313, 296, 279, 263, 249, 235, 221	; Octave 4
	dw 209, 197, 186, 176, 166, 157, 148, 140, 132, 124, 117, 111	; Octave 5
	dw 105, 99, 93, 88, 83, 78, 74, 70, 66, 62, 59, 55	; Octave 6
	dw 52, 49, 47, 44, 41, 39, 37, 35, 33, 31, 29, 28	; Octave 7
	dw 26, 25, 23, 22, 21, 20, 18, 17, 16, 16, 15, 14	; Octave 8
	dw 13, 12, 12, 11, 10, 10, 9, 9, 8, 8, 7, 7	; Octave 9
	dw 7, 6, 6, 5, 5, 5, 5, 4	; Octave 10
        ENDIF
dkwe (void):    ;Disark macro.
PLY_AKG_PeriodTable_End:



;Buffer used for the ROM player. This part needs to be set to RAM. PLY_AKG_ROM_Buffer must be set.
        IFDEF PLY_AKG_Rom
        
        PLY_AKG_BufferOffset = 0

;Generic data.
        IFDEF PLY_CFG_UseEventTracks
PLY_AKG_Event:                                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
PLY_AKG_CurrentSpeed:                                           equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_BaseNoteIndex:                                          equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_PatternDecreasingHeight:                                equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_TickDecreasingCounter:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        IFDEF PLY_CFG_UseSpeedTracks
PLY_AKG_SpeedTrack_WaitCounter:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_CFG_UseEventTracks
PLY_AKG_EventTrack_WaitCounter:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_CFG_UseHardwareSounds
PLY_AKG_PSGReg13_OldValue:                                      equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_PSGReg13_Instr:                                      equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
                IFDEF PLY_CFG_UseRetrig
PLY_AKG_Retrig:                                      equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
                ENDIF
        ENDIF
PLY_AKG_Channel_RE_ReadNextEffectInBlock:                                      equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ;Words
PLY_AKG_ReadLinker_PtLinker:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        IFDEF PLY_CFG_UseSpeedTracks
PLY_AKG_SpeedTrack_PtTrack:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
        IFDEF PLY_CFG_UseEventTracks
PLY_AKG_EventTrack_PtTrack:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
        IFDEF PLY_AKS_UseEffect_Arpeggio
PLY_AKG_ArpeggiosTable:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchTable
PLY_AKG_PitchesTable:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
PLY_AKG_InstrumentsTable:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        IFDEF PLY_CFG_UseEffects
        ;For ROM, only one is used, the second is the same, but it makes it faster on non-ROM as it avoid reading the memory.
PLY_AKG_Channel_ReadEffects_EffectBlocks1:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
PLY_AKG_EmptyInstrumentDataPt:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_SaveSp:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_PSGReg01_Instr:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_PSGReg23_Instr:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_PSGReg45_Instr:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_PSGReg6_8_Instr:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_PSGReg6:                                        equ PLY_AKG_PSGReg6_8_Instr + 0
PLY_AKG_PSGReg8:                                        equ PLY_AKG_PSGReg6_8_Instr + 1
PLY_AKG_PSGReg9_10_Instr:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_PSGReg9:                                        equ PLY_AKG_PSGReg9_10_Instr + 0
PLY_AKG_PSGReg10:                                       equ PLY_AKG_PSGReg9_10_Instr + 1
        IFDEF PLY_CFG_UseHardwareSounds
PLY_AKG_PSGHardwarePeriod_Instr:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
PLY_AKG_Channel_ReadEffects_EndJumpInstrAndAddress:                                  equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 3      ;3 bytes. JP xxxx
        IFDEF PLY_CFG_UseEffect_PitchGlide
PLY_AKG_Effect_GlideWithNoteSaveDE:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
PLY_AKG_TempPlayInstrumentJumpInstrAndAddress:                    equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 3      ;3 bytes. JP xxxx

        ;Section specific to each channel.
        REPEAT 3, channelNumber
PLY_AKG_Channel{channelNumber}_SoundStream_RelativeModifierAddress:             equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset
PLY_AKG_Channel{channelNumber}_PlayInstrument_RelativeModifierAddress:          equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset

        ;Bytes
        IFDEF PLY_CFG_UseTranspositions
PLY_AKG_Channel{channelNumber}_Transposition:                   equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
PLY_AKG_Channel{channelNumber}_WaitCounter:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        IFDEF PLY_AKG_UseEffect_VolumeSlide
PLY_AKG_Channel{channelNumber}_IsVolumeSlide:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_AKS_UseEffect_Arpeggio
PLY_AKG_Channel{channelNumber}_IsArpeggioTable:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchTable
PLY_AKG_Channel{channelNumber}_IsPitchTable:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide
PLY_AKG_Channel{channelNumber}_IsPitch:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_ForceInstrumentSpeed
PLY_AKG_Channel{channelNumber}_InstrumentOriginalSpeed:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
PLY_AKG_Channel{channelNumber}_InstrumentSpeed:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_InstrumentStep:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        IFDEF PLY_AKS_UseEffect_Arpeggio
PLY_AKG_Channel{channelNumber}_ArpeggioTableCurrentStep:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_GeneratedCurrentArpNote:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_ArpeggioBaseSpeed:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_ArpeggioTableSpeed:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchTable
PLY_AKG_Channel{channelNumber}_PitchTableCurrentStep:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_PitchBaseSpeed:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_PitchTableSpeed:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide
PLY_AKG_Channel{channelNumber}_PitchTrackDecimal:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalCounter:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
PLY_AKG_Channel{channelNumber}_TrackNote:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        IFDEF PLY_CFG_UseEffect_PitchGlide
PLY_AKG_Channel{channelNumber}_GlideDirection:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ENDIF
PLY_AKG_Channel{channelNumber}_GeneratedCurrentInvertedVolume:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        ;Words
PLY_AKG_Channel{channelNumber}_PtTrack:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        IFDEF PLY_AKS_UseEffect_Arpeggio
PLY_AKG_Channel{channelNumber}_ArpeggioTable:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_ArpeggioTableBase:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide
PLY_AKG_Channel{channelNumber}_PitchTrack:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchTable
PLY_AKG_Channel{channelNumber}_PitchTable:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_PitchTableBase:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
PLY_AKG_Channel{channelNumber}_EffectBlocks1:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_EffectBlocks2:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_InvertedVolumeIntegerAndDecimal:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_Pitch:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_PtInstrument:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_PtBaseInstrument:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_VolumeSlideValue:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        IFDEF PLY_CFG_UseEffect_PitchGlide
PLY_AKG_Channel{channelNumber}_GlideToReach:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_Glide_SaveHL:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ENDIF
        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValue:   equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2     ;Add/sub b, xx.
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstr:          equ PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValue + 0
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalValue:          equ PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValue + 1
        ;The add/sub must be followed by the return JP.
PLY_AKG_Channel{channelNumber}_PitchTrackDecimalInstrAndValueReturnJp:   equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 3  ;JP xxxx.
        ENDIF
        
PLY_AKG_Channel{channelNumber}_GeneratedCurrentPitch:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        IFDEF PLY_AKS_UseEffect_PitchUpOrDownOrGlide
PLY_AKG_Channel{channelNumber}_PitchTrackAddOrSbc_16bits:         equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
        ;3 bytes.
PLY_AKG_Channel{channelNumber}_PitchTrackAfterAddOrSbcJumpInstrAndAddress:            equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 3     ;3 bytes. JP xxxx.
PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAddOrSub:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_PitchTrackIntegerAfterAddOrSubJumpInstrAndAddress:                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 3     ;3 bytes. JP xxxx.
        ENDIF
        REND

        ;The buffers for sound effects (if any), for each channel. They are treated apart, because they must be consecutive.
        IFDEF PLY_AKG_MANAGE_SOUND_EFFECTS
PLY_AKG_PtSoundEffectTable:                                     equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
                REPEAT 3, channelNumber
PLY_AKG_Channel{channelNumber}_SoundEffectData:                 equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 2
PLY_AKG_Channel{channelNumber}_SoundEffectInvertedVolume:       equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_SoundEffectCurrentStep:          equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
PLY_AKG_Channel{channelNumber}_SoundEffectSpeed:                equ PLY_AKG_ROM_Buffer + PLY_AKG_BufferOffset : PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 1
        if channelNumber != 3
               PLY_AKG_BufferOffset = PLY_AKG_BufferOffset + 3 ;Padding of 3, but only necessary for channel 1 and 2.
        endif
                REND
        ENDIF
        


        PLY_AKG_ROM_BufferSize = PLY_AKG_BufferOffset
        
        expectedBufferSize = 250
        IFNDEF PLY_AKG_MANAGE_SOUND_EFFECTS
                assert PLY_AKG_BufferOffset <= expectedBufferSize               ;Decreases when using the Player Configuration.
        ELSE
                assert PLY_AKG_BufferOffset <= (expectedBufferSize + 23)        ;With sound effects, it takes a bit more memory.
        ENDIF


        ENDIF ;PLY_AKG_Rom


PLY_AKG_End:
