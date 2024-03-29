;
;	ZX IF1 & Microdrive functions
;
;	int if1_write_sector (int drive, int sector, struct M_CHAN buffer);
;
;	Writes the specified sector to the specified drive.
;
;
;	$Id: if1_write_sector.asm $
;

    SECTION smc_clib
    PUBLIC  if1_write_sector
    PUBLIC  _if1_write_sector

    EXTERN  if1_rommap

    EXTERN  MAKE_M
    EXTERN  MOTOR
    EXTERN  WR_SECT


if1_write_sector:
_if1_write_sector:

    call    if1_rommap
    push    ix                          ;save callers
    ld      ix, 4
    add     ix, sp
    ld      a, (ix+4)
    ld      hl, -1
    and     a                           ; drive no. = 0 ?
    jr      z, write_sector_close       ; yes, return -1
    cp      9                           ; drive no. >8 ?
    jr      nc, write_sector_close      ; yes, return -1

    push    af

    ld      a, (ix+2)                   ; sector number
    push    af

    ld      l, (ix+0)                   ; buffer
    ld      h, (ix+1)
    ld      (__mdvbuffer+1), hl         ; Self modifying code  :oP

    call    MAKE_M

    pop     af                          ; sector number
    ld      (ix+0Dh), a                 ; CHREC

    pop     af
    ld      (ix+19h), A                 ; CHDRIV

    call    MOTOR
    ld      hl, -1
  IF    !OLDIF1MOTOR
    jr      nz, write_sector_exit       ; microdrive not present
  ENDIF
    in      a, ($ef)
    and     1                           ; test the write-protect tab
    jr      z, write_sector_exit        ; drive 'write' protected

    push    ix
    pop     hl
    ld      de, 37h                     ; point to 12 bytes of data block preamble
    add     hl, de

    push    hl
__mdvbuffer:
    ld      hl, 0
    add     hl, de
    pop     de

    ld      bc, 21ch
    ldir

    set     0, (ix+18h)                 ; set CHFLAG to "write" mode

		;call	1
		;
		;rst	8
		;defb	2Ah		; Write a sector to drive

    LD      HL, $00FF                   ; set counter to ensure at least one revolution
    call    WR_SECT

    call    1

    xor     a
    rst     8
    defb    21h                         ; Switch microdrive motor off (a=0)

;		RST	8
;		defb	2Ch		; Reclaim an "M" channel

    ld      hl, 0
write_sector_exit:
    push    hl
    RST     8
    defb    2Ch                         ; Reclaim an "M" channel
    pop     hl
write_sector_close:
    pop     ix
    ret
