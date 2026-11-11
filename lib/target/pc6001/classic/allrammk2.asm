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

l_dcal:
    jp          (hl)

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
