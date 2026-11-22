
;
;  Apple II Z80 SoftCard
;
;  Stefano, 2025
;
;  Send a special character code sequence basing on the current I/O config
;  Use the BIOS directly for outputting to console
;
;-----------------------------------------------------------------------------
;
;	$Id: a2_ctl.asm $
;
;-----------------------------------------------------------------------------


    SECTION code_clib
    PUBLIC  a2_ctl
    PUBLIC  _a2_ctl
    PUBLIC  a2_sendchar
    PUBLIC  _a2_sendchar


a2_ctl:
_a2_ctl:
  LD H,0
  LD DE,$F397    ; Software screeen functions
  ADD HL,DE
  LD A,(HL)
  OR A           ; See if lead-in character is required
  RET Z
  JP P,no_prefix
  AND $7F
  PUSH AF
  LD A,($F397)   ; Software function lead in character
  CALL a2_char
  POP AF
; This entry point is used by the routine at __VTAB.
no_prefix:
  JP a2_char



a2_sendchar:
_a2_sendchar:
    ld      a,l
a2_char:
    ld      c, a
    ld      de, 9        ; shift ptr to CONOUT
    ld      hl, (1)      ; WBOOT (BIOS)
    add     hl, de
    jp      (hl)

