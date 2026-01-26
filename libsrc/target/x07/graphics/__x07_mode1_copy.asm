SECTION code_clib
PUBLIC __x07_mode1_copy

EXTERN  __x07_buffer
EXTERN  __x07_mode1_screen
EXTERN  __x07_mode1_dirty
EXTERN  __x07_SUB_EXECUTE

INCLUDE "target/x07/def/x07.h"
            
                        



;
; Copy the virtual mode1 screen onto the UDCs that hold it
; 0x80 -> 0x9f and 0xe0 -> 0xff
__x07_mode1_copy:
    xor     a
    ld      hl,__x07_mode1_dirty
    ld      de,__x07_mode1_screen
    call    @docopy
    ld      a,1
    ld      hl,__x07_mode1_dirty + 20
    ld      de,__x07_mode1_screen + 128
    call    @docopy
    ld      a,2
    ld      hl,__x07_mode1_dirty + 40
    ld      de,__x07_mode1_screen +256
    call    @docopy
    ld      a,3
    ld      hl,__x07_mode1_dirty + 60
    ld      de,__x07_mode1_screen + 384

    ; Fall through to @docopy

; hl = dirty array
; de = screen buffer
@docopy:
    ld      (_print_buffer+1),a
    ld      b,20        ;number of characters to do
    ld      c,0         ;column
@loop:
    ld      a,(hl)
    and     a
    jp      z,@skip_copy
    
    ; We are dirty.
    ld      (hl),0      ; Clear dirty flag
    
    push    hl
    push    de
    push    bc

    ld      a,c
    ld      (_print_buffer+0),a
    
    ; Calculate bit offset for this column
    ld      a,20
    sub     b           ; a= column
    
    ; Calculate byte offset = (col * 6) / 8
    ld      l,a
    add     a,a         ; * 2
    add     a,l         ; * 3
    add     a,a         ; * 6
    ld      l,a         ; l = col * 6
    rra
    rra
    rra                 
    and     @00011111   ; a = byte offset
    
    ; Add byte offset to de (screen base)
    add     a,e
    ld      e,a
    adc     a,d
    sub     e
    ld      d,a
    
    ; Calculate shift = (col * 6) % 8
    ld      a,l
    and     7
    
    push    de          ; Save screen buffer ptr
    
    ; 8080 dispatch setup (slide)
    ld      e,a         ; e = shift amount
    ld      hl,@mask
    ld      a,l
    sub     e
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    ld      (@sm_jump+1),hl
    
    pop     de          ; Restore screen buffer ptr
    
    ld      hl,__x07_buffer
    ld      (hl),0x80
    inc     hl

    
    ld      b,8         ; 8 rows
@row_loop:
    ld      a,(de)
    ld      c,a
    inc     de
    ld      a,(de)
    dec     de
    
    ; c = byte 0, a = byte 1
    ; Shift CA left by shift amount
    push    hl
    ld      h,c
    ld      l,a
@sm_jump:
    jp      0           ; Self-modified

@shifts:
    add     hl,hl       ; 6
    add     hl,hl       ; 5
    add     hl,hl       ; 4
    add     hl,hl       ; 3
    add     hl,hl
    add     hl,hl   
@mask:
    ld      a,h
; Reverse the bytes
    pop     hl          ; screen
    and     0xfc        ; Keep top 6 bits

    ld      (hl),a
    inc     hl
    
    ; Next row (stride 16)
    ld      a,e
    add     a,16
    ld      e,a
    adc     a,d
    sub     e
    ld      d,a
    
    djnz    @row_loop

    ; Send to coprocessor
    ld      hl,__x07_buffer
    ld      a,SUB_UDC_WRITE
    ld      bc,0x0900
    call    __x07_SUB_EXECUTE

    ld      hl,_print_buffer
    ld      a,SUB_LOCATE
    ld      bc,0x0300
    call    __x07_SUB_EXECUTE

    pop     bc
    pop     de
    pop     hl


@skip_copy:
    inc     c       ;increment x position
    inc     hl      ;Increment dirty
    
@no_row_wrap:
    djnz    @loop
    ret


SECTION data_clib

_print_buffer:
    defb    0x00        ; x
    defb    0x00        ;y
    defb    0x80        ;character