; $Id: bit_synth.asm,v 1.3 2016-06-16 20:23:52 dom Exp $
;
; void bit_synth(int duration, int frequency1, int frequency2, int frequency3, int frequency4);
;
; Generic platform sound library.
; synthetizer - this is a sort of "quad sound" routine.
; It is based on 4 separate counters and a delay.
; Depending on the parameters being passed it is able to play
; on two audible voices, to generate sound effects and to play
; with a single voice having odd waveforms.
;
; The parameters are passed with a self modifying code trick  :o(
; This routine shouldn't stay in contended memory locations !!
;

	  SECTION code_clib
          PUBLIC     bit_synth
          PUBLIC     _bit_synth
          INCLUDE  "games/games.inc"

          EXTERN      bit_open_di
          EXTERN      bit_close_ei

.bit_synth
._bit_synth
	  push    ix		;save callers ix
          ld      ix,4
          add     ix,sp
          ld      a,(ix+8)
          ld      (LEN+1),a
          ld      a,(ix+6)
          and     a
          jr      z,FR1_blank
          ld      (FR_1+1),a
          ld      a,sndbit_mask
.FR1_blank
          ld      (FR1_tick+1),a
          ld      a,(ix+4)
          and     a
          jr      z,FR2_blank
          ld      (FR_2+1),a
          ld      a,sndbit_mask
.FR2_blank
          ld      (FR2_tick+1),a
          ld      a,(ix+2)
          and     a
          jr      z,FR3_blank
          ld      (FR_3+1),a
          ld      a,sndbit_mask
.FR3_blank
          ld      (FR1_tick+1),a
          ld      a,(ix+0)
          and     a
          jr      z,FR4_blank
          ld      (FR_4+1),a
          ld      a,sndbit_mask
.FR4_blank
          ld      (FR1_tick+1),a

          call    bit_open_di
          ld      h,1
          ld      l,h
          ld      d,h
          ld      e,h
.LEN
          ld      b,50
.loop
          ld      c,4
.loop2
          dec     h
          jr      nz,jump
.FR1_tick
          xor     sndbit_mask

;-----
          out  (255),a
          jp   z,isz

          ex   af,af
          in   a,(254)
          ex   af,af
.isz
;-----

.FR_1
          ld      h,80
.jump
          dec     l
          jr      nz,jump2
.FR2_tick
          xor     sndbit_mask

;-----
          out  (255),a
          jp   z,isz2

          ex   af,af
          in   a,(254)
          ex   af,af
.isz2
;-----

.FR_2
          ld      l,81
.jump2
          dec     d
          jr      nz,jump3
.FR3_tick
          xor     sndbit_mask

;-----
          out  (255),a
          jp   z,isz3

          ex   af,af
          in   a,(254)
          ex   af,af
.isz3
;-----

.FR_3
          ld      d,162
.jump3
          dec     e
          jr      nz,loop2
.FR4_tick
          xor     sndbit_mask

;-----
          out  (255),a
          jp   z,isz4

          ex   af,af
          in   a,(254)
          ex   af,af
.isz4
;-----

.FR_4
          ld      e,163
          
          dec     c
          jr      nz,loop2
          djnz    loop
          call	bit_close_ei
          pop 	ix		;restore callers
          ret
