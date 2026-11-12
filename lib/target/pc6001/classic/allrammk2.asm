; Startup 5 (-subtype=mk2disc): a PC-6001mkII boot disc, the program at $0000 in
; all RAM (see bootstrap_mk2.asm for how it gets there; appmake +pc6001mk2 makes
; the disc).
; The stack is at the top of the RAM below the video RAM ($C000, whose 16 KB is
; the screen in its bitmap modes) unless -pragma-define:REGISTER_SP says
; otherwise.  The program has the mkII's 320x200 console and graphics (mk2.inc,
; pc6001mk2.lib, which this subtype links before pc6001_clib) and the disc and
; overlay routines, and sets up its own interrupts.

  IF    !DEFINED_CRT_ORG_CODE
    defc        CRT_ORG_CODE=$0000
  ENDIF
    defc        TAR__register_sp=$c000
    defc        CRT_KEY_DEL=12          ; the key reader's backspace

    INCLUDE     "target/pc6001/classic/mk2.inc"

; Overlays: the sections OVERLAY_0 ... OVERLAY_n-1, linked at one window by the
; program's own memory map (-pragma-define:MMAP=-1 and a mmap.inc), are put on
; the disc after the program, each from the start of a track, by appmake
; +pc6001mk2, and read into the window by pc6001mk2_overlay_load(n).
; -pragma-define:CRT_PC6001MK2_OVERLAYS=n says how many (up to 8);
; the table at the end (the window, the size) is what the loader works from,
; with the number of tracks the program takes.
  IF    !DEFINED_CRT_PC6001MK2_OVERLAYS
    defc        CRT_PC6001MK2_OVERLAYS=0
  ENDIF
    EXTERN      __DATA_END_tail
    PUBLIC      __pc6001mk2_overlay_table
    PUBLIC      __pc6001mk2_overlay_count
    PUBLIC      __pc6001mk2_image_tracks
    defc        __pc6001mk2_overlay_count=CRT_PC6001MK2_OVERLAYS
    defc        __pc6001mk2_image_tracks=((__DATA_END_tail-CRT_ORG_CODE)+4095)/4096

    INCLUDE     "target/pc6001/classic/common.inc"

    org         CRT_ORG_CODE

start:
    ; The program is at $0000 with the ROM mapped out, so the Z80's own vectors
    ; are ours: a jump over them, then the standard rsts (crt_z80_rsts.inc: RST
    ; $08 to $30 return unless CRT_ENABLE_RST says the program has _z80_rst_NNh;
    ; IM 1 at $38 is "ei, reti" unless _z80_rst_38h is enabled; CRT_ENABLE_NMI
    ; for $66)
    jp          initialise
    INCLUDE     "crt/classic/crt_z80_rsts.inc"
  IF    __crt_enable_nmi=0
    ; (the include has no NMI vector unless it is enabled: the mkII does not use
    ; one, so make it harmless)
    defs        $0066-ASMPC
    retn
  ENDIF
initialise:
    ld          (__restore_sp_onexit+1), sp
                                        ;Save entry stack
    INCLUDE     "crt/classic/crt_init_sp.inc"
    call        crt0_init
  IF    !DEFINED_CRT_PC6001MK2_NO_MODE
    EXTERN      __pc6001mk2_init
    ; the 320x200 mode and its console (-pragma-define:CRT_PC6001MK2_NO_MODE=1:
    ; the program does its own)
    call        __pc6001mk2_init
  ENDIF
    INCLUDE     "crt/classic/crt_init_atexit.inc"

    INCLUDE     "crt/classic/crt_init_heap.inc"
    INCLUDE     "crt/classic/crt_init_eidi.inc"

    call        _main
__Exit:
    call        crt0_exit
    INCLUDE     "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld          sp, 0
noop:
    ; (there is nothing to go back to: the ROM is not there)
    jr          noop

IF    !DEFINED_CRT_PC6001MK2_NO_KEYBOARD
    ; The free space below the interrupt vector table (it is at a page
    ; boundary, so what comes before it is padded): copies of small library
    ; routines.  Their library modules are not linked, as the symbols are
    ; defined here first.
    PUBLIC      l_gint, l_gint1, l_gint2, l_gint3
    PUBLIC      l_gchar, l_gchar_sxt, l_gchar1, l_gchar2, l_gchar3
    PUBLIC      l_pint, l_pint_pop, l_pint_pop_pint
    PUBLIC      l_glong, l_glonghlp
    PUBLIC      l_plong, l_ret, l_jpix, l_jphl
    PUBLIC      l_neg_hl, l_neg_de
l_gchar3:
    inc         hl
l_gchar2:
    inc         hl
l_gchar1:
    inc         hl
l_gchar:
    ld          a, (hl)
l_gchar_sxt:
    ld          l, a
    rlca
    sbc         a, a
    ld          h, a
    ret
l_gint3:
    inc         hl
l_gint2:
    inc         hl
l_gint1:
    inc         hl
l_gint:
    ld          a, (hl)
    inc         hl
    ld          h, (hl)
    ld          l, a
    ret
l_pint_pop:
    pop         bc                      ; return address
    pop         de                      ; where to put it
    push        bc
l_pint:
l_pint_pop_pint:
    ld          a, l
    ld          (de), a
    inc         de
    ld          a, h
    ld          (de), a
    ret
;Fetch long dehl from (hl)
.l_glonghlp
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
.l_glong
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl
    ret
l_plong:
    ld          a, l
    ld          (bc), a
    inc         bc
    ld          a, h
    ld          (bc), a
    inc         bc
    ld          a, e
    ld          (bc), a
    inc         bc
    ld          a, d
    ld          (bc), a
    ret
    ; (not dead: the entries l_ret-1 to l_ret-3 pop that many words and return)
    pop         hl
    pop         hl
    pop         hl
l_ret:
    ret
l_jpix:
    defb        0xdd
l_jphl:
l_dcal:
    jp          (hl)
l_neg_hl:
    ld          a, l
    cpl
    ld          l, a
    ld          a, h
    cpl
    ld          h, a
    inc         hl
    ret
l_neg_de:
    ld          a, e
    cpl
    ld          e, a
    ld          a, d
    cpl
    ld          d, a
    inc         de
    ret
    ; the console's cell address (libsrc/target/pc6001/mk2/pc6001mk2_xypos.asm)
    PUBLIC      __pc6001mk2_xypos
__pc6001mk2_xypos:
    ld          l, b
    ld          h, 0
    ld          d, h
    ld          e, l
    add         hl, hl
    add         hl, hl
    add         hl, de                  ; y * 5
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, hl                  ; y * 320
    ld          a, h
    add         a, +(__pc6001mk2_vram/256)
    ld          h, a
    ld          a, l
    add         a, c
    ld          l, a
    ret         nc
    inc         h
    ret

    ; The interrupt vector table for the keyboard reader (IM 2, library
    ; pc6001mk2_key.asm: getk and fgetc_cons): 20 vectors ($00 to $26) at a page
    ; boundary, all of them "ei, reti" until the library puts its keyboard
    ; routine at $02.  Padding makes the alignment, so this costs up to 295
    ; bytes of the disc and the RAM: -pragma-define:CRT_PC6001MK2_NO_KEYBOARD=1
    ; leaves it out for a program that has no use for the library's keyboard
    ; routines (it has no getk, and sets up its own interrupts).
    PUBLIC      __pc6001mk2_irq_table
    defs        ((ASMPC+255)&$ff00)-ASMPC
__pc6001mk2_irq_table:
    REPT        20
    defw        irq_return
    ENDR
irq_return:
    ei
    reti
ELSE
    PUBLIC      l_jphl
l_dcal:
l_jphl:
    jp          (hl)
ENDIF

    SECTION     rodata_clib
__pc6001mk2_overlay_table:
  IF    CRT_PC6001MK2_OVERLAYS>0
    EXTERN      __OVERLAY_0_head, __OVERLAY_0_size
    defw        __OVERLAY_0_head, __OVERLAY_0_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>1
    EXTERN      __OVERLAY_1_head, __OVERLAY_1_size
    defw        __OVERLAY_1_head, __OVERLAY_1_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>2
    EXTERN      __OVERLAY_2_head, __OVERLAY_2_size
    defw        __OVERLAY_2_head, __OVERLAY_2_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>3
    EXTERN      __OVERLAY_3_head, __OVERLAY_3_size
    defw        __OVERLAY_3_head, __OVERLAY_3_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>4
    EXTERN      __OVERLAY_4_head, __OVERLAY_4_size
    defw        __OVERLAY_4_head, __OVERLAY_4_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>5
    EXTERN      __OVERLAY_5_head, __OVERLAY_5_size
    defw        __OVERLAY_5_head, __OVERLAY_5_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>6
    EXTERN      __OVERLAY_6_head, __OVERLAY_6_size
    defw        __OVERLAY_6_head, __OVERLAY_6_size
  ENDIF
  IF    CRT_PC6001MK2_OVERLAYS>7
    EXTERN      __OVERLAY_7_head, __OVERLAY_7_size
    defw        __OVERLAY_7_head, __OVERLAY_7_size
  ENDIF
