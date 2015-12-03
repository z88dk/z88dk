
; ===============================================================
; 2001 Stefano Bodrato
; 2014 aralbrec, simple translation to asm
; ===============================================================
;
; char *bit_play(char *melody)
;
; Play a melody stored in the string.
;
; Syntax: "TONE(#/b)(+/-)(duration)"
; Sample:
;		bit_play("C8DEb4DC8");
;		bit_play("C8DEb4DC8");
;		bit_play("Eb8FGG");
;		bit_play("Eb8FGG");
;		bit_play("G8Ab4G8FEb4DC");
;		bit_play("G8Ab4G8FEb4DC");
;		bit_play("C8G-C");
;		bit_play("C8G-C");
;
; TONE: C, C#, D, D#, Db, E, Eb, F, F#, G, G#, Gb, A, A#, Ab, B, Bb
; OCTAVE ADJUST: +, -
; DURATION: 0..9
;
; Repeat last note: TONE = *
; Quiet: TONE = R(temporary duration)
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_play

EXTERN asm_isdigit, asm0_bit_beep, asm_z80_delay_ms
EXTERN l_mulu_16_16x8, l0_divu_16_16x8, l_mulu_16_8x8
EXTERN error_znc, error_einval_zc

asm_bit_play:

   ; enter : hl = char *melody
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            de = ptr to '\0' in melody
   ;            carry reset
   ;
   ;         fail (error in melody string)
   ;
   ;            hl = ptr to unrecognized note
   ;            carry set, errno = einval
   ;               
   ; uses  : af, bc, de, hl, (bc', de', hl', ix for integer division)

   ex de,hl                    ; de = char *melody
   
   ld c,2                      ; default note duration
   ld hl,262                   ; default note frequency
   
note_loop:

   ld a,(de)

   or a
   jp z, error_znc             ; if end of string reached

   inc de

   cp 'R'
   jr z, play_pause            ; if quiet
   
   cp '*'
   jr z, play_note             ; if repeat
   
   sub 'A'
   jr c, error                 ; if unrecognized note
   
   cp 'H' - 'A'
   jr nc, error                ; if unrecognized note
   
   ; note A..G
   
   ld b,a
   add a,a
   add a,b
   add a,a
   ld b,a                      ; b = note table index
   
tone_modifier:

   ld a,(de)

   cp '#'
   jr z, plus_one
   
   cp 'b'
   jr nz, note_frequency

plus_two:

   inc b
   inc b

plus_one:

   inc b
   inc b
   inc de                      ; step past # / b

   ; note frequency from table

note_frequency:

   ld a,notes % 256
   add a,b
   ld l,a
   
   ld a,notes / 256
   adc a,0
   ld h,a
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = note frequency

   ; octave adjust

octave:

   ld a,(de)

   cp '+'
   jr nz, octave_minus

octave_plus:

   add hl,hl                   ; double frequency
   
   inc de
   jr octave

octave_minus:

   cp '-'
   jr nz, duration
   
   srl h
   rr l                        ; halve frequency
   
   inc de
   jr octave
   
   ; duration

duration:

   call parse_duration         ; c = new duration, if any

   ; make some noise !

play_note:

   ; hl = note frequency
   ;  c = duration in 1/12 s
   ; de = char *melody
   
   push de                     ; save melody
   push hl                     ; save note_freq
   push bc                     ; save duration
   push hl                     ; save note_freq

   ld e,c
   call l_mulu_16_16x8        ; hl = hl * e = note_freq * duration
   
   ld e,12
   call l0_divu_16_16x8       ; hl = hl / e = note_freq * duration / 12
   
   pop bc                     ; bc = note_freq
   
   call asm0_bit_beep
      
   pop bc                      ;  c = default duration
   pop hl                      ; hl = default note_freq
   pop de                      ; de = char *melody
   
   jr note_loop

error:
   
   dec de
   call error_einval_zc

   ex de,hl
   ret

play_pause:

   push bc                     ; save note_duration
   call parse_duration         ; c = new duration, if any
   
   ; de = char *melody
   ;  c = default duration
   ; hl = default note_freq
   ; stack = note_duration
   
   inc c
   dec c
   
   jr z, pause_done            ; avoid zero delay problem

   push de
   push hl
   
   ld e,c
   ld l,83
   
   call l_mulu_16_8x8          ; hl = l * e = delay in milliseconds
   call asm_z80_delay_ms
   
   pop hl
   pop de

pause_done:

   pop bc                      ; c = note_duration
   jp note_loop

parse_duration:

   ld a,(de)

   call asm_isdigit            ; smaller to use this in context of larger program
   ret c
   
   sub '0'
   inc de
   
   ld c,a                      ; c = new duration
   ret

notes:

defw 440, 466, 415             ; A, A#, Ab
defw 494, 494, 466             ; B, B#, Bb
defw 262, 277, 262             ; C, C#, Cb
defw 294, 311, 277             ; D, D#, Db
defw 330, 330, 311             ; E, E#, Eb
defw 349, 370, 349             ; F, F#, Fb
defw 392, 415, 370             ; G, G#, Gb
