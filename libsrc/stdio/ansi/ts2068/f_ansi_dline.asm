;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Clean a text line
;
;	Stefano Bodrato - Apr. 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_del_line


.ansi_del_line
;  push af
  and 24
  ld d,a
  pop af
  push af
  and 7
  rrca 
  rrca
  rrca
  ld e,a
  ld hl,16384
  add hl,de ;Line address in HL
  ld d,h
  ld e,l
  inc de
  ld b,8
.loop_dl
  push bc
  push hl
  push de
  ld (hl),0
  ld bc,31
  ldir
;second display
  set 5,d
  ld bc,32
  lddr
  pop de
  pop hl
  inc d
  inc h
  pop bc
  djnz loop_dl
;  pop af
;  ld d,0
; ld e,a
;  rr e
;  rr d
;  rr e
;  rr d
;  rr e
;  rr d
;  ld hl,22528
;  add hl,de
;  ld d,h
;  ld e,l
;  inc de
;  ld a,(23693) ; Use the default attributes
;  ld (hl),a
;  ld bc,31
;  ldir
;  ret
