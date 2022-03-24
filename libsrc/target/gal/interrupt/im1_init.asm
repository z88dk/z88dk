    SECTION code_clib
    PUBLIC  im1_init
    PUBLIC  _im1_init

    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler

im1_init:
_im1_init:
    call    l_push_di
    ld      (__saved_iy),iy
    ld      (im_patch+1),iy
    ld      iy,im1_handler
    call    l_pop_ei
    ret


    SECTION smc_clib

im1_handler:
    ld      hl,im1_vectors
    call    asm_interrupt_handler
im_patch:
    jp      0


    SECTION bss_crt

__saved_iy:
    defw    0

    SECTION code_crt_exit

    di
    ld    iy,(__saved_iy)
    ei
