

// Port definitions for the ZX Spectrum



// ULAPlus Register port
//
// See https://zxdesign.itch.io/ulaplus for more details
// See https://sinclair.wiki.zxnet.co.uk/wiki/ULAplus for more details
//
// Bits 0-5: Select the register sub-group
// Bits 6-7: Select the register group. Two groups are currently available:
//
//     00 - palette group
//
//          When this group is selected, the sub-group determines the
//          entry in the palette table (0-63).
//
//     01 - mode group
//
//          The sub-group is (optionally) used to mirror the video functionality of Timex port #FF as follows:
//
//          Bits 0-2: Screen mode. 000=screen 0, 001=screen 1, 010=hi-colour, 110=hi-res (bank 5)
//                                 100=screen 0, 101=screen 1, 011=hi-colour, 111=hi-res (bank 7)
//          Bits 3-5: Sets the screen colour in hi-res mode.
//              000 - Black on White     100 - Green on Magenta
//              001 - Blue on Yellow     101 - Cyan on Red
//              010 - Red on Cyan        110 - Yellow on Blue
//              011 - Magenta on Green   111 - White on Black
#define __IO_ULAP_REGISTER  0xbf3b

// ULAPlus Data port
// When the palette group is selected, the byte written will describe the color.
//
// When the mode group is selected, the byte output will be interpreted as follows:
//
// Bit 0: ULAplus palette on (1) / off (0)
//    1: (optional) grayscale: on (1) / off (0) (same as turing the color off on the television)
//
// Implementations that support the Timex video modes use the #FF register as the primary means to set the video mode, as per the 
// Timex machines. It is left to the individual implementations to determine if reading the port returns the previous write or the 
// floating bus.
//
// GRB colour space the palette entry is interpreted as follows:
//
// Bits 0-1: Blue intensity.
// Bits 2-4: Red intensity.
// Bits 5-7: Green intensity.

#define __IO_ULAP_DATA      0xff3b
