; Handling for printing in SAM modes

; SAM mode 1 - as per zx
;
; SAM mode 2 - linear
; 6144 bit patterns (32 bytes per row)
; attributes 8192 bytes apart (as per timex hires)
; 6144 byte attributes

; Sam mode 3
; 24576 bit patterns (128 bytes per row) - 512x192
; p0 = left
; p0 p0 p1 p1 p2 p2 p3

;Sam mode 4    
; 24576 - attr + bit - 256 x 192
;
; p0 p0 p0 p0 p1 p1 p1 p1

    MODULE  __sam_printc
    PUBLIC  __sam_printc

    PUBLIC  __sam_xypos_MODE3
    PUBLIC  __sam_xypos_MODE4

    EXTERN  printc_MODE2
    EXTERN  printc_MODE3
    EXTERN  printc_MODE4

    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  __zx_screenmode
    EXTERN  generic_console_flags
   
    EXTERN  SCREEN_BASE


; Print on screen for MODE 2,3,4
;
; The screen mode change routine, only switches to here for these modes, mode 1 is handled
; by the standard +zx code, so there we get a choice of 32/64 characters
;
; Entry: b = y
;        c = x
;        d = character toprint
__sam_printc:
    ld      a,d         ;save character
    exx
    ld      bc,(__zx_32col_font)
    dec     b
    bit     7,a
    jr      z,handle_characters
    ld      bc,(__zx_32col_udgs)
    res     7,a
handle_characters:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    ld      a,(generic_console_flags)
    ld      b,a
    rlca
    sbc     a,a             ; ; c = 0/ c = 255
    ld      c,a
    exx    
    ; bc = b = y, c = x, coordinates to print at
    ; hl' = font
    ; c' = inverse flag
    ; b' = flags
    ld      a,(__zx_screenmode)
    cp      1
    jp      z,printc_MODE2
    cp      2
    jp      z,printc_MODE3
    jp      printc_MODE4






; convert character x,y to address
; Entry: b = row
;        c = column
;
;Mode 3,4; Char rows are 1024 bytes
__sam_xypos_MODE4:
    ld      a,b
    add     a
    add     a       ;*4
    add     +(SCREEN_BASE / 256)
    ld      h,a     ;Row * 1024 + screen base
    ; Now, how many bytes per character?
    sla     c
    sla     c       ;4 bytes needed for a character
    ld      l,c
    ret

__sam_xypos_MODE3:
    ld      a,b
    add     a
    add     a       ;*4
    add     +(SCREEN_BASE / 256)
    ld      h,a     ;Row * 1024 + screen base
    ; Now, how many bytes per character?
    ld      a,c
    add     a
    ld      l,a
    ret
    
