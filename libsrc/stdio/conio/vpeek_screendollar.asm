
    SECTION code_clib
    PUBLIC  vpeek_screendollar

    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

; Match character in buffer on stack to the font
;
; Entry on stack: address of buffer, 8 bytes of buffer
vpeek_screendollar:
IF __CPU_GBZ80__
        INCLUDE "target/gb/def/gb_globals.def"
        ld      hl,generic_console_font32
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
        ; Gameboy fonts are in GBDK format. We're making the bold assumption that if
        ; we're assembled for GBZ80 then we are on the gameboy
        ld      a,(hl+) ;Font type
        inc     hl      ;Skips to the start of encoding table if present
        and     3
        ld      de,128
        cp      FONT_128ENCODING
        jr      z,add_offset
        ld      de,0
        cp      FONT_NOENCODING
        jr      z,add_offset
        ld      d,1
add_offset:
        add     hl,de               ;Now points to the font set
        pop     de                  ;The buffer on the stack
        ld      b,128               ;Gameboy fonts are 128 bytes (with graphics 0-31)
        call    screendollar_with_count
ELSE
        ld      hl,(generic_console_font32)
        pop     de              ;the buffer on the stack
        call    screendollar
ENDIF
        jr      nc,gotit
IF __CPU_GBZ80__
        ld      hl,generic_console_udg32
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
ELSE
        ld      hl,(generic_console_udg32)
ENDIF
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
IF __CPU_GBZ80__ | __CPU_INTEL__
        push    af
        pop     bc
ELSE
        ex      af,af           ; Save those flags
ENDIF
IF __CPU_GBZ80__
        add     sp,8
ELSE
        ld      hl,8            ; Dump our temporary buffer
        add     hl,sp
        ld      sp,hl
ENDIF
IF __CPU_GBZ80__ | __CPU_INTEL__
        push	bc
        pop	    af
ELSE
        ex      af,af           ; Flags and parameter back
ENDIF
        ret

