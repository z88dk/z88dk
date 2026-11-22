; TI-83 Plus file slots.
; A slot is 19 bytes. The CRT zeroes bss, so a slot starts closed.
;
;  0  name     9   OP1 image (type and up to 8 tokens)
;  9  page     1   0 is RAM, otherwise the archive page
; 10  offset   2   first payload byte
; 12  position 2
; 14  size     2   payload bytes
; 16  flags    1
; 17  vat      2   symbol-table entry

defc    TI_NSLOTS   = 8
defc    TI_SLOT     = 19
defc    TI_MIN_FD   = 3

defc    TI_OPEN     = 1
defc    TI_WRITE    = 2
defc    TI_GROW     = 4
defc    TI_ARCH     = 8
defc    TI_HSIZE    = 16
defc    TI_READ     = 32

defc    fs_page     = 9
defc    fs_off      = 10
defc    fs_pos      = 12
defc    fs_size     = 14
defc    fs_flags    = 16
defc    fs_vat      = 17

; include/fcntl.h and include/errno.h. This unit is not compiled as C.
defc    O_RDONLY    = 0
defc    O_WRONLY    = 1
defc    O_RDWR      = 2
defc    O_APPEND    = 256
defc    O_TRUNC     = 512
defc    O_CREAT     = 1024

defc    SEEK_SET    = 0
defc    SEEK_CUR    = 1
defc    SEEK_END    = 2

defc    EACCES      = 1
defc    EBADF       = 2
defc    EINVAL      = 6
defc    EMFILE      = 7
defc    ENOMEM      = 10
defc    ENOTSUP     = 11

EXTERN  tiei
EXTERN  tidi

; The OS reads IY as the flag pointer and may use IX.
MACRO TICALL addr
    push    ix
    push    iy
    ld      iy,_IY_TABLE
    call    tiei
    rst     $28
    defw    addr
    call    tidi
    pop     iy
    pop     ix
ENDM
