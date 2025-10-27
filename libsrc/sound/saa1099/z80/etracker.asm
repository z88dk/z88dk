; Disassembly of the compiled E-Tracker player
;
; (C) 2020-2021 Stefan Drissen
;
; Object code (C) 1992 ESI
;----------------------------------------------
; row as shown in E-Tracker editor:
;
; | 000 | --- 0000 | --- 0000 | --- 0000
;   row   |/| ||command + parameter
;         | | |+- ornament
;         | | +-- instrument
;         | +- octave
;         +--- note

; note: C C# D D# E F F# G G# A A# B
; octave:     1-8
; instrument: 1-9 A-V (= 31 instruments)
; ornament:   1-9 A-V (= 31 ornaments)
; command:
;   0 no change
;   1 envelope generator    - [0-c] see cmd_envelope
;   2 instrument inversion  - [0-1] see cmd_instrument_inversion
;   3 tune delay (default 6)- [0-f] see cmd_tune_delay
;   4 volume reduction      - [0-f] see cmd_volume_reduction
;   5 extended noise        - [0-1] see cmd_extended_noise
;   6 stop sound                    see cmd_stop_sound
;   7 no change

IF __CPU_Z80__ | __CPU_Z80N__
    MODULE etracker
    SECTION smc_clib

    PUBLIC  asm_etracker_init
    PUBLIC  asm_etracker_play

    defc asm_etracker_init = init
    defc asm_etracker_play = etracker_play



include "saa1099.def"
include "ports.def"


;==============================================
etracker_init:

    ld hl,module
    jp init

;==============================================
etracker_play:

var_delay:
    ld a,1
    dec a
    jr nz,same_notes

    ld ix,str_channel_0

    ld b,6
loop1:
    push bc
    call get_note
    ld bc,str_channel_size
    add ix,bc
    pop bc

    djnz loop1


    ld hl,(var_noise_0)
    ld a,h
    call swap_nibbles_a
    or l
    ld (var_noise_extended+1),a

var_tune_delay:
    ld a,6

same_notes:

    ld (var_delay+1),a

;----------------------------------------------

    ld ix,str_channel_0
    call update_channel    ; sets a, l, a'
    ld (out + saa_register_amplitude_0),a
    ld (out + saa_register_frequency_tone_0),hl

    push hl

    ld hl,0
    call get_noise         ; move lower two bits of a' into l and h
    ld (store_noise1+1),hl
    ld (var_noise_gen_0+1),a

;----------------------------------------------

    ld ix,str_channel_1
    call update_channel
    ld (out + saa_register_amplitude_1),a
    ld (out + saa_register_frequency_tone_1),hl

    push hl
store_noise1:
    ld hl,0
    call get_noise
    ld (store_noise2+1),hl
    rl h
    jr nc,no_noise1
    ld (var_noise_gen_0+1),a
no_noise1:

;----------------------------------------------

    ld ix,str_channel_2
    call update_channel
    ld (out + saa_register_amplitude_2),a
    ld (out + saa_register_frequency_tone_2),hl

    push hl
store_noise2:
    ld hl,0
    call get_noise
    ld (store_noise3+1),hl
    rl h
    jr nc,no_noise2
    ld (var_noise_gen_0+1),a
no_noise2:

;----------------------------------------------

    ld ix,str_channel_3
    call update_channel
    ld (out + saa_register_amplitude_3),a
    ld (out + saa_register_frequency_tone_3),hl

    push hl
store_noise3:
    ld hl,0
    call get_noise
    ld (store_noise4+1),hl
    ld (var_noise_gen_1+1),a

;----------------------------------------------

    ld ix,str_channel_4
    call update_channel
    ld (out + saa_register_amplitude_4),a
    ld (out + saa_register_frequency_tone_4),hl

    push hl
store_noise4:
    ld hl,0
    call get_noise
    ld (store_noise5+1),hl
    rl h
    jr nc,no_noise3
    ld (var_noise_gen_1+1),a
no_noise3:

;----------------------------------------------

    ld ix,str_channel_5
    call update_channel
    ld (out + saa_register_amplitude_5),a
    ld (out + saa_register_frequency_tone_5),hl

    push hl
store_noise5:
    ld hl,0
    call get_noise
    rr l
    rr l
    rr h
    rr h
    ld (out + saa_register_frequency_enable),hl

    rlca
    jr c,no_noise4

var_noise_gen_1:                           ; set by instruments ch3-ch5
    ld a,0
    rlca
no_noise4:
    rlca
    rlca
    rlca
var_noise_gen_0:                           ; set by instruments ch0-ch2
    or 0
var_noise_extended:                        ; set by cmd_extended_noise
    or 0
    ld (out + saa_register_noise_generator_1_0),a

    pop af                                  ; tone channel 5
    pop bc                                  ; tone channel 4
    call swap_nibbles_a
    or b
    ld h,a
    pop af                                  ; tone channel 3
    pop bc                                  ; tone channel 2
    call swap_nibbles_a
    or b
    ld l,a
    ld (out + saa_register_octave_3_2),hl

    pop af                                  ; tone channel 1
    pop bc                                  ; tone channel 0
    call swap_nibbles_a
    or b
    ld (out + saa_register_octave_1_0),a

    ld bc,port_sound_address
    ld de,saa_register_sound_enable * $100 + saa_se_channels_enabled
    out (c),d
    dec b                                   ; -> b = port_sound_data
    out (c),e

if SILENT

    xor a
    ld hl,out + saa_register_amplitude_0
    ld (hl),a       ; 0
    inc hl
    ld (hl),a       ; 1
    inc hl
;   ld (hl),a       ; 2 ! bleep
    inc hl
    ld (hl),a       ; 3
    inc hl
    ld (hl),a       ; 4
    inc hl
    ld (hl),a       ; 5

    ;!!! silence channels

endif

    ld hl,out + saa_register_envelope_generator_1
    ld d,saa_register_envelope_generator_1  ; $19
loop2:
    inc b                                   ; -> b = port_sound_address
    out (c),d
    dec b                                   ; -> b = port_sound_data
    ld a,(hl)
    out (c),a
    dec d

    ret m                                   ; d = -1

    dec hl
    jr loop2

;----------------------------------------------
frequency_note:

    defb $05    ; B
    defb $21    ; C
    defb $3c    ; C#
    defb $55    ; D
    defb $6d    ; D#
    defb $84    ; E
    defb $99    ; F
    defb $ad    ; F#
    defb $c0    ; G
    defb $d2    ; G#
    defb $e3    ; A
    defb $f3    ; A#

;----------------------------------------------
instrument_none:

    defb $fe    ; set loop
    defb $01
    defb $00
    defb $00
    defb $fc    ; get loop

;----------------------------------------------
list_envelopes:

    enabled: equ saa_envelope_enabled
    bits_3:  equ saa_envelope_bits_3
    bits_4:  equ saa_envelope_bits_4
    same:    equ saa_envelope_left_right_same
    inverse: equ saa_envelope_left_right_inverse

    defb same    | bits_4 | saa_envelope_mode_zero            | saa_envelope_reset

    defb same    | bits_3 | saa_envelope_mode_repeat_decay    | enabled   ; 1
    defb same    | bits_3 | saa_envelope_mode_repeat_attack   | enabled   ; 2
    defb same    | bits_3 | saa_envelope_mode_repeat_triangle | enabled   ; 3

    defb same    | bits_4 | saa_envelope_mode_repeat_decay    | enabled   ; 4
    defb same    | bits_4 | saa_envelope_mode_repeat_attack   | enabled   ; 5
    defb same    | bits_4 | saa_envelope_mode_repeat_triangle | enabled   ; 5

    defb inverse | bits_3 | saa_envelope_mode_repeat_decay    | enabled   ; 7
    defb inverse | bits_3 | saa_envelope_mode_repeat_attack   | enabled   ; 8
    defb inverse | bits_3 | saa_envelope_mode_repeat_triangle | enabled   ; 9

    defb inverse | bits_4 | saa_envelope_mode_repeat_decay    | enabled   ; A
    defb inverse | bits_4 | saa_envelope_mode_repeat_attack   | enabled   ; B
    defb inverse | bits_4 | saa_envelope_mode_repeat_triangle | enabled   ; C

;----------------------------------------------
ornament_none:

    defb $fe    ; set loop
    defb $00
    defb $ff    ; get loop

;==============================================
list_commands:

; jr table, used to adjust jr at smc_command_jr
; first byte of each pair is compared, if command is
; equal or higher, jr is used else proceed to next
; -> compare bytes must be in descending order

; the subtracted value is in c

    offset:    equ smc_command_jr + 2

    defb $d2                        ; [$d2-$ff] -> c = [$00-$2d]
    defb cmd_set_delay_next_note - offset

    defb $72                        ; [$72-$d2] -> c = [$00-$60]
    defb cmd_set_note - offset

    defb $52                        ; [$52-$71] -> c = [$00-$1f]
    defb cmd_set_instrument - offset

    defb $51                        ; [$51]     -> c =  $00
    defb cmd_end_of_track - offset

    defb $50                        ; [$50]     -> c =  $00
    defb cmd_stop_sound - offset

    defb $30                        ; [$30-$4f] -> c = [$00-$1f]
    defb cmd_set_ornament - offset

    defb $2e                        ; [$2e-$2f] -> c = [$00-$01]
    defb cmd_instrument_inversion - offset

    defb $21                        ; [$21-2$d] -> c = [$00-$0c]
    defb cmd_envelope - offset

    defb $11                        ; [$11-$20] -> c = [$00-$0f]
    defb cmd_volume_reduction - offset

    defb $0f                        ; [$0f-$10] -> c = [$00-$01]
    defb cmd_extended_noise - offset

    defb $00                        ; [$00-$0f] -> c = [$00-$0f]
    defb cmd_tune_delay - offset

;==============================================
swap_nibbles_a:

    rlca
    rlca
    rlca
    rlca
    ret

;==============================================
get_noise:

; move lower two bits of a' into l and h

    ex af,af'
    rrca            ; move bit 0 of a into carry
    rr l            ; move carry bit into bit 7 of l
    rrca            ; move bit 0 of a into carry
    rr h            ; move carry bit into bit 7 of h
    ret

;==============================================
bc_eq_section_c:

; input
;   hl = index
;   c  = section

; output
;   bc = address
;----------------------------------------------

    sla c
    ld b,0
    jr nc,$+3
    inc b
    add hl,bc   ; bc = c * 2

bc_eq_section:
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl

    push hl
var_module_start:
    ld hl,0
    add hl,bc
    ld c,l
    ld b,h
    pop hl

    ret

;==============================================
cmd_set_instrument:

; input
;   c = [$00-$1f]

var_instruments:
    ld hl,0
    call bc_eq_section_c
    ld (ix+ch_ptr_instrument_start  ),c
    ld (ix+ch_ptr_instrument_start+1),b

    ld hl,instrument_none
    ld (ix+ch_ptr_instrument_loop  ),l
    ld (ix+ch_ptr_instrument_loop+1),h

    jr set_instrument

;==============================================
cmd_set_ornament:

; input
;   c = [$00-$1f]

var_ornaments:
    ld hl,0
    call bc_eq_section_c
    ld (ix+ch_ptr_ornament_start  ),c
    ld (ix+ch_ptr_ornament_start+1),b

    ld hl,ornament_none
    ld (ix+ch_ptr_ornament_loop  ),l
    ld (ix+ch_ptr_ornament_loop+1),h

    jr set_ornament

;==============================================
get_note:

; input
;   b  = counter channel
;           6       0 freq noise generator 0
;           5       1 freq internal envelope clock
;           4       2

;           3       3 freq noise generator 1
;           2       4 freq internal envelope clock
;           1       5
;   ix = ptr_channel
;
; BUG: envelope set in channel 3 sets incorrect envelope generator
;----------------------------------------------

    dec (ix+ch_delay_next_note)
    ret p           ; ret when (ix+ch_delay_next_note) > 0

    ld a,b
    cp 3            ; !!! bug - should be cp 4 according to DTA
    ld hl,out + saa_register_envelope_generator_0
    jr nc,$+3       ; b >= 3 (-> channel <= 3, should be <= 2)
    inc hl          ; hl = envelope_generator_1
    ld (ptr_envelope_generator+1),hl

get_note_again:
    ld e,(ix+ch_ptr_track  )
    ld d,(ix+ch_ptr_track+1)

get_command:

    ld hl,list_commands - 1

find1:
    ld a,(de)
    inc hl
    sub (hl)
    inc hl
    jr c,find1 ; (hl) > a

    inc de
    ld c,a
    ld a,(hl)
    ld (smc_command_jr+1),a  ; update jr below

smc_command_jr:
    jr smc_command_jr        ; smc = command from list_commands

;==============================================
cmd_set_note:

; input
;   c = [$00-$60]

    ld (ix+ch_note),c

    ld c,(ix+ch_ptr_instrument_start  )
    ld b,(ix+ch_ptr_instrument_start+1)

;----------------------------------------------
set_instrument:

    ld (ix+ch_ptr_instrument  ),c
    ld (ix+ch_ptr_instrument+1),b

    ld c,(ix+ch_ptr_ornament_start  )
    ld b,(ix+ch_ptr_ornament_start+1)

;----------------------------------------------
set_ornament:

    ld (ix+ch_ptr_ornament  ),c
    ld (ix+ch_ptr_ornament+1),b

    ld (ix+ch_delay_next_ornament),1
    ld (ix+ch_delay_next_instrument),1
    ld (ix+ch_delay_next_volume),1

    jr get_command

;==============================================
cmd_envelope:  ; turn on or off envelope generator

; input
;   c = envelope [$00-$0c]

    ld b,0
    ld hl,list_envelopes
    add hl,bc
    ld a,(hl)
ptr_envelope_generator:
    ld (0),a                ; out + saa_register_envelope_generator_0 or 1

    jr get_command

;==============================================
cmd_instrument_inversion:  ; turn on or off instrument inversion

; input
;   c = [$00-$01]

    ld (ix+ch_instrument_inversion),c

    jr get_command

;==============================================
cmd_tune_delay:

; input
;   c = [$00-$0f]

    ld a,c
    inc a
    ld (var_tune_delay+1),a

    jr get_command

;==============================================
cmd_volume_reduction: ; volume reduction

; input
;   c = [$00-$0f]

    ld (ix+ch_volume_reduction),c

    jr get_command

;==============================================
cmd_extended_noise:

; input
;   c = [$00-$01]

    jr z,extended_noise_off

    ld c,saa_noise_0_variable

extended_noise_off:
    ld hl,(ptr_envelope_generator+1)   ; hl = out_envelope_generator_0 or 1
    inc hl
    inc hl
    ld (hl),c                           ; hl = var_noise_0 or 1

    jr get_command

;==============================================
cmd_stop_sound:

    ld bc,instrument_none
    jr set_instrument

;==============================================
cmd_set_delay_next_note:

; input
;   c = [$00-$2d]

    ld (ix+ch_delay_next_note),c
    ld (ix+ch_ptr_track  ),e
    ld (ix+ch_ptr_track+1),d

    ret

;==============================================
cmd_end_of_track:

    call read_song_table

    jp get_note_again

;==============================================
handle_instrument_loop_or_delay:

    cp $7f                      ; a was $fe
    jr z,set_instrument_loop

    cp $7e                      ; a was $fc
    jr z,get_instrument_loop

    add a,2
    ld c,a                      ; delay until next command
    jr handle_instrument

;----------------------------------------------
set_instrument_loop:

    ld (ix+ch_ptr_instrument_loop  ),l
    ld (ix+ch_ptr_instrument_loop+1),h
    jr handle_instrument

;----------------------------------------------
get_instrument_loop:

    ld l,(ix+ch_ptr_instrument_loop  )
    ld h,(ix+ch_ptr_instrument_loop+1)
    jr handle_instrument

;==============================================
handle_ornament_loop_or_delay:

    inc a
    jr z,get_ornament_loop     ; a was $ff

    inc a
    jr z,set_ornament_loop     ; a was $fe

    sub 8 * 12
    ld c,a                      ; c = delay until next command
    jr handle_ornament

;----------------------------------------------
get_ornament_loop:

    ld l,(ix+ch_ptr_ornament_loop  )
    ld h,(ix+ch_ptr_ornament_loop+1)
    jr handle_ornament

;----------------------------------------------
set_ornament_loop:

    ld (ix+ch_ptr_ornament_loop  ),l
    ld (ix+ch_ptr_ornament_loop+1),h
    jr handle_ornament

;==============================================
update_channel:

; input
;   ix = ptr_channel

; output
;   a   =   amplitude
;   l   =   tone
;   a'  =   noise
;----------------------------------------------

    ld e,(ix+ch_ptr_instrument_pitch  )
    ld d,(ix+ch_ptr_instrument_pitch+1)
    dec (ix+ch_delay_next_instrument)
    ld l,(ix+ch_ptr_instrument  )
    ld h,(ix+ch_ptr_instrument+1)
    jr nz,no_instrument_change

    ld c,1
handle_instrument:
    ld a,(hl)
    inc hl
    rrca
    jr nc,handle_instrument_loop_or_delay  ; a = even - returns c with delay until next command

    ld (ix+ch_delay_next_instrument),c
    ld (ix+ch_ptr_instrument_pitch+1),a
    ld e,(hl)
    ld d,a
    ld (ix+ch_ptr_instrument_pitch),e
    inc hl

no_instrument_change:
    push hl
    ld a,(ix+ch_ornament_note)
    dec (ix+ch_delay_next_ornament)
    jr nz,no_ornament_change

    ld c,1
    ld l,(ix+ch_ptr_ornament  )
    ld h,(ix+ch_ptr_ornament+1)
handle_ornament:
    ld a,(hl)
    inc hl
    cp 8 * 12                               ; ornament values capped at 8 octaves
                                            ; since they wrap around anyway
    jr nc,handle_ornament_loop_or_delay    ; a >= 8 * 12

    ld (ix+ch_delay_next_ornament),c
    ld (ix+ch_ornament_note),a
    ld (ix+ch_ptr_ornament  ),l
    ld (ix+ch_ptr_ornament+1),h

no_ornament_change:
    add a,(ix+ch_note)
    cp 8 * 12 - 1
    ld hl,$07ff     ; maximum octave (7) + note ($ff)
    jr z,max_note  ; a == $5f

var_pattern_height:
    add a,0         ; set
    jr nc,$+4
    sub 8 * 12

    ld hl,$ff0c         ; h = -1, l = 12
    ld b,h
loop3:
    inc h
    sub l               ; l = 12 = octave
    jr nc,loop3
                        ; h = octave
    ld c,a
    ld a,h
    ld hl,frequency_note + 12
    add hl,bc
    ld l,(hl)
    ld h,a              ; hl = octave + frequency
max_note:
    add hl,de           ; de = instrument_pitch
    ld a,h
    and $07             ; prevent octave overflow
    ld h,a

    ld a,d
    rrca
    rrca
    rrca
    and $0f
    ex af,af'           ; a' used by get_noise to fill bit 7 of h $ bit 7 of l

    ex de,hl
    pop hl              ; <- ch_ptr_instrument
    ld a,(ix+ch_volume)
    dec (ix+ch_delay_next_volume)
    jr nz,no_volume_change

    ld a,(hl)
    inc hl
var_default_volume_delay:
    cp 0
    jr nz,handle_volume_delay

    ld c,(hl)           ; delay next volume change
    inc hl
get_volume_hl:
    ld a,(hl)           ; volume
    inc hl
use_volume_a:
    ld (ix+ch_delay_next_volume),c

no_volume_change:
    ld (ix+ch_ptr_instrument  ),l
    ld (ix+ch_ptr_instrument+1),h
    ld (ix+ch_volume),a
    ex de,hl
    ld b,(ix+ch_volume_reduction)

    ld c,a
    and $0f
    sub b
    jr nc,volume_ge_0__1
    xor a
volume_ge_0__1:
    ld e,a

    ld a,c
    and $f0
    call swap_nibbles_a
    sub b
    jr nc,volume_ge_0__2
    xor a
volume_ge_0__2:
    ld d,a

    ld a,(ix+ch_instrument_inversion)
    or a
    ld a,e
    jr nz,inverted

    ld a,d
    ld d,e

inverted:
    call swap_nibbles_a
    or d

    ret

;==============================================
handle_volume_delay:

; input
;   a = value to lookup

; output
;   c = value of entry that matches b

    push hl
    ld b,a
var_volume_delay:
    ld hl,0
find2:
    ld a,(hl)
    or a
    jr z,not_found

    inc hl
    ld c,(hl)
    inc hl
    cp b
    jr nz,find2

    pop hl
    jr get_volume_hl

;----------------------------------------------

not_found:
    pop hl
    ld c,1
    ld a,b
    jr use_volume_a

;----------------------------------------------

    SECTION bss_clib



DEFVARS 0
{
ch_ptr_track               ds.w 1
ch_ptr_instrument          ds.w 1
ch_ptr_instrument_loop     ds.w 1
ch_ptr_ornament            ds.w 1
ch_ptr_ornament_loop       ds.w 1
ch_ptr_instrument_pitch    ds.w 1

ch_volume                  ds.b 1
ch_ornament_note           ds.b 1
ch_note                    ds.b 1

ch_ptr_instrument_start    ds.w 1
ch_ptr_ornament_start      ds.w 1

ch_delay_next_note         ds.b 1
ch_delay_next_ornament     ds.b 1
ch_delay_next_instrument   ds.b 1
ch_delay_next_volume       ds.b 1

ch_instrument_inversion    ds.b 1
ch_volume_reduction        ds.b 1
str_channel_size  	   ds.b 0
}


str_channel_0: defs str_channel_size
str_channel_1: defs str_channel_size
str_channel_2: defs str_channel_size
str_channel_3: defs str_channel_size
str_channel_4: defs str_channel_size
str_channel_5: defs str_channel_size

out:

        defb 0          ; $00 amplitude_0
        defb 0          ; $01 amplitude_1
        defb 0          ; $02 amplitude_2
        defb 0          ; $03 amplitude_3
        defb 0          ; $04 amplitude_4
        defb 0          ; $05 amplitude_5
        defb 0          ; ---
        defb 0          ; ---
        defb 0          ; $08 frequency_tone_0
        defb 0          ; $09 frequency_tone_1
        defb 0          ; $0a frequency_tone_2
        defb 0          ; $0b frequency_tone_3
        defb 0          ; $0c frequency_tone_4
        defb 0          ; $0d frequency_tone_5
        defb 0          ; ---
        defb 0          ; ---
        defb 0          ; $10 octave_1_0
        defb 0          ; $11 octave_3_2
        defb 0          ; $12 octave_5_4
        defb 0          ; ---
        defb 0          ; $14 frequency_enable
        defb 0          ; $15 noise_enable
        defb 0          ; $16 noise_generator_1_0
        defb 0          ; ---
        defb 0          ; $18 envelope_generator_0
        defb 0          ; $19 envelope_generator_1

var_noise_0:   defb 0
var_noise_1:   defb 0

out_size: equ $ - out

    SECTION smc_clib

;==============================================
init:

; input
;   hl = start address of compiled module
;----------------------------------------------

    ld (var_module_start+1),hl
    call bc_eq_section
    ld (var_song_table+1),bc

    call bc_eq_section
    ld (var_patterns+1),bc

    call bc_eq_section
    ld (var_instruments+1),bc

    call bc_eq_section
    ld (var_ornaments+1),bc

    call bc_eq_section
    ld a,(bc)
    inc bc
    ld (var_default_volume_delay+1),a
    ld (var_volume_delay+1),bc

    ld hl,str_channel_0
    ld b,6 * str_channel_size + out_size
    xor a
loop4:
    ld (hl),a
    inc hl
    djnz loop4

    inc a                   ; -> a = 1
    ld (var_delay+1),a

    ld ix,str_channel_0
    ld de,str_channel_size

    ld b,6
loop5:
    ld (ix+ch_delay_next_ornament),a    ; a = 1
    ld (ix+ch_delay_next_instrument),a  ; a = 1
    ld (ix+ch_delay_next_volume),a      ; a = 1

    ld hl,instrument_none
    ld (ix+ch_ptr_instrument_start  ),l
    ld (ix+ch_ptr_instrument_start+1),h

    ld (ix+ch_ptr_instrument  ),l
    ld (ix+ch_ptr_instrument+1),h

    ld hl,ornament_none
    ld (ix+ch_ptr_ornament_start  ),l
    ld (ix+ch_ptr_ornament_start+1),h
    add ix,de
    djnz loop5

    ld de,saa_register_sound_enable * $100 + saa_se_generators_reset
    ld bc,port_sound_address
    out (c),d
    dec b
    out (c),e

;----------------------------------------------
read_song_table:

; song table entries are a multiple of 3 -> [$00,$03,$06 __ $5a,$5d]

var_song_table:
    ld hl,0

init_song_table:

    ld c,(hl)
    ld a,c
    inc hl
    inc a
    jr z,song_table_get_loop       ; a = $ff -> end of song

    inc a
    jr z,song_table_set_loop       ; a = $fe

    sub $62
    jr nc,song_table_set_height    ; a >= $60 (a was incremented twice above)

    ld (var_song_table+1),hl
    sla c                           ; c * 2 -> song_table is multiple of 3 -> per channel

var_patterns:
    ld hl,0
    call bc_eq_section_c
    ld (str_channel_0+ch_ptr_track),bc

    call bc_eq_section
    ld (str_channel_1+ch_ptr_track),bc

    call bc_eq_section
    ld (str_channel_2+ch_ptr_track),bc

    call bc_eq_section
    ld (str_channel_3+ch_ptr_track),bc

    call bc_eq_section
    ld (str_channel_4+ch_ptr_track),bc

    call bc_eq_section
    ld (str_channel_5+ch_ptr_track),bc

    ret

;==============================================
song_table_get_loop:

var_song_table_loop:
    ld hl,0
    jr init_song_table

;==============================================
song_table_set_loop:

    ld (var_song_table_loop+1),hl
    jr init_song_table

;==============================================
song_table_set_height:

; input
;   a = [$00-$9b]

    ld (var_pattern_height+1),a
    jr init_song_table

;==============================================

; easier to debug module when aligned
; align $1000

module:
ENDIF
