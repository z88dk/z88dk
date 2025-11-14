
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

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_beepfx

EXTERN asm_bit_open, asm_bit_close

asm_bit_beepfx:

   ; enter : ix = void *effect
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
   
   exx
   
   call asm_bit_open
   
   and ~__SOUND_BIT_TOGGLE
   ld h,a                      ; h'= sound_bit_state with output bit = 0

   IF __SOUND_BIT_METHOD = 2

      ld bc,__SOUND_BIT_PORT
   
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
   
   ld l,__SOUND_BIT_TOGGLE
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
   ;; loop is timed for 3.5 MHZ cpu

;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 16
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

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
   ;; loop is timed for 3.5 MHZ cpu
   
;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 75
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
   dec e
   jr nz, sample_loop_1
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: outer loop time = 46T
   ;;
   ;; loop is timed for a 3.5MHz cpu
   
;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 46
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

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
   
   and __SOUND_BIT_TOGGLE      ; set toggle bit if yes
   or h                        ; mix with bit_state

   INCLUDE "sound/bit/z80/output_bit_device_1.inc"
      
   exx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: original inner loop time    = 77T
   ;;       implemented inner loop time = 79T, 80T, 81T
   ;;
   ;; loop is timed for a 3.5MHz cpu
   
;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 80
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

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
   ;; loop is timed for a 3.5MHz cpu
   
;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 174
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

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
   ld l,__SOUND_BIT_TOGGLE
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

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: original inner loop time    = 74T
   ;;       implemented inner loop time = 76T, 77T, 78T
   ;;
   ;; loop is timed for a 3.5MHz cpu
   
;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 77
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

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

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; note: outer loop time    = 99T
   ;;
   ;; loop is timed for a 3.5MHz cpu
   
;   defc NOMINAL_CLOCK = 3500000
;   defc NOMINAL_T     = 99
;   defc TARGET_CLOCK  = __clock_freq
;   
;   INCLUDE "sound/bit/z80/cpu_speed_compensate.inc"

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
