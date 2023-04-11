
    SECTION bss_video_vdp

    PUBLIC  __tms9918_screen_mode
    PUBLIC  __tms9918_attribute
    PUBLIC  __tms9918_border
    PUBLIC  RG0SAV          ;keeping track of VDP register values
    PUBLIC  RG1SAV
    PUBLIC  RG2SAV
    PUBLIC  RG3SAV
    PUBLIC  RG4SAV
    PUBLIC  RG5SAV
    PUBLIC  RG6SAV
    PUBLIC  RG7SAV


    PUBLIC  __tms9918_pattern_name
    PUBLIC  __tms9918_pattern_generator
    PUBLIC  __tms9918_colour_table
    PUBLIC  __tms9918_sprite_generator
    PUBLIC  __tms9918_sprite_attribute
    PUBLIC  __tms9918_gfxw
    PUBLIC  __tms9918_gfxh
    PUBLIC  __tms9918_gencon_hook
    PUBLIC  __tms9918_graphics_hook

    EXTERN  l_ret

    INCLUDE "video/tms9918/vdp.inc"
    
RG0SAV:         defb    0       ;keeping track of VDP register values
RG1SAV:         defb    0
RG2SAV:         defb    0
RG3SAV:         defb    0
RG4SAV:         defb    0
RG5SAV:         defb    0
RG6SAV:         defb    0
RG7SAV:         defb    0
IFDEF V9938
RG8SAV:
                ; We need to store registers 8->23
                defs    16
ENDIF


__tms9918_screen_mode:	        defb    0
; Addresses of the various VDP tables
__tms9918_pattern_name:         defw    0
__tms9918_pattern_generator:    defw    0
__tms9918_colour_table:         defw    0
__tms9918_sprite_generator:     defw    0
__tms9918_sprite_attribute:     defw    0


__tms9918_gfxw:     defb    0
__tms9918_gfxh:     defb    0

    SECTION data_video_vdp

__tms9918_attribute:
    defb	$f1	;white on black
IFDEF V9938
    PUBLIC  __tms9918_2bpp_attr
    PUBLIC  __tms9918_8bpp_attr

__tms9918_8bpp_attr:
    defb    $ff, $00        ;white ink, black paper

__tms9918_2bpp_attr:
    defb    @11000000, @00000000        ;ink = pen3, paper = pen0
ENDIF
__tms9918_border:       defb	$01	;black border
__tms9918_gencon_hook:  defw    l_ret       ;Hook for setting the mode for gencon as necessary
__tms9918_graphics_hook:defw    l_ret     ;Hook for setting the mode for graphics as necessary


