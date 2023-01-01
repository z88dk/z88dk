; Setup interrupts table
;


SECTION code_clib

PUBLIC asm_interrupt_init
PUBLIC cpm_platform_init

EXTERN asm_interrupt_handler
EXTERN im1_vectors
EXTERN nabu_set_interrupts

EXTERN __nabu_lastk

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
    ei
cpm_platform_init:
    ret


; Keyboard handler
int_keyboard:
    di
    push    af
    push    hl
    call    handle_keyboard
    call    handle_vdp
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
    in      a,($90)
    bit     7,a
    ret     nz
    ld      (__nabu_lastk),a
    ;; TODO: Debounce stuff etc
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

    ld     l,@00110000         ;Use vsync + keyboard
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
    ei

    SECTION data_clib

def_ints:
    defw    int_noop       ; HCCA RX
    defw    int_noop       ; HCCA Send
    defw    int_keyboard   ; Keyboard
    defw    int_vsync      ; VSync
    defw    int_noop       ; Card0
    defw    int_noop       ; Card1
    defw    int_noop       ; Card2
    defw    int_noop       ; Card3

SECTION bss_clib

old_ints: defs 16
