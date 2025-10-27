
; ===============================================================
; Mar 2011 Shiru (shiru@mail.ru) 03'11
;
; 2014 adapted to z88dk by aralbrec
; * modified to use 1-bit output for all targets
; * modified to return to caller between rows
; ===============================================================
;
; void *bit_play_tritone(void *song)
;
; Tritone v2 Player (with differentiated channel volumes)
;
; * Three channels of tone, per-pattern tempo
; * One channel of interrupting drums
; * Feel free to do whatever you want with the code, it is PD
;
; NOTE:  Caller must disable interrupts while this subroutine
;        runs -- the stack pointer is used as a count_delta.
;
;        Data beginning at address 0 is used to generate
;        a random bit stream.
;
;        Contains lots of self-modifying code.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION smc_clib
SECTION smc_sound_bit

PUBLIC asm_bit_play_tritone

EXTERN asm_bit_open, asm_bit_close
EXTERN __sound_bit_state

asm_bit_play_tritone:

   ; enter : hl = song address
   ;            = 0 continue after loop command
   ;            =-1 continue after end of row reached
   ;
   ; exit  : hl = 0 if loop command met
   ;             -1 if one row of song has played
   ;
   ; uses  : all except af', iy

   ld (stack_ptr + 1),sp
   
   call asm_bit_open
   and ~__SOUND_BIT_TOGGLE
   
   ld (bit_state_0 + 1),a
   ld (bit_state_1 + 1),a
   ld (bit_state_2 + 1),a
   ld (bit_state_3 + 1),a
   ld (bit_state_4 + 1),a
   ld (bit_state_5 + 1),a
   
   IF __SOUND_BIT_METHOD = 2
   
      exx
      ld bc,__SOUND_BIT_PORT
      exx
   
   ENDIF
   
count1:        ld ix,0
               exx
count2:        ld hl,0
               exx

   ld a,h
   or l
   jr z, NEXT_POS
   
   ld a,h
   and l
   inc a
   jr z, NEXT_ROW

   ld (pos_pos + 1),hl
   
   xor a
   ld l,a
   ld h,a
   
   ld (count0_delta + 1),hl
   ld (count1_delta + 1),hl
   ld (count2_delta + 1),hl
   
   ld (duty_0 + 1),a
   ld (duty_1 + 1),a
   ld (duty_2 + 1),a
   
   ld (smc_skip_drum),a
   
; *************************************************************
; ** NEXT POSITION
; *************************************************************

NEXT_POS:

pos_pos:       ld hl,0

read:

               ld e,(hl)
               inc hl
               ld d,(hl)
               inc hl
               
               ld a,d
               or e
               jr z, command_loop

               ld (pos_pos + 1), hl
               ex de,hl
               
               ld c,(hl)
               inc hl
               ld b,(hl)
               inc hl
               
               ld (row_pos + 1),hl
               ld (duration + 1),bc
               
               jr NEXT_ROW

command_loop:

               ld a,(hl)
               inc hl
               ld h,(hl)
               ld l,a
               
               ld (pos_pos + 1),hl
               
               ex de,hl
               jp RETURN


; *************************************************************
; ** NEXT ROW
; *************************************************************

NEXT_ROW:

row_pos:       ld hl,0                   ; next row

               ld a,(hl)                 ; row type
               inc hl
               
               cp 2
               jr c, NOTE_SOUND
               
               cp 128
               jr c, DRUM_SOUND
               
               cp 255
               jr z, NEXT_POS            ; if row ended


NOTE_SOUND:

ch_0:          ld d,1

               cp d
               jr z, ch_1
               
               or a
               jr nz, ch_0_note
               
               ld b,a
               ld c,a
               jr ch_0_set

ch_0_note:     ld e,a
               and $0f
               ld b,a
               ld c,(hl)
               inc hl
               ld a,e
               and $f0

ch_0_set:      ld (duty_0 + 1),a
               ld (count0_delta + 1),bc


ch_1:          ld a,(hl)
               inc hl
               
               cp d
               jr z, ch_2
               
               or a
               jr nz, ch_1_note
               
               ld b,a
               ld c,a
               jr ch_1_set

ch_1_note:     ld e,a
               and $0f
               ld b,a
               ld c,(hl)
               inc hl
               ld a,e
               and $f0

ch_1_set:      ld (duty_1 + 1),a
               ld (count1_delta + 1),bc


ch_2:          ld a,(hl)
               inc hl
               
               cp d
               jr z, channel_end
               
               or a
               jr nz, ch_2_note
               
               ld b,a
               ld c,a
               jr ch_2_set

ch_2_note:     ld e,a
               and $0f
               ld b,a
               ld c,(hl)
               inc hl
               ld a,e
               and $f0

ch_2_set:      ld (duty_2 + 1),a
               ld (count2_delta + 1),bc


channel_end:   ld (row_pos + 1),hl
smc_skip_drum: scf
               jp nc, PLAY_ROW
               
               ; compensate for drums played last row
               
               xor a
               ld (smc_skip_drum),a
               
               ld hl,(duration + 1)
 
               ; ld de,-150
               
               IF __SOUND_BIT_METHOD = 2
               
                  ld de,-82              ; guesswork: method is 25% slower than others
               
               ELSE
               
                  ld de,-109             ; guesswork: new loop is 27% slower
               
               ENDIF
               
               add hl,de
               ex de,hl
               jr c, drum_delay_1
               
               ld de,257
               
drum_delay_1:

               ld a,d
               or a
               jr nz, drum_delay_2
               
               inc d

drum_delay_2:

               ld a,e
               or a
               jr nz, drum_delay_3

               inc e

drum_delay_3:

               jp DRUM
               

; *************************************************************
; ** DRUM SOUND
; *************************************************************

DRUM_SOUND:

               ;  a = drum selection + 2
               ; hl = next row in song
               ; bc'= port_16
   
               ld (row_pos + 1),hl
   
               add a,a
               ld ixl,a
               ld ixh,0
               ld bc,drum_settings_table - 4
               add ix,bc                   ; ix = index into drums table

               cp 14*2                     ; playing drum noise ?
   
               ld a,$37                    ; opcode = scf
               ld (smc_skip_drum),a        ; adjust duration of next row
   
               jr nc, drum_noise           ; drum selection is noise

drum_tone:

               ; drum set $1

               ld bc,2
bit_state_4:   ld a,$00
               ld de,+(__SOUND_BIT_TOGGLE * 256) + 1
               ld l,(ix+0)

dtone_loop_0:

               bit 0,b
               jr z, dtone_loop_1
   
               dec e
               jr nz, dtone_loop_1
               ld e,l
   
               ld h,a
               ld a,l
               add a,(ix+1)
               ld l,a
               ld a,h
               
               xor d                       ; toggle bit device

dtone_loop_1:

               INCLUDE "sound/bit/z80/output_bit_device_2.inc"
               djnz dtone_loop_0

               dec c
               jp nz, dtone_loop_0
               
               jp NEXT_ROW


drum_noise:

               ; drum set $2
               ; uses data at address 0 for noise source

               ld b,0
bit_state_5:   ld c,$00
               ld h,b
               ld l,b
               ld de,+(__SOUND_BIT_TOGGLE * 256) + 1

dnoise_loop_0:

               ld a,(hl)
               
               and d
               or c
               INCLUDE "sound/bit/z80/output_bit_device_2.inc"

               and (ix+0)
               INCLUDE "sound/bit/z80/output_bit_device_2.inc"
               
               dec e
               jr nz, dnoise_loop_1
               
               ld e,(ix+1)
               inc hl

dnoise_loop_1:

               djnz dnoise_loop_0
               
               jp NEXT_ROW


drum_settings_table:

   ; "there are two drum sets of 12 sounds"

   ; 0 (drum selection = 2)
   
   defb $01,$01                  ; tone, highest
   defb $01,$02
   defb $01,$04
   defb $01,$08
   defb $01,$20
   defb $20,$04
   defb $40,$04
   defb $40,$08                  ; lowest
   defb $04,$80                  ; special
   defb $08,$80
   defb $10,$80
   defb $10,$02
   
   ; 24 (drum selection = 14)
   
   defb ~__SOUND_BIT_TOGGLE,$02
   defb ~__SOUND_BIT_TOGGLE,$02
   defb $ff,$01                  ; noise, highest
   defb $ff,$02
   defb $ff,$04
   defb $ff,$08
   defb $ff,$10
   defb ~__SOUND_BIT_TOGGLE,$01
   defb ~__SOUND_BIT_TOGGLE,$02
   defb ~__SOUND_BIT_TOGGLE,$04
   defb ~__SOUND_BIT_TOGGLE,$08
   defb ~__SOUND_BIT_TOGGLE,$10


; *************************************************************
; ** PLAY ONE ROW OF SONG
; *************************************************************

PLAY_ROW:

duration:      ld de,0

DRUM:

count0_delta:  ld bc,0
count0:        ld hl,0
               exx
count1_delta:  ld de,0
count2_delta:  ld sp,0
               exx

sound_loop:

; NOTES:
;
; Original routine:
;
;   channel_0 = 49T = 32%
;   channel_1 = 49T = 32%
;   channel_2 = 55T = 36%
;
;   loop time = 153T
;
;
; New routine:  port_8 / port_16 / memory
;
;   channel_0 = 63T / 64T / 65T = 32% / 32% / 32%
;   channel_1 = 63T / 64T / 65T = 32% / 32% / 32%
;   channel_2 = 69T / 70T / 71T = 35% / 35% / 35%
;
;   loop time = 195T / 198T / 201T
;
; The percentages remain the same, keeping relative
; volumes of each channel the same as the original.
;
; The difference in loop time is significant and
; causes the tempo and tone to drop and that is
; something that must be compensated by the tracker.
;
; Faster loop times lead to better quality output.

               ; de = duration
               ; bc'= port_16
               ; hl = count0
               ; bc = count0_delta
               ; ix = count1
               ; de'= count1_delta
               ; hl'= count2
               ; sp = count2_delta

               ; channel 0 gets some time beginning at bit output
               
channel_0:     add hl,bc
               ld a,h
               exx
duty_0:        cp 128
               sbc a,a
               and __SOUND_BIT_TOGGLE
bit_state_0:   or $00
               INCLUDE "sound/bit/z80/output_bit_device_1.inc"

IFDEF __spectrum

   ; 8T between OUTs for zx
   
   ret c
   sbc a,a

ENDIF

;               defc NOMINAL_CLOCK = 3500000
;               defc NOMINAL_T     = 64
;               defc TARGET_CLOCK  = __clock_freq
;               
;               INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

               ; channel 1 gets some time beginning at bit output
               
               nop
channel_1:     add ix,de
               ld a,ixh
duty_1:        cp 128
               sbc a,a
               and __SOUND_BIT_TOGGLE
bit_state_1:   or $00
               INCLUDE "sound/bit/z80/output_bit_device_1.inc"
               
IFDEF __SPECTRUM

   ; 8T between OUTs for zx
   
   ret c
   sbc a,a

ENDIF

;               defc NOMINAL_CLOCK = 3500000
;               defc NOMINAL_T     = 64
;               defc TARGET_CLOCK  = __clock_freq
;               
;               INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

               ; channel 2 gets some time beginning at bit output
               
channel_2:     add hl,sp
               ld a,h
duty_2:        cp 128
               sbc a,a
               and __SOUND_BIT_TOGGLE
bit_state_2:   or $00
               exx
               dec e
               exx
               INCLUDE "sound/bit/z80/output_bit_device_1.inc"
;;;;;;;;;69
;               defc NOMINAL_CLOCK = 3500000
;               defc NOMINAL_T     = 64
;               defc TARGET_CLOCK  = __clock_freq
;               
;               INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

               exx

IFDEF __SPECTRUM

               ; 8T between OUTs for zx
               jr nz, sound_loop

ELSE

               jp nz, sound_loop

ENDIF
          
               dec d
               jp nz, sound_loop

               ; save some state
               
               ld (count0 + 1),hl
               ld (count1 + 2),ix
               exx
               ld (count2 + 1),hl
               exx

               ; indicate a row completed

               ld hl,$ffff

; *************************************************************
; ** QUITTING TIME ?
; *************************************************************

RETURN:        ; enter : hl = 0 if loop occurs

stack_ptr:     ld sp,$0000

               ; leave device in rest state
               
bit_state_3:   ld a,$00
               INCLUDE "sound/bit/z80/output_bit_device_2.inc"

               jp asm_bit_close
