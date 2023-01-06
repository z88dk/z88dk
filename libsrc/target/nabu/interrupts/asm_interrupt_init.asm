; Setup interrupts table
;


SECTION code_clib

INCLUDE "target/nabu/def/nabu.def"

PUBLIC asm_interrupt_init
PUBLIC cpm_platform_init

EXTERN asm_interrupt_handler
EXTERN im1_vectors
EXTERN nabu_set_interrupts

EXTERN __nabu_lastk
EXTERN __nabu_key_mode
EXTERN __nabu_j1
EXTERN __nabu_j2


; It's assumed that im2 is already setup before entry
asm_interrupt_init:
    di
    ld      a,i
    ld      h,a
    ld      l,0
    push    hl
    ld      de,old_ints
    ld      bc,16
    ldir
    pop     de
    ld      hl,def_ints
    ld      bc,16
    ldir
    ld      a,PSG_REG_IO_A
    out     (IO_AY_LATCH),a
    in      a,(IO_AY_DATA)
    ld      (old_enabled),a
    ei
cpm_platform_init:
    ret

int_hccarx:
    di
    push    af
    push    hl
;    call    handle_hcca_rx
    pop     hl
    pop     af
    ei
    ret

int_hccatx:
    di
    push    af
    push    hl
;    call    handle_hcca_tx
    pop     hl
    pop     af
    ei
    ret

; Keyboard handler
int_keyboard:
    di
    push    af
    push    hl
    call    handle_keyboard
    pop     hl
    pop     af
    ei
    ret


    EXTERN    __tms9918_status_register
    EXTERN    VDP_STATUS
int_vsync:
    di 
    push    af
    push    hl
    call    handle_vdp
    pop     hl
    pop     af
    ei
    ret

int_noop:
    ret

handle_keyboard:
    ld      a,(__nabu_key_mode)
    ld      hl,__nabu_j1
    cp      1
    jr      z,handle_joy
    ld      hl,__nabu_j1
    cp      2
    jr      z,handle_joy
    in      a,($90)
    cp      $80
    jr      z,set_joystick
    cp      $81
    jr      z,set_joystick
    cp      $90
    jr      c,set_key
    cp      $95
    ret     c
set_key:
    ld      (__nabu_lastk),a
    ;; TODO: Debounce stuff etc
    ret

set_joystick:
    sub     $7f
    ld      (__nabu_key_mode),a
    ret

handle_joy:
    in      a,($90)
    and     31
    ld      (hl),a
    xor     a
    ld      (__nabu_key_mode),a
    ret

handle_vdp:
    in      a,(VDP_STATUS)
    ld      (__tms9918_status_register),a
    or      a
    ret     p
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    ret


    SECTION code_crt_init

    ld     l,INT_MASK_VDP | INT_MASK_KEYBOARD
    call   nabu_set_interrupts
    call   asm_interrupt_init

    SECTION code_crt_exit

    ; Restore old interrupt setup
    di
    ld     a,i
    ld     d,a
    ld     e,0
    ld     hl,old_ints
    ld     bc,16
    ldir
    ld     a,(old_enabled)
    ld     l,a
    call   nabu_set_interrupts
    ei

    SECTION data_clib

def_ints:
    defw    int_hccarx     ; HCCA RX
    defw    int_hccatx     ; HCCA Send
    defw    int_keyboard   ; Keyboard
    defw    int_vsync      ; VSync
    defw    int_noop       ; Card0
    defw    int_noop       ; Card1
    defw    int_noop       ; Card2
    defw    int_noop       ; Card3

SECTION bss_clib

old_enabled: defb 0
old_ints: defs 16
