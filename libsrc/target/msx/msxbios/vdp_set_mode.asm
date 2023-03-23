;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern bool __FASTCALL__ vdp_set_mode(unsigned char id);
;
;	set screen mode - used for MSX and SVI only
;
;	$Id: vdp_set_mode.asm $
;

    SECTION code_clib
    PUBLIC	vdp_set_mode
    PUBLIC	_vdp_set_mode

    EXTERN	msxbios
    EXTERN  __tms9918_pattern_name
    EXTERN  __tms9918_pattern_generator
    EXTERN  __tms9918_sprite_attribute
    EXTERN  __tms9918_sprite_generator
    EXTERN  __tms9918_colour_table
    EXTERN  __tms9918_set_font
    EXTERN  __console_w
    EXTERN  __tms9918_screen_mode
    EXTERN   generic_console_caps
    EXTERN   __tms9918_CAPS_MODE0
    EXTERN   __tms9918_CAPS_MODE1
    EXTERN   __tms9918_CAPS_MODE2
    EXTERN   __tms9918_CAPS_MODE3
    EXTERN   CONSOLE_COLUMNS

IF FORmsx
    INCLUDE	"target/msx/def/msxbios.def"
ENDIF

IF FORsvi
    INCLUDE	"video/tms9918/vdp.inc"
    INCLUDE "target/svi/def/svibios.def"
    INCLUDE "target/svi/def/svibasic.def"
ENDIF

vdp_set_mode:
_vdp_set_mode:

    ex      de,hl
    ld      a,e
    and     a
    jr      z,set_mode_0
    cp      1
    jp      z,set_mode_1
    cp      2
    jr      z,set_mode_2

    cp      3
    jr      z,set_mode_3
    ; Otherwise, it's a custom firmware call
    ex      de,hl	;hl = mode
    ld      de,0 + CONSOLE_COLUMNS	;width
    ld      bc,0 + 4		;mode=4 (we don't handle that anywhere)
    xor     a
set_mode:
    ld      (generic_console_caps),a
    ld      a,c
    ld      (__tms9918_screen_mode),a
    ld      c,0
    ld      a,e
    ld      (__console_w),a
    ld      e,0
    ld      (__tms9918_pattern_name),de
    ld      (__tms9918_pattern_generator),bc
    push    ix
    push    hl
    pop     ix
    call    msxbios
    pop     ix
    ret

set_mode_3:
    ld      hl,0
    ld      (__tms9918_colour_table),hl
    ld      hl,$3800
    ld      (__tms9918_sprite_generator),hl
    ld      hl,$1b00
    ld      (__tms9918_sprite_attribute),hl
    ld      de,$800 + CONSOLE_COLUMNS   ;pattern name
    ld      bc,$0000 + 3        ;Pattern generator + mode
    ld      hl,INIMLT
    ld      a,__tms9918_CAPS_MODE3
    jr      set_mode

; 32x24 graphics
set_mode_2:
    ld      hl,$2000
    ld      (__tms9918_colour_table),hl
    ld      hl,$3800
    ld      (__tms9918_sprite_generator),hl
    ld      hl,$1b00
    ld      (__tms9918_sprite_attribute),hl
    ld      hl,INIGRP
    ld      de,$1800 + CONSOLE_COLUMNS	;pattern name
    ld      bc,$0000 + 2	;pattern generator
    ld      a,__tms9918_CAPS_MODE2
    jr      set_mode


; 40x24 mode
set_mode_0:
    ld      hl,0
    ld      (__tms9918_colour_table),hl
    ld      (__tms9918_sprite_generator),hl
    ld      (__tms9918_sprite_attribute),hl
    ld      (__tms9918_colour_table),hl
    ld      hl,INITXT
    ld      de,$0000 + 40   ; pattern name + width
    ld      bc,$0800 +1     ; pattern generator
    ld      a,__tms9918_CAPS_MODE0
    call    set_mode
    call    __tms9918_set_font
    ret


; 32x24 mode
IF FORmsx
set_mode_1:
    ld      hl,$2000
    ld      (__tms9918_colour_table),hl
    ld      hl,$3800
    ld      (__tms9918_sprite_generator),hl
    ld      hl,$1b00
    ld      (__tms9918_sprite_attribute),hl
    ld      de,$1800 + CONSOLE_COLUMNS   ; pattern name + width
    ld      bc,$0000 + 0  ; pattern generator + mode
    ld      hl,INIT32
    ld      a,__tms9918_CAPS_MODE1
    call    set_mode
    call    __tms9918_set_font
    ret

ELSE
set_mode_1:
    ld      hl,$2000
    ld      (__tms9918_colour_table),hl
    ld      hl,$3800
    ld      (__tms9918_sprite_generator),hl
    ld      hl,$1b00
    ld      (__tms9918_sprite_attribute),hl
    ld      de,$1800  ; pattern name 
    ld      bc,$0000  ; pattern generator 
    ld      a,1
    ld      (__tms9918_screen_mode),a
    ld      a,CONSOLE_COLUMNS
    ld      (__console_w),a
    ld      (__tms9918_pattern_name),de
    ld      (__tms9918_pattern_generator),bc
    ld      hl,INIGRP		; (Graphics 2)
    ld      a,__tms9918_CAPS_MODE1
    call    set_mode
    xor     a			; change reg#0 on SVI
    ; Now bend the configuration to Graphics mode 1
    ld    (RG0SAV),a
    di
    out     (VDP_CMD),a
    or      $80
    ei
    out	(VDP_CMD),a


    ; Bend register #3
    ld      a,$80
    di
    out     (VDP_CMD),a
    ld      a,3  ; reg3
    or      $80
    ei
    out     (VDP_CMD),a

    ; Bend register #4
    xor     a
    di
    out     (VDP_CMD),a
    ld      a,4  ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    or      $80
    ei
    out     (VDP_CMD),a

    ld      hl,$1800   ; pattern name
    ld      bc,32*24
    ld      a,c	; ' '
    ld      ix,FILVRM
    call    msxbios

    LD      A,(FORCLR)
    ADD     A,A
    ADD     A,A
    ADD     A,A
    ADD     A,A
    LD      HL,BAKCLR
    OR      (HL)

    ld      hl,$2000		; SCREEN 1 color table
    ld      bc,32
    ld      ix,FILVRM
    call    msxbios
    call    __tms9918_set_font
    ret
	
ENDIF
