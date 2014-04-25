
; ===============================================================
; 2011-2012 Shiru http://shiru.untergrund.net
;
; 2014 adapted to z88dk by aralbrec
; * modified to use one index register
; * modified to eliminate self-modifying code
; * modified to use general 1-bit output for all targets
; * modified to be tolerant of fast cpus
; ===============================================================
;
; void bit_beepfx(void *effect)
;
; Plays the selected sound effect on the one bit device.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

XLIB asm_bit_beepfx

LIB asm_z80_delay_tstate, asm_bit_open, asm_bit_close

asm_bit_beepfx:

   ; enter : ix = void *effect
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
   
   exx
   
   call asm_bit_open
   
   and ~__sound_bit_toggle
   ld h,a                      ; h'= sound_bit_state with output bit = 0

   IF __sound_bit_method = 2

      ld bc,__sound_bit_port
   
   ENDIF

   exx

read_data:

   ld a,(ix+0)                 ; a = block_type
   exx
   ld e,(ix+1)
   ld d,(ix+2)                 ; de'= duration_1
   exx
   ld c,(ix+3)
   ld b,(ix+4)                 ; bc = duration_2
   
   dec a
   jr z, sfx_routine_tone
   
   dec a
   jr z, sfx_routine_noise
   
   dec a
   jr z, sfx_routine_sample
   
   exx
   
   ; leave 1-bit device in 0 position
   
   ld a,h
   INCLUDE "sound/bit/z80/output_bit_device_1.inc"

   exx
   
   jp asm_bit_close

; *************************************************************

sfx_routine_sample:

   ; PLAY SAMPLE

   ; ix = & block descriptor
   ; bc = duration_2
   ;  h'= sound_bit_state
   ; bc'= port_16 when sound_bit_method == 2
   ; de'= duration_1

   exx
   
   ld l,__sound_bit_toggle
   push de
   
   exx
   
   ld l,c
   ld h,b                      ; hl = duration_2
   
   pop bc                      ; bc = duration_1

   ; ix = & block descriptor
   ; hl = sample_ptr (duration_2)
   ; bc = duration_1
   ;  l'= __sound_bit_toggle
   ;  h'= sound_bit_state
   ; bc'= port_16 when sound_bit_method == 2

sample_loop_0:

   ld e,8
   ld d,(hl)
   inc hl

sample_loop_1:

   ld a,(ix+5)

sample_loop_2:

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: loop time = 16T
   ;;
   ;; fast cpu compensation
   ;;
   ;; loop is timed for a 3.5MHz
   ;; cpu and is intended to last 4.57us
   ;;
   ;; T state compensation is:
   ;;
   ;; T = (4.57us)(Fcpu) - 16
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 8752735) & (__clock_freq <= 45733041)
   
                       exx
                       ld l,+(((__clock_freq * 45) / 10000000) + ((__clock_freq * 7) / 100000000) - 24) / 16
      sample_waste_2:  dec l
                       jr nz, sample_waste_2
                       exx
   
   ENDIF
           
   IF __clock_freq > 45733041
           
      push bc
      push hl
           
      ld hl,+((__clock_freq * 45) / 10000000) + ((__clock_freq * 7) / 100000000) - 68
      call asm_z80_delay_tstate
      
      pop hl
      pop bc
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   dec a
   jr nz, sample_loop_2
   
   rl d
   sbc a,a
   
   exx
   
   and l                       ; confine to toggle bits
   or h                        ; mix with sound_bit_state
   
   INCLUDE "sound/bit/z80/output_bit_device_1.inc"
   
   exx
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: original loop time    = 72T
   ;;       implemented loop time = 74T, 75T, 76T
   ;;
   ;; fast cpu compensation
   ;;
   ;; loop is timed for a 3.5MHz
   ;; cpu and is intended to last 20.6us
   ;;
   ;; T state compensation is:
   ;;
   ;; T = (20.6us)(Fcpu) - 74
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 4466019) & (__clock_freq <= 12961165)
   
                       ld a,+(((__clock_freq * 20) / 1000000) + ((__clock_freq * 6) / 10000000) - 76) / 16
      sample_waste_1:  dec a
                       jr nz, sample_waste_1
   
   ENDIF
           
   IF __clock_freq > 12961165
           
      push bc
      push hl
           
      ld hl,+((__clock_freq * 20) / 1000000) + ((__clock_freq * 6) / 10000000) - 126
      call asm_z80_delay_tstate
      
      pop hl
      pop bc
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   dec e
   jr nz, sample_loop_1
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: outer loop time = 46T
   ;;
   ;; fast cpu compensation
   ;;
   ;; outer loop is timed for a 3.5MHz
   ;; cpu and is intended to last 13.1us
   ;;
   ;; T state compensation is:
   ;;
   ;; T = (13.1us)(Fcpu) - 46
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 4885496) & (__clock_freq <= 18244274)
   
                       ld a,+(((__clock_freq * 13) / 1000000) + (__clock_freq / 10000000) - 48) / 16
      sample_waste_0:  dec a
                       jr nz, sample_waste_0
   
   ENDIF
           
   IF __clock_freq > 18244274
           
      push bc
      push hl
           
      ld hl,+((__clock_freq * 13) / 1000000) + (__clock_freq / 10000000) - 98
      call asm_z80_delay_tstate
      
      pop hl
      pop bc
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   dec bc
   
   ld a,b
   or c
   jr nz, sample_loop_0

   ld c,6

next_data:

   add ix,bc                   ; skip to next block
   jr read_data   

; *************************************************************

sfx_routine_tone:

   ; PLAY TONE

   ; ix = & block descriptor
   ; bc = duration_2
   ;  h'= sound_bit_state
   ; bc'= port_16 when sound_bit_method == 2
   ; de'= duration_1

   ld e,(ix+5)
   ld d,(ix+6)                 ; de = time_delta
   
   exx
   
   ld a,(ix+9)
   ld l,a                      ; l'= duty_count
   
   exx
   
   ld hl,0

   ; ix = & block descriptor
   ; hl = time_count
   ; de = time_delta
   ; bc = duration_2
   ;  l'= duty_count
   ;  h'= sound_bit_state
   ; de'= duration_1
   ; bc'= port_16 when sound_bit_method == 2

tone_loop_0:

   push bc                     ; save duration_2

tone_loop_1:

   add hl,de                   ; time_count += time_delta
   ld a,h
   
   exx

   cp l
   sbc a,a                     ; time_count >= duty_count ?
   
   and __sound_bit_toggle      ; set toggle bit if yes
   or h                        ; mix with bit_state

   INCLUDE "sound/bit/z80/output_bit_device_1.inc"
      
   exx

   ;; note: original inner loop time    = 77T
   ;;       implemented inner loop time = 79T, 80T, 81T

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; fast cpu compensation
   ;;
   ;; inner loop is timed for a 3.5MHz
   ;; cpu and is intended to last 22us
   ;;
   ;; we can compensate for fast cpus
   ;; by inserting a T-state delay
   ;; computed from:
   ;;
   ;; T = (22us)(Fcpu) - 79
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 4409090) & (__clock_freq <= 12363636)
   
                     ld a,+((__clock_freq * 22) / 1000000 - 81) / 16
      tone_waste_0:  dec a
                     jr nz, tone_waste_0
   
   ENDIF
           
   IF __clock_freq > 12363636
           
      push hl
      push bc
           
      ld hl,+(__clock_freq * 22) / 1000000 - 131
      call asm_z80_delay_tstate
      
      pop bc
      pop hl
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   dec bc                      ; duration_2 -= 1
   
   ld a,b
   or c
   jr nz, tone_loop_1

   ld c,(ix+7)                 ; slide
   ld b,(ix+8)
   
   ex de,hl
   add hl,bc                   ; time_delta += slide
   ex de,hl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; delay 35T to match original routine

           ld b,2
waste_0:   djnz waste_0
           ld b,2
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: outer loop time = 174T
   ;;
   ;; fast cpu compensation
   ;;
   ;; outer loop is timed for a 3.5MHz
   ;; cpu and is intended to last 49.7us
   ;;
   ;; T state compensation is:
   ;;
   ;; T = (49.7us)(Fcpu) - 174
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 3863179) & (__clock_freq <= 6961770)
   
                     ld a,+(((__clock_freq * 49) / 1000000) + ((__clock_freq * 7) / 10000000) - 176) / 16
      tone_waste_1:  dec a
                     jr nz, tone_waste_1
   
   ENDIF
           
   IF __clock_freq > 6961770
           
      push hl
           
      ld hl,+((__clock_freq * 49) / 1000000) + ((__clock_freq * 7) / 10000000) - 205
      call asm_z80_delay_tstate
      
      pop hl
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   exx
   
   ld a,l                      ; duty change
   add a,(ix+10)
   ld l,a

   dec de                      ; duration_1 -= 1
   
   ld a,d
   or e
   
   exx

   pop bc                      ; bc = duration_2
   jr nz, tone_loop_0

   ld bc,11
   jr next_data

; *************************************************************

sfx_routine_noise:

   ; PLAY NOISE WITH TWO PARAMETERS
   ; note: the first 8k of memory must contain random-like data

   ; ix = & block descriptor
   ; bc = duration_2
   ;  h'= sound_bit_state
   ; bc'= port_16 when sound_bit_method == 2
   ; de'= duration_1

   ld e,(ix+5)                 ; e = noise_period
   
   ld d,1
   ld h,d
   ld l,d
   
   exx
   ld l,__sound_bit_toggle
   exx

   ; ix = & block descriptor
   ; hl = & random_data
   ; bc = duration_2
   ;  d = noise_count
   ;  e = noise_period
   ;  h'= sound_bit_state
   ;  l'= __sound_bit_toggle
   ; de'= duration_1
   ; bc'= port_16 when sound_bit_method == 2

noise_loop_0:

   push bc                     ; save duration_2
   
noise_loop_1:

   ld a,(hl)
   
   exx
   
   and l                       ; toggle bits are random
   or h                        ; mix with bit_state

   INCLUDE "sound/bit/z80/output_bit_device_1.inc"
   
   exx
   
   dec d                       ; noise_count -= 1
   jr nz, period_continue
   
   ; noise period elapsed
   
   ld d,e                      ; reset noise_period
   inc hl                      ; advance random data pointer

   ld a,h                      ; keep random data pointer in first 8k
   and 31
   ld h,a

period_continue:

   ;; note: original inner loop time    = 74T
   ;;       implemented inner loop time = 76T, 77T, 78T

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; fast cpu compensation
   ;;
   ;; inner loop is timed for a 3.5MHz
   ;; cpu and is intended to last 21.1us
   ;;
   ;; we can compensate for fast cpus
   ;; by inserting a T-state delay
   ;; computed from:
   ;;
   ;; T = (21.1us)(Fcpu) - 76
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 4454976) & (__clock_freq <= 12748815)
   
                     ld a,+(((__clock_freq * 21) / 1000000) + (__clock_freq / 10000000) - 78) / 16
      noise_waste_0: dec a
                     jr nz, noise_waste_0
   
   ENDIF
           
   IF __clock_freq > 12748815
           
      push hl
      push bc
           
      ld hl,+((__clock_freq * 21) / 1000000) + (__clock_freq / 10000000) - 128
      call asm_z80_delay_tstate
      
      pop bc
      pop hl
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   dec bc                      ; duration_2 -= 1
   
   ld a,b
   or c
   jr nz, noise_loop_1

   ld a,e
   add a,(ix+6)                ; noise period slide
   ld e,a

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; delay 17T to match original routine

   ld bc,0
   ld c,0

   ;;
   ;; note: outer loop time    = 99T
   ;;
   ;; fast cpu compensation
   ;;
   ;; outer loop is timed for a 3.5MHz
   ;; cpu and is intended to last 28.3us
   ;;
   ;; T state compensation is:
   ;;
   ;; T = (28.3us)(Fcpu) - 99
   ;;
   ;; Note that fast z80s with different
   ;; instruction timing would require
   ;; different compensation.

   IF (__clock_freq > 4134275) & (__clock_freq <= 9575971)
   
                     ld a,+(((__clock_freq * 28) / 1000000) + ((__clock_freq * 3) / 10000000) - 101) / 16
      noise_waste_1: dec a
                     jr nz, noise_waste_1
   
   ENDIF
           
   IF __clock_freq > 9575971
           
      push hl
           
      ld hl,+((__clock_freq * 28) / 1000000) + ((__clock_freq * 3) / 10000000) - 130
      call asm_z80_delay_tstate
      
      pop hl
   
   ENDIF
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop bc                      ; restore duration_2
   
   exx
   
   dec de                      ; duration_1 -= 1
   
   ld a,d
   or e
   
   exx
   
   jr nz, noise_loop_0

   ld bc,7
   jr next_data
