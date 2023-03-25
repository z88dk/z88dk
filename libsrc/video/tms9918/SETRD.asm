;
; z88dk library: Generic VDP support code
;
; $Id: gen_setrd.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_video_vdp
	PUBLIC	SETRD
	PUBLIC	_SETRD

        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts

	INCLUDE	"video/tms9918/vdp.inc"

;==============================================================
; VRAM to HL
;==============================================================
; Sets VRAM read address to hl
;
; CORRUPTS bc
;==============================================================
.SETRD
._SETRD
    call    l_tms9918_disable_interrupts
IFDEF V9938
    ; High bit of address (bits 14,15,16)
    ld      a,h
    rlca
    rlca
    and     3           ;Ignoring bit 16
  IF VDP_DATA < 0
    ld      (-VDP_CMD),a
    ld      a,14 + 0x80
    ld      (-VDP_CMD),a
  ELIF VDP_DATA < 256
    out     (VDP_CMD),a
    ld      a,14 + 0x80
    out     (VDP_CMD),a
  ELSE
     ; TODO V9938 on SPC-1000 etc
  ENDIF
ENDIF
    ld      a,l
IF VDP_CMD < 0
    ld      (-VDP_CMD),a
ELIF VDP_CMD < 256
    out     (VDP_CMD),a
ELSE
    ld      bc,VDP_CMD
    out     (c),a
ENDIF
    ld      a,h
    and     $3F
IF VDP_CMD < 0
    ld      (-VDP_CMD),a
ELIF VDP_CMD < 256
    out     (VDP_CMD),a
ELSE
    out     (c),a
ENDIF
    call    l_tms9918_enable_interrupts
    ret
