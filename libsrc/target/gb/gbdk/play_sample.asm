


        MODULE  play_sample

        PUBLIC  play_sample
        PUBLIC  _play_sample

	EXTERN	asm_play_sample

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

;void __LIB__ play_sample(uint8_t *start, uint16_t len) __smallc NONBANKED;
play_sample:
_play_sample:
  push bc
  ld  hl,sp+6
  ld a,(hl+)	;start
  ld d,(hl)
  ld e,a

  ld  hl,sp+4	;length
  ld a,(hl+)
  ld b,(hl)
  ld c,a

  ld h,d
  ld l,e

  call asm_play_sample
  pop bc
  ret
