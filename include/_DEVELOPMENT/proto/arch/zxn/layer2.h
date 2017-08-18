include(__link__.m4)

#ifndef _LAYER2_H
#define _LAYER2_H

// COLOUR MACROS
// Generate Layer 2 colours from various RGB formats

#define LAYER2_COLOR_RGB332(C)  (C)
#define LAYER2_COLOR_RGB333(C)  ((C)>>1)
#define LAYER2_COLOR_RGB888(C)  ((((C)&0xe00000)>>16)+(((C)&0xe000)>>11)+(((C)&0xc0)>>6))

#define LAYER2_COLOR_RGB332_COMP(R,G,B) ((((R)&0x7)<<5)+(((G)&0x7)<<2)+((B)&0x3))
#define LAYER2_COLOR_RGB333_COMP(R,G,B) ((((R)&0x7)<<5)+(((G)&0x7)<<2)+(((B)&0x6)>>1))
#define LAYER2_COLOR_RGB888_COMP(R,G,B) (((R)&0xe0)+(((G)&0xe0)>>3)+(((B)&0xc0)>>6))

// ULA+ Colour <-> Layer 2 Colour

#ifndef LAYER2_COLOR_FROM_LAYER2
#define ULAP_COLOR_FROM_LAYER2(C)  ((((C)&0xe0)>>3)+(((C)&0x1c)<<3)+((C)&0x3))
#endif

#ifndef LAYER2_COLOR_FROM_ULAP
#define LAYER2_COLOR_FROM_ULAP(C)  ULAP_COLOR_FROM_LAYER2(C)
#endif

// SELECTION OF PREDEFINED COLOURS

// Monochrome
// http://unwind.se/bgr233/

#define LAYER2_COLOR_MONO_BLACK         __LAYER2_COLOR_MONO_BLACK
#define LAYER2_COLOR_MONO_GREY_0        __LAYER2_COLOR_MONO_GREY_0
#define LAYER2_COLOR_MONO_GREY_1        __LAYER2_COLOR_MONO_GREY_1
#define LAYER2_COLOR_MONO_GREY_2        __LAYER2_COLOR_MONO_GREY_2
#define LAYER2_COLOR_MONO_GREY_3        __LAYER2_COLOR_MONO_GREY_3
#define LAYER2_COLOR_MONO_WHITE         __LAYER2_COLOR_MONO_WHITE

// Amber Screen
// https://sites.google.com/site/ulaplus/

#define LAYER2_COLOR_AMBER_0            __LAYER2_COLOR_AMBER_0
#define LAYER2_COLOR_AMBER_1            __LAYER2_COLOR_AMBER_1
#define LAYER2_COLOR_AMBER_2            __LAYER2_COLOR_AMBER_2
#define LAYER2_COLOR_AMBER_3            __LAYER2_COLOR_AMBER_3
#define LAYER2_COLOR_AMBER_4            __LAYER2_COLOR_AMBER_4
#define LAYER2_COLOR_AMBER_5            __LAYER2_COLOR_AMBER_5
#define LAYER2_COLOR_AMBER_6            __LAYER2_COLOR_AMBER_6
#define LAYER2_COLOR_AMBER_7            __LAYER2_COLOR_AMBER_7

// Green Screen
// https://sites.google.com/site/ulaplus/

#define LAYER2_COLOR_GREEN_0            __LAYER2_COLOR_GREEN_0
#define LAYER2_COLOR_GREEN_1            __LAYER2_COLOR_GREEN_1
#define LAYER2_COLOR_GREEN_2            __LAYER2_COLOR_GREEN_2
#define LAYER2_COLOR_GREEN_3            __LAYER2_COLOR_GREEN_3
#define LAYER2_COLOR_GREEN_4            __LAYER2_COLOR_GREEN_4
#define LAYER2_COLOR_GREEN_5            __LAYER2_COLOR_GREEN_5
#define LAYER2_COLOR_GREEN_6            __LAYER2_COLOR_GREEN_6
#define LAYER2_COLOR_GREEN_7            __LAYER2_COLOR_GREEN_7

// Rainbow

#define LAYER2_COLOR_RB_RED             __LAYER2_COLOR_RB_RED
#define LAYER2_COLOR_RB_ORANGE          __LAYER2_COLOR_RB_ORANGE
#define LAYER2_COLOR_RB_YELLOW          __LAYER2_COLOR_RB_YELLOW
#define LAYER2_COLOR_RB_GREEN           __LAYER2_COLOR_RB_GREEN
#define LAYER2_COLOR_RB_BLUE            __LAYER2_COLOR_RB_BLUE
#define LAYER2_COLOR_RB_VIOLET          __LAYER2_COLOR_RB_VIOLET
#define LAYER2_COLOR_RB_INDIGO          __LAYER2_COLOR_RB_INDIGO

// Spectrum
// https://sites.google.com/site/ulaplus/

#define LAYER2_COLOR_ZX_BLACK           __LAYER2_COLOR_ZX_BLACK
#define LAYER2_COLOR_ZX_BLUE            __LAYER2_COLOR_ZX_BLUE
#define LAYER2_COLOR_ZX_RED             __LAYER2_COLOR_ZX_RED
#define LAYER2_COLOR_ZX_MAGENTA         __LAYER2_COLOR_ZX_MAGENTA
#define LAYER2_COLOR_ZX_GREEN           __LAYER2_COLOR_ZX_GREEN
#define LAYER2_COLOR_ZX_CYAN            __LAYER2_COLOR_ZX_CYAN
#define LAYER2_COLOR_ZX_YELLOW          __LAYER2_COLOR_ZX_YELLOW
#define LAYER2_COLOR_ZX_WHITE           __LAYER2_COLOR_ZX_WHITE
#define LAYER2_COLOR_ZX_BRIGHT_BLACK    __LAYER2_COLOR_ZX_BRIGHT_BLACK
#define LAYER2_COLOR_ZX_BRIGHT_BLUE     __LAYER2_COLOR_ZX_BRIGHT_BLUE
#define LAYER2_COLOR_ZX_BRIGHT_RED      __LAYER2_COLOR_ZX_BRIGHT_RED
#define LAYER2_COLOR_ZX_BRIGHT_MAGENTA  __LAYER2_COLOR_ZX_BRIGHT_MAGENTA
#define LAYER2_COLOR_ZX_BRIGHT_GREEN    __LAYER2_COLOR_ZX_BRIGHT_GREEN
#define LAYER2_COLOR_ZX_BRIGHT_CYAN     __LAYER2_COLOR_ZX_BRIGHT_CYAN
#define LAYER2_COLOR_ZX_BRIGHT_YELLOW   __LAYER2_COLOR_ZX_BRIGHT_YELLOW
#define LAYER2_COLOR_ZX_BRIGHT_WHITE    __LAYER2_COLOR_ZX_BRIGHT_WHITE

// ZX Next Restricted Palette by Retro
// https://www.specnext.com/forum/viewtopic.php?f=7&t=286#p981

#define LAYER2_COLOR_ZXNR_NAVY             __LAYER2_COLOR_ZXNR_NAVY
#define LAYER2_COLOR_ZXNR_MAROON           __LAYER2_COLOR_ZXNR_MAROON
#define LAYER2_COLOR_ZXNR_INDIGO           __LAYER2_COLOR_ZXNR_INDIGO
#define LAYER2_COLOR_ZXNR_RACING_GREEN     __LAYER2_COLOR_ZXNR_RACING_GREEN
#define LAYER2_COLOR_ZXNR_SHERPA_BLUE      __LAYER2_COLOR_ZXNR_SHERPA_BLUE
#define LAYER2_COLOR_ZXNR_OLIVE            __LAYER2_COLOR_ZXNR_OLIVE
#define LAYER2_COLOR_ZXNR_BLACK            __LAYER2_COLOR_ZXNR_BLACK
#define LAYER2_COLOR_ZXNR_MIDNIGHT_BLUE    __LAYER2_COLOR_ZXNR_MIDNIGHT_BLUE
#define LAYER2_COLOR_ZXNR_DARK_RED         __LAYER2_COLOR_ZXNR_DARK_RED
#define LAYER2_COLOR_ZXNR_DARK_VIOLET      __LAYER2_COLOR_ZXNR_DARK_VIOLET
#define LAYER2_COLOR_ZXNR_ISLAMIC_GREEN    __LAYER2_COLOR_ZXNR_ISLAMIC_GREEN
#define LAYER2_COLOR_ZXNR_BONDI_BLUE       __LAYER2_COLOR_ZXNR_BONDI_BLUE
#define LAYER2_COLOR_ZXNR_BRIGHT_OLIVE     __LAYER2_COLOR_ZXNR_BRIGHT_OLIVE
#define LAYER2_COLOR_ZXNR_GUNPOWDER_GRAY   __LAYER2_COLOR_ZXNR_GUNPOWDER_GRAY
#define LAYER2_COLOR_ZXNR_BLUE             __LAYER2_COLOR_ZXNR_BLUE
#define LAYER2_COLOR_ZXNR_RED              __LAYER2_COLOR_ZXNR_RED
#define LAYER2_COLOR_ZXNR_MAGENTA          __LAYER2_COLOR_ZXNR_MAGENTA
#define LAYER2_COLOR_ZXNR_GREEN            __LAYER2_COLOR_ZXNR_GREEN
#define LAYER2_COLOR_ZXNR_AQUA             __LAYER2_COLOR_ZXNR_AQUA
#define LAYER2_COLOR_ZXNR_YELLOW           __LAYER2_COLOR_ZXNR_YELLOW
#define LAYER2_COLOR_ZXNR_MIST_GRAY        __LAYER2_COLOR_ZXNR_MIST_GRAY
#define LAYER2_COLOR_ZXNR_SLATE_BLUE       __LAYER2_COLOR_ZXNR_SLATE_BLUE
#define LAYER2_COLOR_ZXNR_BITTERSWEET      __LAYER2_COLOR_ZXNR_BITTERSWEET
#define LAYER2_COLOR_ZXNR_ULTRA_PINK       __LAYER2_COLOR_ZXNR_ULTRA_PINK
#define LAYER2_COLOR_ZXNR_SCREAMING_GREEN  __LAYER2_COLOR_ZXNR_SCREAMING_GREEN
#define LAYER2_COLOR_ZXNR_ELECTRIC_BLUE    __LAYER2_COLOR_ZXNR_ELECTRIC_BLUE
#define LAYER2_COLOR_ZXNR_LASER_LEMON      __LAYER2_COLOR_ZXNR_LASER_LEMON
#define LAYER2_COLOR_ZXNR_WHITE            __LAYER2_COLOR_ZXNR_WHITE
#define LAYER2_COLOR_ZXNR_LAVENDER_BLUE    __LAYER2_COLOR_ZXNR_LAVENDER_BLUE
#define LAYER2_COLOR_ZXNR_MELON            __LAYER2_COLOR_ZXNR_MELON
#define LAYER2_COLOR_ZXNR_LAVENDER_ROSE    __LAYER2_COLOR_ZXNR_LAVENDER_ROSE
#define LAYER2_COLOR_ZXNR_MINT_GREEN       __LAYER2_COLOR_ZXNR_MINT_GREEN
#define LAYER2_COLOR_ZXNR_COLUMBIA_BLUE    __LAYER2_COLOR_ZXNR_COLUMBIA_BLUE
#define LAYER2_COLOR_ZXNR_CANARY           __LAYER2_COLOR_ZXNR_CANARY
#define LAYER2_COLOR_ZXNR_BRIGHT_MAGENTA   __LAYER2_COLOR_ZXNR_BRIGHT_MAGENTA

// C64
// https://sites.google.com/site/ulaplus/

#define LAYER2_COLOR_C64_BLACK          __LAYER2_COLOR_C64_BLACK
#define LAYER2_COLOR_C64_WHITE          __LAYER2_COLOR_C64_WHITE
#define LAYER2_COLOR_C64_RED            __LAYER2_COLOR_C64_RED
#define LAYER2_COLOR_C64_CYAN           __LAYER2_COLOR_C64_CYAN
#define LAYER2_COLOR_C64_VIOLET         __LAYER2_COLOR_C64_VIOLET
#define LAYER2_COLOR_C64_GREEN          __LAYER2_COLOR_C64_GREEN
#define LAYER2_COLOR_C64_BLUE           __LAYER2_COLOR_C64_BLUE
#define LAYER2_COLOR_C64_YELLOW         __LAYER2_COLOR_C64_YELLOW
#define LAYER2_COLOR_C64_ORANGE         __LAYER2_COLOR_C64_ORANGE
#define LAYER2_COLOR_C64_BROWN          __LAYER2_COLOR_C64_BROWN
#define LAYER2_COLOR_C64_LIGHTRED       __LAYER2_COLOR_C64_LIGHTRED
#define LAYER2_COLOR_C64_GREY1          __LAYER2_COLOR_C64_GREY1
#define LAYER2_COLOR_C64_GREY2          __LAYER2_COLOR_C64_GREY2
#define LAYER2_COLOR_C64_LIGHTGREEN     __LAYER2_COLOR_C64_LIGHTGREEN
#define LAYER2_COLOR_C64_LIGHTBLUE      __LAYER2_COLOR_C64_LIGHTBLUE
#define LAYER2_COLOR_C64_GREY3          __LAYER2_COLOR_C64_GREY3

// Games 1
// https://www.msx.org/wiki/Setting_up_a_palette

#define LAYER2_COLOR_G1_BLACK           __LAYER2_COLOR_G1_BLACK
#define LAYER2_COLOR_G1_GREY            __LAYER2_COLOR_G1_GREY
#define LAYER2_COLOR_G1_SILVER          __LAYER2_COLOR_G1_SILVER
#define LAYER2_COLOR_G1_DARK_TEAL       __LAYER2_COLOR_G1_DARK_TEAL
#define LAYER2_COLOR_G1_GREEN           __LAYER2_COLOR_G1_GREEN
#define LAYER2_COLOR_G1_GREENYELLOW     __LAYER2_COLOR_G1_GREENYELLOW
#define LAYER2_COLOR_G1_MAROON          __LAYER2_COLOR_G1_MAROON
#define LAYER2_COLOR_G1_SIENNA          __LAYER2_COLOR_G1_SIENNA
#define LAYER2_COLOR_G1_SANDYBROWN      __LAYER2_COLOR_G1_SANDYBROWN
#define LAYER2_COLOR_G1_KHAKI           __LAYER2_COLOR_G1_KHAKI
#define LAYER2_COLOR_G1_WHITE           __LAYER2_COLOR_G1_WHITE
#define LAYER2_COLOR_G1_SKYBLUE         __LAYER2_COLOR_G1_SKYBLUE
#define LAYER2_COLOR_G1_SLATEBLUE       __LAYER2_COLOR_G1_SLATEBLUE
#define LAYER2_COLOR_G1_BLUE            __LAYER2_COLOR_G1_BLUE

// Standard
// https://github.com/Gargy007/eGUI/blob/master/D4D/common_files/d4d_scheme.h

#define LAYER2_COLOR_STD_DARK_BLUE      __LAYER2_COLOR_STD_DARK_BLUE
#define LAYER2_COLOR_STD_BRIGHT_BLUE    __LAYER2_COLOR_STD_BRIGHT_BLUE
#define LAYER2_COLOR_STD_BLUE           __LAYER2_COLOR_STD_BLUE
#define LAYER2_COLOR_STD_CYAN           __LAYER2_COLOR_STD_CYAN
#define LAYER2_COLOR_STD_BRIGHT_YELLOW  __LAYER2_COLOR_STD_BRIGHT_YELLOW
#define LAYER2_COLOR_STD_YELLOW         __LAYER2_COLOR_STD_YELLOW
#define LAYER2_COLOR_STD_ORANGE         __LAYER2_COLOR_STD_ORANGE
#define LAYER2_COLOR_STD_BRIGHT_RED     __LAYER2_COLOR_STD_BRIGHT_RED
#define LAYER2_COLOR_STD_RED            __LAYER2_COLOR_STD_RED
#define LAYER2_COLOR_STD_DARK_RED       __LAYER2_COLOR_STD_DARK_RED
#define LAYER2_COLOR_STD_MAGENTA        __LAYER2_COLOR_STD_MAGENTA
#define LAYER2_COLOR_STD_BRIGHT_GREEN   __LAYER2_COLOR_STD_BRIGHT_GREEN
#define LAYER2_COLOR_STD_GREEN          __LAYER2_COLOR_STD_GREEN
#define LAYER2_COLOR_STD_DARK_GREEN     __LAYER2_COLOR_STD_DARK_GREEN
#define LAYER2_COLOR_STD_BRIGHT_GREY    __LAYER2_COLOR_STD_BRIGHT_GREY
#define LAYER2_COLOR_STD_LIGHT_GREY     __LAYER2_COLOR_STD_LIGHT_GREY
#define LAYER2_COLOR_STD_GREY           __LAYER2_COLOR_STD_GREY
#define LAYER2_COLOR_STD_WHITE          __LAYER2_COLOR_STD_WHITE
#define LAYER2_COLOR_STD_BLACK          __LAYER2_COLOR_STD_BLACK

// HTML
// Thanks to GreW at WOS

#define LAYER2_COLOR_HTML_Black                 __LAYER2_COLOR_HTML_Black
#define LAYER2_COLOR_HTML_Navy                  __LAYER2_COLOR_HTML_Navy
#define LAYER2_COLOR_HTML_DarkBlue              __LAYER2_COLOR_HTML_DarkBlue
#define LAYER2_COLOR_HTML_MediumBlue            __LAYER2_COLOR_HTML_MediumBlue
#define LAYER2_COLOR_HTML_Blue                  __LAYER2_COLOR_HTML_Blue
#define LAYER2_COLOR_HTML_DarkGreen             __LAYER2_COLOR_HTML_DarkGreen
#define LAYER2_COLOR_HTML_Green                 __LAYER2_COLOR_HTML_Green
#define LAYER2_COLOR_HTML_Teal                  __LAYER2_COLOR_HTML_Teal
#define LAYER2_COLOR_HTML_DarkCyan              __LAYER2_COLOR_HTML_DarkCyan
#define LAYER2_COLOR_HTML_DeepSkyBlue           __LAYER2_COLOR_HTML_DeepSkyBlue
#define LAYER2_COLOR_HTML_DarkTurquoise         __LAYER2_COLOR_HTML_DarkTurquoise
#define LAYER2_COLOR_HTML_MediumSpringGreen     __LAYER2_COLOR_HTML_MediumSpringGreen
#define LAYER2_COLOR_HTML_Lime                  __LAYER2_COLOR_HTML_Lime
#define LAYER2_COLOR_HTML_SpringGreen           __LAYER2_COLOR_HTML_SpringGreen
#define LAYER2_COLOR_HTML_Aqua                  __LAYER2_COLOR_HTML_Aqua
#define LAYER2_COLOR_HTML_Cyan                  __LAYER2_COLOR_HTML_Cyan
#define LAYER2_COLOR_HTML_MidnightBlue          __LAYER2_COLOR_HTML_MidnightBlue
#define LAYER2_COLOR_HTML_DodgerBlue            __LAYER2_COLOR_HTML_DodgerBlue
#define LAYER2_COLOR_HTML_LightSeaGreen         __LAYER2_COLOR_HTML_LightSeaGreen
#define LAYER2_COLOR_HTML_ForestGreen           __LAYER2_COLOR_HTML_ForestGreen
#define LAYER2_COLOR_HTML_SeaGreen              __LAYER2_COLOR_HTML_SeaGreen
#define LAYER2_COLOR_HTML_DarkSlateGray         __LAYER2_COLOR_HTML_DarkSlateGray
#define LAYER2_COLOR_HTML_DarkSlateGrey         __LAYER2_COLOR_HTML_DarkSlateGrey
#define LAYER2_COLOR_HTML_LimeGreen             __LAYER2_COLOR_HTML_LimeGreen
#define LAYER2_COLOR_HTML_MediumSeaGreen        __LAYER2_COLOR_HTML_MediumSeaGreen
#define LAYER2_COLOR_HTML_Turquoise             __LAYER2_COLOR_HTML_Turquoise
#define LAYER2_COLOR_HTML_RoyalBlue             __LAYER2_COLOR_HTML_RoyalBlue
#define LAYER2_COLOR_HTML_SteelBlue             __LAYER2_COLOR_HTML_SteelBlue
#define LAYER2_COLOR_HTML_DarkSlateBlue         __LAYER2_COLOR_HTML_DarkSlateBlue
#define LAYER2_COLOR_HTML_MediumTurquoise       __LAYER2_COLOR_HTML_MediumTurquoise
#define LAYER2_COLOR_HTML_Indigo                __LAYER2_COLOR_HTML_Indigo
#define LAYER2_COLOR_HTML_DarkOliveGreen        __LAYER2_COLOR_HTML_DarkOliveGreen
#define LAYER2_COLOR_HTML_CadetBlue             __LAYER2_COLOR_HTML_CadetBlue
#define LAYER2_COLOR_HTML_CornflowerBlue        __LAYER2_COLOR_HTML_CornflowerBlue
#define LAYER2_COLOR_HTML_RebeccaPurple         __LAYER2_COLOR_HTML_RebeccaPurple
#define LAYER2_COLOR_HTML_MediumAquaMarine      __LAYER2_COLOR_HTML_MediumAquaMarine
#define LAYER2_COLOR_HTML_DimGray               __LAYER2_COLOR_HTML_DimGray
#define LAYER2_COLOR_HTML_DimGrey               __LAYER2_COLOR_HTML_DimGrey
#define LAYER2_COLOR_HTML_SlateBlue             __LAYER2_COLOR_HTML_SlateBlue
#define LAYER2_COLOR_HTML_OliveDrab             __LAYER2_COLOR_HTML_OliveDrab
#define LAYER2_COLOR_HTML_SlateGray             __LAYER2_COLOR_HTML_SlateGray
#define LAYER2_COLOR_HTML_SlateGrey             __LAYER2_COLOR_HTML_SlateGrey
#define LAYER2_COLOR_HTML_LightSlateGray        __LAYER2_COLOR_HTML_LightSlateGray
#define LAYER2_COLOR_HTML_LightSlateGrey        __LAYER2_COLOR_HTML_LightSlateGrey
#define LAYER2_COLOR_HTML_MediumSlateBlue       __LAYER2_COLOR_HTML_MediumSlateBlue
#define LAYER2_COLOR_HTML_LawnGreen             __LAYER2_COLOR_HTML_LawnGreen
#define LAYER2_COLOR_HTML_Chartreuse            __LAYER2_COLOR_HTML_Chartreuse
#define LAYER2_COLOR_HTML_Aquamarine            __LAYER2_COLOR_HTML_Aquamarine
#define LAYER2_COLOR_HTML_Maroon                __LAYER2_COLOR_HTML_Maroon
#define LAYER2_COLOR_HTML_Purple                __LAYER2_COLOR_HTML_Purple
#define LAYER2_COLOR_HTML_Olive                 __LAYER2_COLOR_HTML_Olive
#define LAYER2_COLOR_HTML_Gray                  __LAYER2_COLOR_HTML_Gray
#define LAYER2_COLOR_HTML_Grey                  __LAYER2_COLOR_HTML_Grey
#define LAYER2_COLOR_HTML_SkyBlue               __LAYER2_COLOR_HTML_SkyBlue
#define LAYER2_COLOR_HTML_LightSkyBlue          __LAYER2_COLOR_HTML_LightSkyBlue
#define LAYER2_COLOR_HTML_BlueViolet            __LAYER2_COLOR_HTML_BlueViolet
#define LAYER2_COLOR_HTML_DarkRed               __LAYER2_COLOR_HTML_DarkRed
#define LAYER2_COLOR_HTML_DarkMagenta           __LAYER2_COLOR_HTML_DarkMagenta
#define LAYER2_COLOR_HTML_SaddleBrown           __LAYER2_COLOR_HTML_SaddleBrown
#define LAYER2_COLOR_HTML_DarkSeaGreen          __LAYER2_COLOR_HTML_DarkSeaGreen
#define LAYER2_COLOR_HTML_LightGreen            __LAYER2_COLOR_HTML_LightGreen
#define LAYER2_COLOR_HTML_MediumPurple          __LAYER2_COLOR_HTML_MediumPurple
#define LAYER2_COLOR_HTML_DarkViolet            __LAYER2_COLOR_HTML_DarkViolet
#define LAYER2_COLOR_HTML_PaleGreen             __LAYER2_COLOR_HTML_PaleGreen
#define LAYER2_COLOR_HTML_DarkOrchid            __LAYER2_COLOR_HTML_DarkOrchid
#define LAYER2_COLOR_HTML_YellowGreen           __LAYER2_COLOR_HTML_YellowGreen
#define LAYER2_COLOR_HTML_Sienna                __LAYER2_COLOR_HTML_Sienna
#define LAYER2_COLOR_HTML_Brown                 __LAYER2_COLOR_HTML_Brown
#define LAYER2_COLOR_HTML_DarkGray              __LAYER2_COLOR_HTML_DarkGray
#define LAYER2_COLOR_HTML_DarkGrey              __LAYER2_COLOR_HTML_DarkGrey
#define LAYER2_COLOR_HTML_LightBlue             __LAYER2_COLOR_HTML_LightBlue
#define LAYER2_COLOR_HTML_GreenYellow           __LAYER2_COLOR_HTML_GreenYellow
#define LAYER2_COLOR_HTML_PaleTurquoise         __LAYER2_COLOR_HTML_PaleTurquoise
#define LAYER2_COLOR_HTML_LightSteelBlue        __LAYER2_COLOR_HTML_LightSteelBlue
#define LAYER2_COLOR_HTML_PowderBlue            __LAYER2_COLOR_HTML_PowderBlue
#define LAYER2_COLOR_HTML_FireBrick             __LAYER2_COLOR_HTML_FireBrick
#define LAYER2_COLOR_HTML_DarkGoldenRod         __LAYER2_COLOR_HTML_DarkGoldenRod
#define LAYER2_COLOR_HTML_MediumOrchid          __LAYER2_COLOR_HTML_MediumOrchid
#define LAYER2_COLOR_HTML_RosyBrown             __LAYER2_COLOR_HTML_RosyBrown
#define LAYER2_COLOR_HTML_DarkKhaki             __LAYER2_COLOR_HTML_DarkKhaki
#define LAYER2_COLOR_HTML_Silver                __LAYER2_COLOR_HTML_Silver
#define LAYER2_COLOR_HTML_MediumVioletRed       __LAYER2_COLOR_HTML_MediumVioletRed
#define LAYER2_COLOR_HTML_IndianRed             __LAYER2_COLOR_HTML_IndianRed
#define LAYER2_COLOR_HTML_Peru                  __LAYER2_COLOR_HTML_Peru
#define LAYER2_COLOR_HTML_Chocolate             __LAYER2_COLOR_HTML_Chocolate
#define LAYER2_COLOR_HTML_Tan                   __LAYER2_COLOR_HTML_Tan
#define LAYER2_COLOR_HTML_LightGray             __LAYER2_COLOR_HTML_LightGray
#define LAYER2_COLOR_HTML_LightGrey             __LAYER2_COLOR_HTML_LightGrey
#define LAYER2_COLOR_HTML_Thistle               __LAYER2_COLOR_HTML_Thistle
#define LAYER2_COLOR_HTML_Orchid                __LAYER2_COLOR_HTML_Orchid
#define LAYER2_COLOR_HTML_GoldenRod             __LAYER2_COLOR_HTML_GoldenRod
#define LAYER2_COLOR_HTML_PaleVioletRed         __LAYER2_COLOR_HTML_PaleVioletRed
#define LAYER2_COLOR_HTML_Crimson               __LAYER2_COLOR_HTML_Crimson
#define LAYER2_COLOR_HTML_Gainsboro             __LAYER2_COLOR_HTML_Gainsboro
#define LAYER2_COLOR_HTML_Plum                  __LAYER2_COLOR_HTML_Plum
#define LAYER2_COLOR_HTML_BurlyWood             __LAYER2_COLOR_HTML_BurlyWood
#define LAYER2_COLOR_HTML_LightCyan             __LAYER2_COLOR_HTML_LightCyan
#define LAYER2_COLOR_HTML_Lavender              __LAYER2_COLOR_HTML_Lavender
#define LAYER2_COLOR_HTML_DarkSalmon            __LAYER2_COLOR_HTML_DarkSalmon
#define LAYER2_COLOR_HTML_Violet                __LAYER2_COLOR_HTML_Violet
#define LAYER2_COLOR_HTML_PaleGoldenRod         __LAYER2_COLOR_HTML_PaleGoldenRod
#define LAYER2_COLOR_HTML_LightCoral            __LAYER2_COLOR_HTML_LightCoral
#define LAYER2_COLOR_HTML_Khaki                 __LAYER2_COLOR_HTML_Khaki
#define LAYER2_COLOR_HTML_AliceBlue             __LAYER2_COLOR_HTML_AliceBlue
#define LAYER2_COLOR_HTML_HoneyDew              __LAYER2_COLOR_HTML_HoneyDew
#define LAYER2_COLOR_HTML_Azure                 __LAYER2_COLOR_HTML_Azure
#define LAYER2_COLOR_HTML_SandyBrown            __LAYER2_COLOR_HTML_SandyBrown
#define LAYER2_COLOR_HTML_Wheat                 __LAYER2_COLOR_HTML_Wheat
#define LAYER2_COLOR_HTML_Beige                 __LAYER2_COLOR_HTML_Beige
#define LAYER2_COLOR_HTML_WhiteSmoke            __LAYER2_COLOR_HTML_WhiteSmoke
#define LAYER2_COLOR_HTML_MintCream             __LAYER2_COLOR_HTML_MintCream
#define LAYER2_COLOR_HTML_GhostWhite            __LAYER2_COLOR_HTML_GhostWhite
#define LAYER2_COLOR_HTML_Salmon                __LAYER2_COLOR_HTML_Salmon
#define LAYER2_COLOR_HTML_AntiqueWhite          __LAYER2_COLOR_HTML_AntiqueWhite
#define LAYER2_COLOR_HTML_Linen                 __LAYER2_COLOR_HTML_Linen
#define LAYER2_COLOR_HTML_LightGoldenRodYellow  __LAYER2_COLOR_HTML_LightGoldenRodYellow
#define LAYER2_COLOR_HTML_OldLace               __LAYER2_COLOR_HTML_OldLace
#define LAYER2_COLOR_HTML_Red                   __LAYER2_COLOR_HTML_Red
#define LAYER2_COLOR_HTML_Fuchsia               __LAYER2_COLOR_HTML_Fuchsia
#define LAYER2_COLOR_HTML_Magenta               __LAYER2_COLOR_HTML_Magenta
#define LAYER2_COLOR_HTML_DeepPink              __LAYER2_COLOR_HTML_DeepPink
#define LAYER2_COLOR_HTML_OrangeRed             __LAYER2_COLOR_HTML_OrangeRed
#define LAYER2_COLOR_HTML_Tomato                __LAYER2_COLOR_HTML_Tomato
#define LAYER2_COLOR_HTML_HotPink               __LAYER2_COLOR_HTML_HotPink
#define LAYER2_COLOR_HTML_Coral                 __LAYER2_COLOR_HTML_Coral
#define LAYER2_COLOR_HTML_DarkOrange            __LAYER2_COLOR_HTML_DarkOrange
#define LAYER2_COLOR_HTML_LightSalmon           __LAYER2_COLOR_HTML_LightSalmon
#define LAYER2_COLOR_HTML_Orange                __LAYER2_COLOR_HTML_Orange
#define LAYER2_COLOR_HTML_LightPink             __LAYER2_COLOR_HTML_LightPink
#define LAYER2_COLOR_HTML_Pink                  __LAYER2_COLOR_HTML_Pink
#define LAYER2_COLOR_HTML_Gold                  __LAYER2_COLOR_HTML_Gold
#define LAYER2_COLOR_HTML_PeachPuff             __LAYER2_COLOR_HTML_PeachPuff
#define LAYER2_COLOR_HTML_NavajoWhite           __LAYER2_COLOR_HTML_NavajoWhite
#define LAYER2_COLOR_HTML_Moccasin              __LAYER2_COLOR_HTML_Moccasin
#define LAYER2_COLOR_HTML_Bisque                __LAYER2_COLOR_HTML_Bisque
#define LAYER2_COLOR_HTML_MistyRose             __LAYER2_COLOR_HTML_MistyRose
#define LAYER2_COLOR_HTML_BlanchedAlmond        __LAYER2_COLOR_HTML_BlanchedAlmond
#define LAYER2_COLOR_HTML_PapayaWhip            __LAYER2_COLOR_HTML_PapayaWhip
#define LAYER2_COLOR_HTML_LavenderBlush         __LAYER2_COLOR_HTML_LavenderBlush
#define LAYER2_COLOR_HTML_SeaShell              __LAYER2_COLOR_HTML_SeaShell
#define LAYER2_COLOR_HTML_Cornsilk              __LAYER2_COLOR_HTML_Cornsilk
#define LAYER2_COLOR_HTML_LemonChiffon          __LAYER2_COLOR_HTML_LemonChiffon
#define LAYER2_COLOR_HTML_FloralWhite           __LAYER2_COLOR_HTML_FloralWhite
#define LAYER2_COLOR_HTML_Snow                  __LAYER2_COLOR_HTML_Snow
#define LAYER2_COLOR_HTML_Yellow                __LAYER2_COLOR_HTML_Yellow
#define LAYER2_COLOR_HTML_LightYellow           __LAYER2_COLOR_HTML_LightYellow
#define LAYER2_COLOR_HTML_Ivory                 __LAYER2_COLOR_HTML_Ivory
#define LAYER2_COLOR_HTML_White                 __LAYER2_COLOR_HTML_White

#endif
