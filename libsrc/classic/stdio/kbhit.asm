    MODULE  kbhit
    SECTION code_clib

    PUBLIC  kbhit
    PUBLIC  _kbhit
    PUBLIC  getch
    PUBLIC  _getch

    EXTERN  getk
    EXTERN  fgetc_cons
    EXTERN  msleep
    EXTERN  __CLIB_KBHIT_DELAY


kbhit:
_kbhit:
IF __CPU_GBZ80__
    ld      hl,kbhit_key
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    or      h
    ret     nz
    call    getk
    ld      de,kbhit_key
    ld      a,l
    ld      (de),a
    inc     de
    ld      a,h
    ld      (de),a
    ld      d,h
    ld      e,l
    ret
ELSE
    ld      hl,(kbhit_key)	; check if we've got a keypress pending
    ld      a,h
    or      l
    ret     nz		; we've got something pending
    call    getk		; read the keyboard
    ld      (kbhit_key),hl
    ret
ENDIF

getch:
_getch:
IF __CPU_GBZ80__
    ld      hl,kbhit_key
    ld      a,(hl+)
    ld      e,a
    ld      d,(hl)
    xor     a
    ld      (hl-),a
    ld      (hl),a
    ld      h,d
    ld      l,e
ELSE
    ld      hl,(kbhit_key)
    ld      de,0
  IF __CPU_INTEL__
    ex      de,hl
    ld      (kbhit_key),hl
    ex      de,hl
  ELSE
    ld      (kbhit_key),de
  ENDIF
ENDIF
    ld      a,h
    or      l
    jp      z,fgetc_cons
    push    hl
    ld      hl,__CLIB_KBHIT_DELAY
    ld      a,h
    or      l
    call    nz,msleep
    pop     hl
    ret

    SECTION	bss_clib

kbhit_key:	defw	0

