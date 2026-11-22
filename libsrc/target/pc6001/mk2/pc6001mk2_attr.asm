; PC-6001mkII 320x200 console and graphics (mode MC6847_MODE_MK2 = 3 of
; classic/video/mc6847): two bit planes, plane 0 at the screen's base (the crt's
; __pc6001mk2_vram: $C000 for the disc, $8000 for a cartridge) and plane 1 $2000
; on, 40 bytes a pixel row, the leftmost pixel of a byte its bit 7; a pixel's
; pen is its plane 0 bit + 2 * its plane 1 bit, and the four pens are the
; colours of the set $C0 chooses (the default set 4 is green, yellow, blue, red:
; -pragma-define:CRT_PC6001MK2_COLOURSET=n).  The console is 40x25 cells of 8x8
; pixels, a cell its glyph in the ink pen over the paper pen.
; In pc6001mk2.lib, linked ahead of pc6001_clib by -subtype=mk2disc, so these
; replace the do-nothing stubs the PC-6001 has.

    SECTION     code_driver
    PUBLIC      __pc6001mk2_set_attribute
    PUBLIC      __pc6001mk2_set_ink
    PUBLIC      __pc6001mk2_set_paper
    PUBLIC      __pc6001mk2_plotc
    PUBLIC      __pc6001mk2_console_pointxy
    PUBLIC      __pc6001mk2_ink
    PUBLIC      __pc6001mk2_paper

; The console's colours (0 to 15 as the other targets have them: black, blue,
; green, cyan, red, magenta, brown, light grey, then the bright ones) on the
; four pens of the colour set 4: 0 green, 1 yellow, 2 blue, 3 red.  Dark colours
; go to blue (the paper), greens and cyans to green, reds and magentas to red,
; the light ones to yellow.
map_colour:
    and         15
    ld          e, a
    ld          d, 0
    ld          hl, colour_pens
    add         hl, de
    ld          a, (hl)
    ret

colour_pens:
    ; black, blue, green, cyan, red, magenta, brown, light grey
    defb        2, 2, 0, 0, 3, 3, 1, 1
    ; dark grey, light blue, light green, light cyan, light red, light magenta,
    ; yellow, white
    defb        2, 2, 0, 0, 3, 3, 1, 1

; The flags (inverse) are applied when a character is printed
; (generic_console_flags): nothing to do here
__pc6001mk2_set_attribute:
    ret

; a = the colour
__pc6001mk2_set_ink:
    push        de
    push        hl
    call        map_colour
    ld          (__pc6001mk2_ink), a
    pop         hl
    pop         de
    ret

__pc6001mk2_set_paper:
    push        de
    push        hl
    call        map_colour
    ld          (__pc6001mk2_paper), a
    pop         hl
    pop         de
    ret

; (graphics made of characters: the 2x2 pieces of the other consoles are not
; here)
__pc6001mk2_plotc:
    ret

__pc6001mk2_console_pointxy:
    ld          a, 0
    scf
    ret

    SECTION     data_clib
__pc6001mk2_ink:
    defb        1                       ; yellow
__pc6001mk2_paper:
    defb        2                       ; on blue
