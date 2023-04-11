;
; Read the mode definition table 
;
; - Setup library variables
; - Output to the VDP
; - Call the gencon hook so it can setup tty funcs

;Reg/Bit    7      6    5    4    3    2    1    0
;0          -      -    -    -    -    -    M2   EXTVID
;1          4/16K  BL   GINT M1   M3   -    SI   MAG
;2          -      -    -    -    PN13 PN12 PN11 PN10   * $400
;3          CT13   CT12 CT11 CT10 CT9  CT8  CT7  CT6    * $40
;4          -      -    -    -	  -    PG13 PG12 PG11   * $800
;5          -      SA13 SA12 SA11 SA10 SA9  SA8  SA7    * $80
;6          -      -    -    -    -    SG13 SG12 SG11   * $800

SECTION code_video_vdp
PUBLIC  __tms9918_set_tables

EXTERN  __tms9918_screen_mode
EXTERN  __tms9918_colour_table
EXTERN  __tms9918_pattern_generator
EXTERN  __tms9918_pattern_name
EXTERN  __tms9918_sprite_attribute
EXTERN  __tms9918_sprite_generator
EXTERN  __tms9918_gencon_hook
EXTERN  __tms9918_graphics_hook

EXTERN  __console_w
EXTERN  __tms9918_gfxw
EXTERN  generic_console_caps

EXTERN  VDPreg_Write
EXTERN  l_dcal



__tms9918_set_tables:
    ;hl = address table
    ;a = screenmode
    ld      (__tms9918_screen_mode),a

    ; Call the gencon hook to setup print/cls etc functions
    push    hl
    ld      hl,(__tms9918_gencon_hook)
    call    l_dcal

    ld      hl,(__tms9918_graphics_hook)
    ld      a,(__tms9918_screen_mode)
    call    l_dcal
    pop     hl

    ; Now copy other info about the mode
    ld      e,(hl)      ;consolew
    inc     hl
    ld      d,(hl)      ;consoleh
    inc     hl
    ld      (__console_w),de
    ld      e,(hl)      ;gfxw
    inc     hl
    ld      d,(hl)      ;gfxh
    inc     hl
    ld      (__tms9918_gfxw),de
    ;hl = &sprites_enabled
    inc     hl
    ld      a,(hl)
    inc     hl
    ld      (generic_console_caps),a
    

    ld      e,0             ;Start from register 0
    ld      a,(hl)          ;register 0
    inc     hl
IF FORm5
    set     0,a             ;EXT Video has to always be on
ENDIF
    call    VDPreg_Write
    ld      a,(hl)          ;register 1
    inc     hl
IF FORadam
    res     5,a             ;No interrupts on an adam for CP/M breaks
ENDIF
    call    VDPreg_Write

    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_pattern_name),bc
    ld      a,(hl)              ;r2 value
    inc     hl
    call    VDPreg_Write        ;Register 2 - pattern name
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_colour_table),bc
    ld      a,(hl)              ;r3 value
    inc     hl
    call    VDPreg_Write        ;Register 3 - colour table
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_pattern_generator),bc
    ld      a,(hl)              ;r4 value
    inc     hl
    call    VDPreg_Write        ;Register 4 - pattern generator
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_sprite_attribute),bc
    ld      a,b
    rl      c
    rla
    and     @01111111
    call    VDPreg_Write        ;Register 5 - sprite attribute
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_sprite_generator),bc
    ld      a,b
    srl     a
    srl     a
    srl     a
    and     @00011111           ;Ignoring bit 16
    call    VDPreg_Write        ;Register 6 - sprite generator

    ;; And any extra registers afterwards
reg_loop:
    ld      e,(hl)
    inc     e
    ret     z
    dec     e
    inc     hl
    ld      a,(hl)
    inc     hl
    call    VDPreg_Write
    jr      reg_loop


