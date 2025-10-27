divert(-1)

###############################################################
# NEXTREG CONFIGURATION
# rebuild the library if changes are made
#

# TBBLUE I/O Port System for the Spectrum Next

define(`__IO_NEXTREG_REG', 0x243b)
define(`__IO_NEXTREG_DAT', 0x253b)

# NEXTREG REGISTERS

# (R) 0x00 (00) => Machine ID

define(`__REG_MACHINE_ID', 0)
define(`__RMI_DE1A', 1)
define(`__RMI_DE2A', 2)
define(`__RMI_FBLABS', 5)
define(`__RMI_VTRUCCO', 6)
define(`__RMI_WXEDA', 7)
define(`__RMI_EMULATORS', 8)
define(`__RMI_ZXNEXT', 10)      # ZX Spectrum Next
define(`__RMI_MULTICORE', 11)
define(`__RMI_ZXNEXT_AB', 250)  # ZX Spectrum Next Anti-brick

# (R) 0x01 (01) => Core Version 
#  bits 7-4 = Major version number
#  bits 3-0 = Minor version number
#  (see register 0x0E for sub minor version number)

define(`__REG_VERSION', 1)
define(`__RV_MAJOR', 0xf0)
define(`__RV_MINOR', 0x0f)

# (R/W) 0x02 (02) => Reset:
#  bits 7-3 = Reserved, must be 0
#  bit 2 = (R) Power-on reset (PoR)
#  bit 1 = (R/W) Reading 1 indicates a Hard-reset. If written 1 causes a Hard Reset.
#  bit 0 = (R/W) Reading 1 indicates a Soft-reset. If written 1 causes a Soft Reset.

define(`__REG_RESET', 2)
define(`__RR_POWER_ON_RESET', 0x04)
define(`__RR_HARD_RESET', 0x02)
define(`__RR_SOFT_RESET', 0x01)

# (W) 0x03 (03) => Set machine type, only in IPL or config mode:
#   A write in this register disables the IPL 
#   (0x0000-0x3FFF are mapped to the RAM instead of the internal ROM)
#   bit 7 = lock timing
#   bits 6-4 = Timing:
#      000 or 001 = ZX 48K
#      010 = ZX 128K
#      011 = ZX +2/+3e
#      100 = Pentagon 128K
#   bit 3 = Reserved, must be 0
#   bits 2-0 = Machine type:
#      000 = Config mode
#      001 = ZX 48K
#      010 = ZX 128K
#      011 = ZX +2/+3e
#      100 = Pentagon 128K

define(`__REG_MACHINE_TYPE', 3)
define(`__RMT_LOCK_TIMING', 0x80)
define(`__RMT_TIMING_48', 0x10)
define(`__RMT_TIMING_128', 0x20)
define(`__RMT_TIMING_P3E', 0x30)
define(`__RMT_TIMING_PENTAGON', 0x40)
define(`__RMT_CONFIG_MODE', 0x00)
define(`__RMT_48', 0x01)
define(`__RMT_128', 0x02)
define(`__RMT_P3E', 0x03)
define(`__RMT_PENTAGON', 0x04)

# (W) 0x04 (04) => Set page RAM, only in config mode (no IPL):
#   bits 7-6 = Reserved, must be 0
#   bits 5-0 = RAM page mapped in 0x0000-0x3FFF 
#   (64 x 16k pages = 1024K, Reset to 0 after a PoR or Hard-reset)

define(`__REG_RAM_PAGE', 4)
define(`__RRP_RAM_DIVMMC', 0x08)    # 0x00
define(`__RRP_ROM_DIVMMC', 0x04)    # 0x18
define(`__RRP_ROM_MF', 0x05)        # 0x19
define(`__RRP_ROM_SPECTRUM', 0x00)  # 0x1c

# (R/W) 0x05 (05) => Peripheral 1 setting:
#  bits 7-6 = joystick 1 mode (LSB)
#  bits 5-4 = joystick 2 mode (LSB)
#  bit 3 = joystick 1 mode (MSB)
#  bit 2 = 50/60 Hz mode (0 = 50Hz, 1 = 60Hz)(0 after a PoR or Hard-reset)
#  bit 1 = joystick 2 mode (MSB)
#  bit 0 = Enable Scandoubler (1 = enabled)(1 after a PoR or Hard-reset)
#      Joysticks modes:
#      000 = Sinclair 2 (67890)
#      001 = Kempston 1 (port 0x1F)
#      010 = Cursor (56780)
#      011 = Sinclair 1 (12345)
#      100 = Kempston 2 (port 0x37)
#      101 = MD 1 (3 or 6 button joystick port 0x1F)
#      110 = MD 2 (3 or 6 button joystick port 0x37)

define(`__REG_PERIPHERAL_1', 5)
define(`__RP1_JOY1_SINCLAIR', 0xc0)
define(`__RP1_JOY1_SINCLAIR_1', 0xc0)
define(`__RP1_JOY1_SINCLAIR_2', 0x00)
define(`__RP1_JOY1_KEMPSTON', 0x40)
define(`__RP1_JOY1_KEMPSTON_1', 0x40)
define(`__RP1_JOY1_KEMPSTON_2', 0x08)
define(`__RP1_JOY1_CURSOR', 0x80)
define(`__RP1_JOY1_MD_1', 0x48)
define(`__RP1_JOY1_MD_2', 0x88)
define(`__RP1_JOY2_SINCLAIR', 0x00)
define(`__RP1_JOY2_SINCLAIR_1', 0x30)
define(`__RP1_JOY2_SINCLAIR_2', 0x00)
define(`__RP1_JOY2_KEMPSTON', 0x02)
define(`__RP1_JOY2_KEMPSTON_1', 0x10)
define(`__RP1_JOY2_KEMPSTON_2', 0x02)
define(`__RP1_JOY2_CURSOR', 0x20)
define(`__RP1_JOY2_MD_1', 0x12)
define(`__RP1_JOY2_MD_2', 0x22)
define(`__RP1_RATE_50', 0x00)
define(`__RP1_RATE_60', 0x04)
define(`__RP1_ENABLE_SCANDOUBLER', 0x01)

# (R/W) 0x06 (06) => Peripheral 2 setting:
#  bit 7 = Enable turbo mode (0 = disabled, 1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 6 = DAC chip mode (0 = I2S, 1 = JAP) (Only VTrucco board, Reset to 0 after a PoR or Hard-reset)
#  bit 5 = Enable Lightpen (1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 4 = DivMMC automatic paging (1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 3 = Enable Multiface (1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 2 = PS/2 mode (0 = keyboard, 1 = mouse)(Reset to 0 after a PoR or Hard-reset)
#  bits 1-0 = Audio chip mode (0- = disabled, 10 = YM, 11 = AY)

define(`__REG_PERIPHERAL_2', 6)
define(`__RP2_ENABLE_TURBO', 0x80)
define(`__RP2_DAC_I2S', 0x00)
define(`__RP2_DAC_JAP', 0x40)
define(`__RP2_ENABLE_LIGHTPEN', 0x20)
define(`__RP2_ENABLE_DIVMMC', 0x10)
define(`__RP2_ENABLE_MULTIFACE', 0x08)
define(`__RP2_PS2_KEYBOARD', 0x00)
define(`__RP2_PS2_MOUSE', 0x04)
define(`__RP2_PSGMODE_AY', 0x03)
define(`__RP2_PSGMODE_YM', 0x02)
define(`__RP2_PSGMODE_DISABLE', 0x00)

# (R/W) 0x07 (07) => Turbo mode:
#  bit 1-0 = Turbo (00 = 3.5MHz, 01 = 7MHz, 10 = 14MHz)
#  (Reset to 00 after a PoR or Hard-reset)

define(`__REG_TURBO_MODE', 7)
define(`__RTM_3MHZ', 0x00)
define(`__RTM_7MHZ', 0x01)
define(`__RTM_14MHZ', 0x02)

# (R/W) 0x08 (08) => Peripheral 3 setting:
#  bit 7 = 128K paging enable (inverse of port 0x7ffd, bit 5) 
#          Unlike the paging lock in port 0x7ffd, 
#          this may be enabled or disabled at any time.
#          Use "1" to disable the locked paging.
#  bit 6 = "1" to disable RAM contention. (0 after a reset) 
#  bit 5 = Stereo mode (0 = ABC, 1 = ACB)(Reset to 0 after a PoR or Hard-reset)
#  bit 4 = Enable internal speaker (1 = enabled)(Reset to 1 afeter a PoR or Hard-reset)
#  bit 3 = Enable Specdrum/Covox (1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 2 = Enable Timex modes (1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 1 = Enable TurboSound (1 = enabled)(Reset to 0 after a PoR or Hard-reset)
#  bit 0 = Reserved, must be 0

define(`__REG_PERIPHERAL_3', 8)
define(`__RP3_STEREO_ABC', 0x00)
define(`__RP3_STEREO_ACB', 0x20)
define(`__RP3_ENABLE_SPEAKER', 0x10)
define(`__RP3_ENABLE_SPECDRUM', 0x08)
define(`__RP3_ENABLE_COVOX', 0x08)
define(`__RP3_ENABLE_TIMEX', 0x04)
define(`__RP3_ENABLE_TURBOSOUND', 0x02)
define(`__RP3_DISABLE_CONTENTION', 0x40)
define(`__RP3_UNLOCK_7FFD', 0x80)

# (R/W) 0x09 (09) => Peripheral 4 setting:
#   bits 7-2 = Reserved, must be 0
#   bits 1-0 = scanlines (0 after a PoR or Hard-reset)
#      00 = scanlines off
#      01 = scanlines 75%
#      10 = scanlines 50%
#      11 = scanlines 25%

define(`__REG_PERIPHERAL_4', 9)
define(`__RP4_SCANLINES_OFF', 0x00)
define(`__RP4_SCANLINES_25', 0x03)
define(`__RP4_SCANLINES_50', 0x02)
define(`__RP4_SCANLINES_75', 0x01)

# (R) 0x0E (14) => Core Version (sub minor number) 
#  (see register 0x01 for the major and minor version number)

define(`__REG_SUB_VERSION', 14)

# (W) 0x0F (15) => Video Register

define(`__REG_VIDEO_PARAM', 15)

# (R/W) 0x10 (16) => Anti-brick system (only in ZX Next Board):
#  bit 7 = (W) If 1 start normal core
#  bits 6-2 = Reserved, must be 0
#  bit 1 = (R) Button DivMMC (1=pressed)
#  bit 0 = (R) Button Multiface (1=pressed)

define(`__REG_ANTI_BRICK', 16)
define(`__RAB_COMMAND_NORMALCORE', 0x80)
define(`__RAB_BUTTON_DIVMMC', 0x02)
define(`__RAB_BUTTON_MULTIFACE', 0x01)

# (W) 0x11 (17) => Video Timing
# VGA = 0..6, HDMI = 7

define(`__REG_VIDEO_TIMING', 17)

# (R/W) 0x12 (18) => Layer 2 RAM page
# bits 7-6 = Reserved, must be 0
# bits 5-0 = SRAM bank 0-13 (point to bank 8 after a Reset)

define(`__REG_LAYER_2_RAM_PAGE', 18)
define(`__RL2RP_MASK', 0x3f)

# preferred name is bank for 16k banks

define(`__REG_LAYER_2_RAM_BANK', __REG_LAYER_2_RAM_PAGE)
define(`__RL2RB_MASK', __RL2RP_MASK)

# (R/W) 0x13 (19) => Layer 2 RAM shadow page
# bits 7-6 = Reserved, must be 0
# bits 5-0 = SRAM bank 0-13 (point to bank 11 after a Reset)

define(`__REG_LAYER_2_SHADOW_RAM_PAGE', 19)
define(`__RL2SRP_MASK', 0x3f)

# preferred name is bank for 16k banks

define(`__REG_LAYER_2_SHADOW_RAM_BANK', __REG_LAYER_2_SHADOW_RAM_PAGE)
define(`__RL2SRB_MASK', __RL2SRP_MASK)

# (R/W) 0x14 (20) => Global transparency color
#  bits 7-0 = Transparency color value (Reset to 0xE3, after a reset)
#  (Note this value is 8-bit only, so the transparency is compared only by the MSB bits of the final colour)

define(`__REG_GLOBAL_TRANSPARENCY_COLOR', 20)

# (R/W) 0x15 (21) => Sprite and Layers system
#  bit 7 - LoRes mode, 128 x 96 x 256 colours (1 = enabled)
#  bits 6-5 = Reserved, must be 0
#  bits 4-2 = set layers priorities:
#     Reset default is 000, sprites over the Layer 2, over the ULA graphics
#     000 - S L U
#     001 - L S U
#     010 - S U L
#     011 - L U S
#     100 - U S L
#     101 - U L S
#  bit 1 = Sprites Over border (1 = yes)(Back to 0 after a reset)
#  bit 0 = Sprites visible (1 = visible)(Back to 0 after a reset)

define(`__REG_SPRITE_LAYER_SYSTEM', 21)
define(`__RSLS_ENABLE_LORES', 0x80)
define(`__RSLS_LAYER_PRIORITY_SLU', 0x00)
define(`__RSLS_LAYER_PRIORITY_LSU', 0x04)
define(`__RSLS_LAYER_PRIORITY_SUL', 0x08)
define(`__RSLS_LAYER_PRIORITY_LUS', 0x0c)
define(`__RSLS_LAYER_PRIORITY_USL', 0x10)
define(`__RSLS_LAYER_PRIORITY_ULS', 0x14)
define(`__RSLS_SPRITES_OVER_BORDER', 0x02)
define(`__RSLS_SPRITES_VISIBLE', 0x01)

# (R/W) 0x16 (22) => Layer2 Offset X
#  bits 7-0 = X Offset (0-255)(Reset to 0 after a reset)

define(`__REG_LAYER_2_OFFSET_X', 22)

# (R/W) 0x17 (23) => Layer2 Offset Y
#  bits 7-0 = Y Offset (0-191)(Reset to 0 after a reset)

define(`__REG_LAYER_2_OFFSET_Y', 23)

# (W) 0x18 (24) => Clip Window Layer 2
#  bits 7-0 = Coord. of the clip window
#  1st write - X1 position
#  2nd write - X2 position
#  3rd write - Y1 position
#  4rd write - Y2 position
#  The values are 0,255,0,191 after a Reset

define(`__REG_CLIP_WINDOW_LAYER_2', 24)

# (W) 0x19 (25) => Clip Window Sprites
#  bits 7-0 = Coord. of the clip window
#  1st write - X1 position
#  2nd write - X2 position
#  3rd write - Y1 position
#  4rd write - Y2 position
#  The values are 0,255,0,191 after a Reset
#  Clip window on Sprites only work when the "over border bit" is disabled

define(`__REG_CLIP_WINDOW_SPRITES', 25)

# (W) 0x1A (26) => Clip Window ULA/LoRes
#  bits 7-0 = Coord. of the clip window
#  1st write = X1 position
#  2nd write = X2 position
#  3rd write = Y1 position
#  4rd write = Y2 position

define(`__REG_CLIP_WINDOW_ULA', 26)

# (W) 0x1C (28) => Clip Window control
#  bits 7-3 = Reserved, must be 0
#  bit 2 - reset the ULA/LoRes clip index.
#  bit 1 - reset the sprite clip index.
#  bit 0 - reset the Layer 2 clip index.

define(`__REG_CLIP_WINDOW_CONTROL', 28)
define(`__RCWC_RESET_ULA_CLIP_INDEX', 0x04)
define(`__RCWC_RESET_SPRITE_CLIP_INDEX', 0x02)
define(`__RCWC_RESET_LAYER_2_CLIP_INDEX', 0x01)

# (R) 0x1E (30) => Active video line (MSB)
#  bits 7-1 = Reserved, always 0
#  bit 0 = Active line MSB (Reset to 0 after a reset)

define(`__REG_ACTIVE_VIDEO_LINE_H', 30)

# (R) 0x1F (31) = Active video line (LSB)
#  bits 7-0 = Active line LSB (0-255)(Reset to 0 after a reset)

define(`__REG_ACTIVE_VIDEO_LINE_L', 31)

# (R/W) 0x22 (34) => Line Interrupt control
#  bit 7 = (R) INT flag, 1=During INT (even if the processor has interrupt disabled)
#  bits 6-3 = Reserved, must be 0
#  bit 2 = If 1 disables original ULA interrupt (Reset to 0 after a reset)
#  bit 1 = If 1 enables Line Interrupt (Reset to 0 after a reset)
#  bit 0 = MSB of Line Interrupt line value (Reset to 0 after a reset)

define(`__REG_LINE_INTERRUPT_CONTROL', 34)
define(`__RLIC_INTERRUPT_FLAG', 0x80)
define(`__RLIC_DISABLE_ULA_INTERRUPT', 0x04)
define(`__RLIC_ENABLE_LINE_INTERRUPT', 0x02)
define(`__RLIC_LINE_INTERRUPT_VALUE_H', 0x01)

# (R/W) 0x23 (35) => Line Interrupt value LSB
#  bits 7-0 = Line Interrupt line value LSB (0-255)(Reset to 0 after a reset)

define(`__REG_LINE_INTERRUPT_VALUE_L', 35)

# (W) 0x28 (40) => High address of Keymap
#  bits 7-1 = Reserved, must be 0
#  bit 0 = MSB address

define(`__REG_KEYMAP_ADDRESS_H', 40)

# (W) 0x29 (41) => Low address of Keymap
#  bits 7-0 = LSB adress

define(`__REG_KEYMAP_ADDRESS_L', 41)

# (W) 0x2A (42) => High data to Keymap
#  bits 7-1 = Reserved, must be 0
#  bit 0 = MSB data

define(`__REG_KEYMAP_DATA_H', 42)

# (W) 0x2B (43) => Low data to Keymap (writing this register the address is auto-incremented)
#  bits 7-0 = LSB data

define(`__REG_KEYMAP_DATA_L', 43)

# (W) 0x2D (45) => SoundDrive (SpecDrum) port 0xDF mirror
# bits 7-0 = Data to be written at Soundrive
# this port cand be used to send data to the SoundDrive using the Copper co-processor

define(`__REG_DAC_MONO', 45)

# (R/W) 0x32 (50) => LoRes Offset X
#  bits 7-0 = X Offset (0-255)(Reset to 0 after a reset)
#  Being only 128 pixels, this allows the display to scroll in "half-pixels", 
#  at the same resolution and smoothness as Layer 2.

define(`__REG_LORES_OFFSET_X', 50)

# (R/W) 0x33 (51) => LoRes Offset Y
#  bits 7-0 = Y Offset (0-191)(Reset to 0 after a reset)
#  Being only 96 pixels, this allows the display to scroll in "half-pixels",
#  at the same resolution and smoothness as Layer 2.

define(`__REG_LORES_OFFSET_Y', 51)

# (R/W) 0x40 (64) => Palette Index
#  bits 7-0 = Select the palette index to change the default colour. 
#  0 to 127 indexes are to ink colours and 128 to 255 indexes are to papers.
#  (Except full ink colour mode, that all values 0 to 255 are inks)
#  Border colours are the same as paper 0 to 7, positions 128 to 135,
#  even at full ink mode. 
#  (inks and papers concept only applies to Enhanced ULA palette. 
#  Layer 2 and Sprite palettes works as "full ink" mode)

define(`__REG_PALETTE_INDEX', 64)

# (R/W) 0x41 (65) => Palette Value (8 bit colour)
#  bits 7-0 = Colour for the palette index selected by the register 0x40. Format is RRRGGGBB
#  Note the lower blue bit colour will be an OR between bit 1 and bit 0. 
#  After the write, the palette index is auto-incremented to the next index, if the auto-increment is enabled at reg 0x43.
#  The changed palette remains until a Hard Reset.

define(`__REG_PALETTE_VALUE_8', 65)

# (R/W) 0x42 (66) => Palette Format
#  bits 7-0 = Number of the last ink colour entry on palette. (Reset to 15 after a Reset)
#  This number can be 1, 3, 7, 15, 31, 63, 127 or 255.
#  The 255 value enables the full ink colour mode and 
#  all the the palette entries are inks but the paper will be the colour at position 128.
#  (only applies to Enhanced ULA palette. Layer 2 and Sprite palettes works as "full ink")

define(`__REG_ULANEXT_PALETTE_FORMAT', 66)

# (R/W) 0x43 (67) => Palette Control
#  bit 7 = '1' to disable palette write auto-increment.
#  bits 6-4 = Select palette for reading or writing:
#     000 = ULA first palette
#     100 = ULA secondary palette
#     001 = Layer 2 first palette
#     101 = Layer 2 secondary palette
#     010 = Sprites first palette 
#     110 = Sprites secondary palette
#  bit 3 = Select Sprites palette (0 = first palette, 1 = secondary palette)
#  bit 2 = Select Layer 2 palette (0 = first palette, 1 = secondary palette)
#  bit 1 = Select ULA palette (0 = first palette, 1 = secondary palette)
#  bit 0 = Disable the standard Spectrum flash feature to enable the extra colours.
#  (Reset to 0 after a reset)

define(`__REG_PALETTE_CONTROL', 67)
define(`__RPC_DISABLE_AUTOINC', 0x80)
define(`__RPC_SELECT_ULA_PALETTE_0', 0x00)
define(`__RPC_SELECT_ULA_PALETTE_1', 0x40)
define(`__RPC_SELECT_LAYER_2_PALETTE_0', 0x10)
define(`__RPC_SELECT_LAYER_2_PALETTE_1', 0x50)
define(`__RPC_SELECT_SPRITES_PALETTE_0', 0x20)
define(`__RPC_SELECT_SPRITES_PALETTE_1', 0x60)
define(`__RPC_ENABLE_SPRITES_PALETTE_0', 0x00)
define(`__RPC_ENABLE_SPRITES_PALETTE_1', 0x08)
define(`__RPC_ENABLE_LAYER_2_PALETTE_0', 0x00)
define(`__RPC_ENABLE_LAYER_2_PALETTE_1', 0x04)
define(`__RPC_ENABLE_ULA_PALETTE_0', 0x00)
define(`__RPC_ENABLE_ULA_PALETTE_1', 0x02)
define(`__RPC_ENABLE_ULANEXT', 0x01)

# (R/W) 0x44 (68) => Palette Value (9 bit colour)
#  Two consecutive writes are needed to write the 9 bit colour
#  1st write:
#     bits 7-0 = RRRGGGBB
#  2nd write. 
#     bit 7-1 = Reserved, must be 0
#     bit 0 = lsb B
#  After the two consecutives writes the palette index is auto-incremented if the auto-increment is enable at reg 0x43.
#  The changed palette remains until a Hard Reset.

define(`__REG_PALETTE_VALUE_16', 68)

# (W) 0x4A (74) => Transparency colour fallback
#  bits 7-0 = Set the 8 bit colour.
#  (Reset to 0 = black on reset)

define(`__REG_FALLBACK_COLOR', 74)

# (R/W) 0x4B (75) => Transparency index for Sprites
#  bits 7-0 = Set the index value.
#  (0XE3 after a reset)

define(`__REG_SPRITE_TRANSPARENCY_INDEX', 75)

# (R/W) 0x50 (80) => MMU slot 0
#  bits 7-0 = Set a Spectrum RAM page at position 0x0000 to 0x1fff
#  (Reset to 255 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next. 
#  A 255 value remove the RAM page and map the current ROM
#
# (R/W) 0x51 (81) => MMU slot 1
#  bits 7-0 = Set a Spectrum RAM page at position 0x2000 to 0x3fff
#  (Reset to 255 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next. 
#  A 255 value remove the RAM page and map the current ROM
#
# (R/W) 0x52 (82) => MMU slot 2
#  bits 7-0 = Set a Spectrum RAM page at position 0x4000 to 0x5fff
#  (Reset to 10 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next.
#
# (R/W) 0x53 (83) => MMU slot 3
#  bits 7-0 = Set a Spectrum RAM page at position 0x6000 to 0x7FFF
#  (Reset to 11 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next.
#
# (R/W) 0x54 (84) => MMU slot 4
#  bits 7-0 = Set a Spectrum RAM page at position 0x8000 to 0x9FFF
#  (Reset to 4 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next.
#
# (R/W) 0x55 (85) => MMU slot 5
#  bits 7-0 = Set a Spectrum RAM page at position 0xA000 to 0xBFFF
#  (Reset to 5 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next.
#
# (R/W) 0x56 (86) => MMU slot 6
#  bits 7-0 = Set a Spectrum RAM page at position 0xC000 to 0xDFFF
#  (Reset to 0 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next.
#
# (R/W) 0x57 (87) => MMU slot 7
#  bits 7-0 = Set a Spectrum RAM page at position 0xE000 to 0xFFFF
#  (Reset to 1 after a reset)
#  Pages can be from 0 to 223 on a full expanded Next.
#
#  Writing on ports 0x1FFD, 0x7FFD and 0xDFFD overwrites some of the MMU values. 
#  +3 special mode DISABLE the MMUs, if is used.

define(`__REG_MMU0', 80)
define(`__REG_MMU1', 81)
define(`__REG_MMU2', 82)
define(`__REG_MMU3', 83)
define(`__REG_MMU4', 84)
define(`__REG_MMU5', 85)
define(`__REG_MMU6', 86)
define(`__REG_MMU7', 87)

# (W) 0x60 (96) => Copper data
#  bits 7-0 = Byte to write at "Copper list"
#  Note that each copper instruction is composed by two bytes (16 bits).

define(`__REG_COPPER_DATA', 96)

# (W) 0x61 (97) => Copper control LO bit
#  bits 7-0 = Copper list index address LSB.
#  After a write to reg 96, the index is auto-incremented to the next memory position.
#  (Index is set to 0 after a reset)

define(`__REG_COPPER_CONTROL_L', 97)

# (W) 0x62 (98) => Copper control HI bit
#   bits 7-6 = Start control
#       00 = Copper fully stoped
#       01 = Copper start, execute the list from index 0, and loop to the start
#       10 = Copper start, execute the list from last point, and loop to the start
#       11 = Copper start, execute the list from index 0, and restart the list at each frame
#   bits 2-0 = Copper list index address MSB

define(`__REG_COPPER_CONTROL_H', 98)
define(`__RCCH_COPPER_STOP', 0x00)
define(`__RCCH_COPPER_RUN_LOOP_RESET', 0x40)
define(`__RCCH_COPPER_RUN_LOOP', 0x80)
define(`__RCCH_COPPER_RUN_VBI', 0xc0)

# (W) 0xFF (255) => Debug LEDs (DE-1, DE-2 am Multicore only)

define(`__REG_DEBUG', 0xff)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_NEXTREG_REG'
PUBLIC `__IO_NEXTREG_DAT'

PUBLIC `__REG_MACHINE_ID'
PUBLIC `__RMI_DE1A'
PUBLIC `__RMI_DE2A'
PUBLIC `__RMI_FBLABS'
PUBLIC `__RMI_VTRUCCO'
PUBLIC `__RMI_WXEDA'
PUBLIC `__RMI_EMULATORS'
PUBLIC `__RMI_ZXNEXT'
PUBLIC `__RMI_MULTICORE'
PUBLIC `__RMI_ZXNEXT_AB'

PUBLIC `__REG_VERSION'
PUBLIC `__RV_MAJOR'
PUBLIC `__RV_MINOR'

PUBLIC `__REG_RESET'
PUBLIC `__RR_POWER_ON_RESET'
PUBLIC `__RR_HARD_RESET'
PUBLIC `__RR_SOFT_RESET'

PUBLIC `__REG_MACHINE_TYPE'
PUBLIC `__RMT_LOCK_TIMING'
PUBLIC `__RMT_TIMING_48'
PUBLIC `__RMT_TIMING_128'
PUBLIC `__RMT_TIMING_P3E'
PUBLIC `__RMT_TIMING_PENTAGON'
PUBLIC `__RMT_CONFIG_MODE'
PUBLIC `__RMT_48'
PUBLIC `__RMT_128'
PUBLIC `__RMT_P3E'
PUBLIC `__RMT_PENTAGON'

PUBLIC `__REG_RAM_PAGE'
PUBLIC `__RRP_RAM_DIVMMC'
PUBLIC `__RRP_ROM_DIVMMC'
PUBLIC `__RRP_ROM_MF'
PUBLIC `__RRP_ROM_SPECTRUM'

PUBLIC `__REG_PERIPHERAL_1'
PUBLIC `__RP1_JOY1_SINCLAIR'
PUBLIC `__RP1_JOY1_SINCLAIR_1'
PUBLIC `__RP1_JOY1_SINCLAIR_2'
PUBLIC `__RP1_JOY1_KEMPSTON'
PUBLIC `__RP1_JOY1_KEMPSTON_1'
PUBLIC `__RP1_JOY1_KEMPSTON_2'
PUBLIC `__RP1_JOY1_CURSOR'
PUBLIC `__RP1_JOY1_MD_1'
PUBLIC `__RP1_JOY1_MD_2'
PUBLIC `__RP1_JOY2_SINCLAIR'
PUBLIC `__RP1_JOY2_SINCLAIR_1'
PUBLIC `__RP1_JOY2_SINCLAIR_2'
PUBLIC `__RP1_JOY2_KEMPSTON'
PUBLIC `__RP1_JOY2_KEMPSTON_1'
PUBLIC `__RP1_JOY2_KEMPSTON_2'
PUBLIC `__RP1_JOY2_CURSOR'
PUBLIC `__RP1_JOY2_MD_1'
PUBLIC `__RP1_JOY2_MD_2'
PUBLIC `__RP1_RATE_50'
PUBLIC `__RP1_RATE_60'
PUBLIC `__RP1_ENABLE_SCANDOUBLER'

PUBLIC `__REG_PERIPHERAL_2'
PUBLIC `__RP2_ENABLE_TURBO'
PUBLIC `__RP2_DAC_I2S'
PUBLIC `__RP2_DAC_JAP'
PUBLIC `__RP2_ENABLE_LIGHTPEN'
PUBLIC `__RP2_ENABLE_DIVMMC'
PUBLIC `__RP2_ENABLE_MULTIFACE'
PUBLIC `__RP2_PS2_KEYBOARD'
PUBLIC `__RP2_PS2_MOUSE'
PUBLIC `__RP2_PSGMODE_AY'
PUBLIC `__RP2_PSGMODE_YM'
PUBLIC `__RP2_PSGMODE_DISABLE'

PUBLIC `__REG_TURBO_MODE'
PUBLIC `__RTM_3MHZ'
PUBLIC `__RTM_7MHZ'
PUBLIC `__RTM_14MHZ'

PUBLIC `__REG_PERIPHERAL_3'
PUBLIC `__RP3_STEREO_ABC'
PUBLIC `__RP3_STEREO_ACB'
PUBLIC `__RP3_ENABLE_SPEAKER'
PUBLIC `__RP3_ENABLE_SPECDRUM'
PUBLIC `__RP3_ENABLE_COVOX'
PUBLIC `__RP3_ENABLE_TIMEX'
PUBLIC `__RP3_ENABLE_TURBOSOUND'
PUBLIC `__RP3_DISABLE_CONTENTION'
PUBLIC `__RP3_UNLOCK_7FFD'

PUBLIC `__REG_PERIPHERAL_4'
PUBLIC `__RP4_SCANLINES_OFF'
PUBLIC `__RP4_SCANLINES_25'
PUBLIC `__RP4_SCANLINES_50'
PUBLIC `__RP4_SCANLINES_75'

PUBLIC `__REG_SUB_VERSION'

PUBLIC `__REG_VIDEO_PARAM'

PUBLIC `__REG_ANTI_BRICK'
PUBLIC `__RAB_COMMAND_NORMALCORE'
PUBLIC `__RAB_BUTTON_DIVMMC'
PUBLIC `__RAB_BUTTON_MULTIFACE'

PUBLIC `__REG_VIDEO_TIMING'

PUBLIC `__REG_LAYER_2_RAM_PAGE'
PUBLIC `__RL2RP_MASK'
PUBLIC `__REG_LAYER_2_RAM_BANK'
PUBLIC `__RL2RB_MASK'

PUBLIC `__REG_LAYER_2_SHADOW_RAM_PAGE'
PUBLIC `__RL2SRP_MASK'
PUBLIC `__REG_LAYER_2_SHADOW_RAM_BANK'
PUBLIC `__RL2SRB_MASK'

PUBLIC `__REG_GLOBAL_TRANSPARENCY_COLOR'

PUBLIC `__REG_SPRITE_LAYER_SYSTEM'
PUBLIC `__RSLS_ENABLE_LORES'
PUBLIC `__RSLS_LAYER_PRIORITY_SLU'
PUBLIC `__RSLS_LAYER_PRIORITY_LSU'
PUBLIC `__RSLS_LAYER_PRIORITY_SUL'
PUBLIC `__RSLS_LAYER_PRIORITY_LUS'
PUBLIC `__RSLS_LAYER_PRIORITY_USL'
PUBLIC `__RSLS_LAYER_PRIORITY_ULS'
PUBLIC `__RSLS_SPRITES_OVER_BORDER'
PUBLIC `__RSLS_SPRITES_VISIBLE'

PUBLIC `__REG_LAYER_2_OFFSET_X'

PUBLIC `__REG_LAYER_2_OFFSET_Y'

PUBLIC `__REG_CLIP_WINDOW_LAYER_2'

PUBLIC `__REG_CLIP_WINDOW_SPRITES'

PUBLIC `__REG_CLIP_WINDOW_ULA'

PUBLIC `__REG_CLIP_WINDOW_CONTROL'
PUBLIC `__RCWC_RESET_ULA_CLIP_INDEX'
PUBLIC `__RCWC_RESET_SPRITE_CLIP_INDEX'
PUBLIC `__RCWC_RESET_LAYER_2_CLIP_INDEX'

PUBLIC `__REG_ACTIVE_VIDEO_LINE_H'

PUBLIC `__REG_ACTIVE_VIDEO_LINE_L'

PUBLIC `__REG_LINE_INTERRUPT_CONTROL'
PUBLIC `__RLIC_INTERRUPT_FLAG'
PUBLIC `__RLIC_DISABLE_ULA_INTERRUPT'
PUBLIC `__RLIC_ENABLE_LINE_INTERRUPT'
PUBLIC `__RLIC_LINE_INTERRUPT_VALUE_H'

PUBLIC `__REG_LINE_INTERRUPT_VALUE_L'

PUBLIC `__REG_KEYMAP_ADDRESS_H'

PUBLIC `__REG_KEYMAP_ADDRESS_L'

PUBLIC `__REG_KEYMAP_DATA_H'

PUBLIC `__REG_KEYMAP_DATA_L'

PUBLIC `__REG_DAC_MONO'

PUBLIC `__REG_LORES_OFFSET_X'

PUBLIC `__REG_LORES_OFFSET_Y'

PUBLIC `__REG_PALETTE_INDEX'

PUBLIC `__REG_PALETTE_VALUE_8'

PUBLIC `__REG_ULANEXT_PALETTE_FORMAT'

PUBLIC `__REG_PALETTE_CONTROL'
PUBLIC `__RPC_DISABLE_AUTOINC'
PUBLIC `__RPC_SELECT_ULA_PALETTE_0'
PUBLIC `__RPC_SELECT_ULA_PALETTE_1'
PUBLIC `__RPC_SELECT_LAYER_2_PALETTE_0'
PUBLIC `__RPC_SELECT_LAYER_2_PALETTE_1'
PUBLIC `__RPC_SELECT_SPRITES_PALETTE_0'
PUBLIC `__RPC_SELECT_SPRITES_PALETTE_1'
PUBLIC `__RPC_ENABLE_SPRITES_PALETTE_0'
PUBLIC `__RPC_ENABLE_SPRITES_PALETTE_1'
PUBLIC `__RPC_ENABLE_LAYER_2_PALETTE_0'
PUBLIC `__RPC_ENABLE_LAYER_2_PALETTE_1'
PUBLIC `__RPC_ENABLE_ULA_PALETTE_0'
PUBLIC `__RPC_ENABLE_ULA_PALETTE_1'
PUBLIC `__RPC_ENABLE_ULANEXT'

PUBLIC `__REG_PALETTE_VALUE_16'

PUBLIC `__REG_FALLBACK_COLOR'

PUBLIC `__REG_SPRITE_TRANSPARENCY_INDEX'

PUBLIC `__REG_MMU0'
PUBLIC `__REG_MMU1'
PUBLIC `__REG_MMU2'
PUBLIC `__REG_MMU3'
PUBLIC `__REG_MMU4'
PUBLIC `__REG_MMU5'
PUBLIC `__REG_MMU6'
PUBLIC `__REG_MMU7'

PUBLIC `__REG_COPPER_DATA'

PUBLIC `__REG_COPPER_CONTROL_L'

PUBLIC `__REG_COPPER_CONTROL_H'
PUBLIC `__RCCH_COPPER_STOP'
PUBLIC `__RCCH_COPPER_RUN_LOOP_RESET'
PUBLIC `__RCCH_COPPER_RUN_LOOP'
PUBLIC `__RCCH_COPPER_RUN_VBI'

PUBLIC `__REG_DEBUG'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_NEXTREG_REG' = __IO_NEXTREG_REG
defc `__IO_NEXTREG_DAT' = __IO_NEXTREG_DAT

defc `__REG_MACHINE_ID' = __REG_MACHINE_ID
defc `__RMI_DE1A' = __RMI_DE1A
defc `__RMI_DE2A' = __RMI_DE2A
defc `__RMI_FBLABS' = __RMI_FBLABS
defc `__RMI_VTRUCCO' = __RMI_VTRUCCO
defc `__RMI_WXEDA' = __RMI_WXEDA
defc `__RMI_EMULATORS' = __RMI_EMULATORS
defc `__RMI_ZXNEXT' = __RMI_ZXNEXT
defc `__RMI_MULTICORE' = __RMI_MULTICORE
defc `__RMI_ZXNEXT_AB' = __RMI_ZXNEXT_AB

defc `__REG_VERSION' = __REG_VERSION
defc `__RV_MAJOR' = __RV_MAJOR
defc `__RV_MINOR' = __RV_MINOR

defc `__REG_RESET' = __REG_RESET
defc `__RR_POWER_ON_RESET' = __RR_POWER_ON_RESET
defc `__RR_HARD_RESET' = __RR_HARD_RESET
defc `__RR_SOFT_RESET' = __RR_SOFT_RESET

defc `__REG_MACHINE_TYPE' = __REG_MACHINE_TYPE
defc `__RMT_LOCK_TIMING' = __RMT_LOCK_TIMING
defc `__RMT_TIMING_48' = __RMT_TIMING_48
defc `__RMT_TIMING_128' = __RMT_TIMING_128
defc `__RMT_TIMING_P3E' = __RMT_TIMING_P3E
defc `__RMT_TIMING_PENTAGON' = __RMT_TIMING_PENTAGON
defc `__RMT_CONFIG_MODE' = __RMT_CONFIG_MODE
defc `__RMT_48' = __RMT_48
defc `__RMT_128' = __RMT_128
defc `__RMT_P3E' = __RMT_P3E
defc `__RMT_PENTAGON' = __RMT_PENTAGON

defc `__REG_RAM_PAGE' = __REG_RAM_PAGE
defc `__RRP_RAM_DIVMMC' = __RRP_RAM_DIVMMC
defc `__RRP_ROM_DIVMMC' = __RRP_ROM_DIVMMC
defc `__RRP_ROM_MF' = __RRP_ROM_MF
defc `__RRP_ROM_SPECTRUM' = __RRP_ROM_SPECTRUM

defc `__REG_PERIPHERAL_1' = __REG_PERIPHERAL_1
defc `__RP1_JOY1_SINCLAIR' = __RP1_JOY1_SINCLAIR
defc `__RP1_JOY1_SINCLAIR_1' = __RP1_JOY1_SINCLAIR_1
defc `__RP1_JOY1_SINCLAIR_2' = __RP1_JOY1_SINCLAIR_2
defc `__RP1_JOY1_KEMPSTON' = __RP1_JOY1_KEMPSTON
defc `__RP1_JOY1_KEMPSTON_1' = __RP1_JOY1_KEMPSTON_1
defc `__RP1_JOY1_KEMPSTON_2' = __RP1_JOY1_KEMPSTON_2
defc `__RP1_JOY1_CURSOR' = __RP1_JOY1_CURSOR
defc `__RP1_JOY1_MD_1' = __RP1_JOY1_MD_1
defc `__RP1_JOY1_MD_2' = __RP1_JOY1_MD_2
defc `__RP1_JOY2_SINCLAIR' = __RP1_JOY2_SINCLAIR
defc `__RP1_JOY2_SINCLAIR_1' = __RP1_JOY2_SINCLAIR_1
defc `__RP1_JOY2_SINCLAIR_2' = __RP1_JOY2_SINCLAIR_2
defc `__RP1_JOY2_KEMPSTON' = __RP1_JOY2_KEMPSTON
defc `__RP1_JOY2_KEMPSTON_1' = __RP1_JOY2_KEMPSTON_1
defc `__RP1_JOY2_KEMPSTON_2' = __RP1_JOY2_KEMPSTON_2
defc `__RP1_JOY2_CURSOR' = __RP1_JOY2_CURSOR
defc `__RP1_JOY2_MD_1' = __RP1_JOY2_MD_1
defc `__RP1_JOY2_MD_2' = __RP1_JOY2_MD_2
defc `__RP1_RATE_50' = __RP1_RATE_50
defc `__RP1_RATE_60' = __RP1_RATE_60
defc `__RP1_ENABLE_SCANDOUBLER' = __RP1_ENABLE_SCANDOUBLER

defc `__REG_PERIPHERAL_2' = __REG_PERIPHERAL_2
defc `__RP2_ENABLE_TURBO' = __RP2_ENABLE_TURBO
defc `__RP2_DAC_I2S' = __RP2_DAC_I2S
defc `__RP2_DAC_JAP' = __RP2_DAC_JAP
defc `__RP2_ENABLE_LIGHTPEN' = __RP2_ENABLE_LIGHTPEN
defc `__RP2_ENABLE_DIVMMC' = __RP2_ENABLE_DIVMMC
defc `__RP2_ENABLE_MULTIFACE' = __RP2_ENABLE_MULTIFACE
defc `__RP2_PS2_KEYBOARD' = __RP2_PS2_KEYBOARD
defc `__RP2_PS2_MOUSE' = __RP2_PS2_MOUSE
defc `__RP2_PSGMODE_AY' = __RP2_PSGMODE_AY
defc `__RP2_PSGMODE_YM' = __RP2_PSGMODE_YM
defc `__RP2_PSGMODE_DISABLE' = __RP2_PSGMODE_DISABLE

defc `__REG_TURBO_MODE' = __REG_TURBO_MODE
defc `__RTM_3MHZ' = __RTM_3MHZ
defc `__RTM_7MHZ' = __RTM_7MHZ
defc `__RTM_14MHZ' = __RTM_14MHZ

defc `__REG_PERIPHERAL_3' = __REG_PERIPHERAL_3
defc `__RP3_STEREO_ABC' = __RP3_STEREO_ABC
defc `__RP3_STEREO_ACB' = __RP3_STEREO_ACB
defc `__RP3_ENABLE_SPEAKER' = __RP3_ENABLE_SPEAKER
defc `__RP3_ENABLE_SPECDRUM' = __RP3_ENABLE_SPECDRUM
defc `__RP3_ENABLE_COVOX' = __RP3_ENABLE_COVOX
defc `__RP3_ENABLE_TIMEX' = __RP3_ENABLE_TIMEX
defc `__RP3_ENABLE_TURBOSOUND' = __RP3_ENABLE_TURBOSOUND
defc `__RP3_DISABLE_CONTENTION' = __RP3_DISABLE_CONTENTION
defc `__RP3_UNLOCK_7FFD' = __RP3_UNLOCK_7FFD

defc `__REG_PERIPHERAL_4' = __REG_PERIPHERAL_4
defc `__RP4_SCANLINES_OFF' = __RP4_SCANLINES_OFF
defc `__RP4_SCANLINES_25' = __RP4_SCANLINES_25
defc `__RP4_SCANLINES_50' = __RP4_SCANLINES_50
defc `__RP4_SCANLINES_75' = __RP4_SCANLINES_75

defc `__REG_SUB_VERSION' = __REG_SUB_VERSION

defc `__REG_VIDEO_PARAM' = __REG_VIDEO_PARAM

defc `__REG_ANTI_BRICK' = __REG_ANTI_BRICK
defc `__RAB_COMMAND_NORMALCORE' = __RAB_COMMAND_NORMALCORE
defc `__RAB_BUTTON_DIVMMC' = __RAB_BUTTON_DIVMMC
defc `__RAB_BUTTON_MULTIFACE' = __RAB_BUTTON_MULTIFACE

defc `__REG_VIDEO_TIMING' = __REG_VIDEO_TIMING

defc `__REG_LAYER_2_RAM_PAGE' = __REG_LAYER_2_RAM_PAGE
defc `__RL2RP_MASK' = __RL2RP_MASK
defc `__REG_LAYER_2_RAM_BANK' = __REG_LAYER_2_RAM_BANK
defc `__RL2RB_MASK' = __RL2RB_MASK

defc `__REG_LAYER_2_SHADOW_RAM_PAGE' = __REG_LAYER_2_SHADOW_RAM_PAGE
defc `__RL2SRP_MASK' = __RL2SRP_MASK
defc `__REG_LAYER_2_SHADOW_RAM_BANK' = __REG_LAYER_2_SHADOW_RAM_BANK
defc `__RL2SRB_MASK' = __RL2SRB_MASK

defc `__REG_GLOBAL_TRANSPARENCY_COLOR' = __REG_GLOBAL_TRANSPARENCY_COLOR

defc `__REG_SPRITE_LAYER_SYSTEM' = __REG_SPRITE_LAYER_SYSTEM
defc `__RSLS_ENABLE_LORES' = __RSLS_ENABLE_LORES
defc `__RSLS_LAYER_PRIORITY_SLU' = __RSLS_LAYER_PRIORITY_SLU
defc `__RSLS_LAYER_PRIORITY_LSU' = __RSLS_LAYER_PRIORITY_LSU
defc `__RSLS_LAYER_PRIORITY_SUL' = __RSLS_LAYER_PRIORITY_SUL
defc `__RSLS_LAYER_PRIORITY_LUS' = __RSLS_LAYER_PRIORITY_LUS
defc `__RSLS_LAYER_PRIORITY_USL' = __RSLS_LAYER_PRIORITY_USL
defc `__RSLS_LAYER_PRIORITY_ULS' = __RSLS_LAYER_PRIORITY_ULS
defc `__RSLS_SPRITES_OVER_BORDER' = __RSLS_SPRITES_OVER_BORDER
defc `__RSLS_SPRITES_VISIBLE' = __RSLS_SPRITES_VISIBLE

defc `__REG_LAYER_2_OFFSET_X' = __REG_LAYER_2_OFFSET_X

defc `__REG_LAYER_2_OFFSET_Y' = __REG_LAYER_2_OFFSET_Y

defc `__REG_CLIP_WINDOW_LAYER_2' = __REG_CLIP_WINDOW_LAYER_2

defc `__REG_CLIP_WINDOW_SPRITES' = __REG_CLIP_WINDOW_SPRITES

defc `__REG_CLIP_WINDOW_ULA' = __REG_CLIP_WINDOW_ULA

defc `__REG_CLIP_WINDOW_CONTROL' = __REG_CLIP_WINDOW_CONTROL
defc `__RCWC_RESET_ULA_CLIP_INDEX' = __RCWC_RESET_ULA_CLIP_INDEX
defc `__RCWC_RESET_SPRITE_CLIP_INDEX' = __RCWC_RESET_SPRITE_CLIP_INDEX
defc `__RCWC_RESET_LAYER_2_CLIP_INDEX' = __RCWC_RESET_LAYER_2_CLIP_INDEX

defc `__REG_ACTIVE_VIDEO_LINE_H' = __REG_ACTIVE_VIDEO_LINE_H

defc `__REG_ACTIVE_VIDEO_LINE_L' = __REG_ACTIVE_VIDEO_LINE_L

defc `__REG_LINE_INTERRUPT_CONTROL' = __REG_LINE_INTERRUPT_CONTROL
defc `__RLIC_INTERRUPT_FLAG' = __RLIC_INTERRUPT_FLAG
defc `__RLIC_DISABLE_ULA_INTERRUPT' = __RLIC_DISABLE_ULA_INTERRUPT
defc `__RLIC_ENABLE_LINE_INTERRUPT' = __RLIC_ENABLE_LINE_INTERRUPT
defc `__RLIC_LINE_INTERRUPT_VALUE_H' = __RLIC_LINE_INTERRUPT_VALUE_H

defc `__REG_LINE_INTERRUPT_VALUE_L' = __REG_LINE_INTERRUPT_VALUE_L

defc `__REG_KEYMAP_ADDRESS_H' = __REG_KEYMAP_ADDRESS_H

defc `__REG_KEYMAP_ADDRESS_L' = __REG_KEYMAP_ADDRESS_L

defc `__REG_KEYMAP_DATA_H' = __REG_KEYMAP_DATA_H

defc `__REG_KEYMAP_DATA_L' = __REG_KEYMAP_DATA_L

defc `__REG_DAC_MONO' = __REG_DAC_MONO

defc `__REG_LORES_OFFSET_X' = __REG_LORES_OFFSET_X

defc `__REG_LORES_OFFSET_Y' = __REG_LORES_OFFSET_Y

defc `__REG_PALETTE_INDEX' = __REG_PALETTE_INDEX

defc `__REG_PALETTE_VALUE_8' = __REG_PALETTE_VALUE_8

defc `__REG_ULANEXT_PALETTE_FORMAT' = __REG_ULANEXT_PALETTE_FORMAT

defc `__REG_PALETTE_CONTROL' = __REG_PALETTE_CONTROL
defc `__RPC_DISABLE_AUTOINC' = __RPC_DISABLE_AUTOINC
defc `__RPC_SELECT_ULA_PALETTE_0' = __RPC_SELECT_ULA_PALETTE_0
defc `__RPC_SELECT_ULA_PALETTE_1' = __RPC_SELECT_ULA_PALETTE_1
defc `__RPC_SELECT_LAYER_2_PALETTE_0' = __RPC_SELECT_LAYER_2_PALETTE_0
defc `__RPC_SELECT_LAYER_2_PALETTE_1' = __RPC_SELECT_LAYER_2_PALETTE_1
defc `__RPC_SELECT_SPRITES_PALETTE_0' = __RPC_SELECT_SPRITES_PALETTE_0
defc `__RPC_SELECT_SPRITES_PALETTE_1' = __RPC_SELECT_SPRITES_PALETTE_1
defc `__RPC_ENABLE_SPRITES_PALETTE_0' = __RPC_ENABLE_SPRITES_PALETTE_0
defc `__RPC_ENABLE_SPRITES_PALETTE_1' = __RPC_ENABLE_SPRITES_PALETTE_1
defc `__RPC_ENABLE_LAYER_2_PALETTE_0' = __RPC_ENABLE_LAYER_2_PALETTE_0
defc `__RPC_ENABLE_LAYER_2_PALETTE_1' = __RPC_ENABLE_LAYER_2_PALETTE_1
defc `__RPC_ENABLE_ULA_PALETTE_0' = __RPC_ENABLE_ULA_PALETTE_0
defc `__RPC_ENABLE_ULA_PALETTE_1' = __RPC_ENABLE_ULA_PALETTE_1
defc `__RPC_ENABLE_ULANEXT' = __RPC_ENABLE_ULANEXT

defc `__REG_PALETTE_VALUE_16' = __REG_PALETTE_VALUE_16

defc `__REG_FALLBACK_COLOR' = __REG_FALLBACK_COLOR

defc `__REG_SPRITE_TRANSPARENCY_INDEX' = __REG_SPRITE_TRANSPARENCY_INDEX

defc `__REG_MMU0' = __REG_MMU0
defc `__REG_MMU1' = __REG_MMU1
defc `__REG_MMU2' = __REG_MMU2
defc `__REG_MMU3' = __REG_MMU3
defc `__REG_MMU4' = __REG_MMU4
defc `__REG_MMU5' = __REG_MMU5
defc `__REG_MMU6' = __REG_MMU6
defc `__REG_MMU7' = __REG_MMU7

defc `__REG_COPPER_DATA' = __REG_COPPER_DATA

defc `__REG_COPPER_CONTROL_L' = __REG_COPPER_CONTROL_L

defc `__REG_COPPER_CONTROL_H' = __REG_COPPER_CONTROL_H
defc `__RCCH_COPPER_STOP' = __RCCH_COPPER_STOP
defc `__RCCH_COPPER_RUN_LOOP_RESET' = __RCCH_COPPER_RUN_LOOP_RESET
defc `__RCCH_COPPER_RUN_LOOP' = __RCCH_COPPER_RUN_LOOP
defc `__RCCH_COPPER_RUN_VBI' = __RCCH_COPPER_RUN_VBI

defc `__REG_DEBUG' = __REG_DEBUG
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_NEXTREG_REG'  __IO_NEXTREG_REG
`#define' `__IO_NEXTREG_DAT'  __IO_NEXTREG_DAT

`#define' `__REG_MACHINE_ID'  __REG_MACHINE_ID
`#define' `__RMI_DE1A'  __RMI_DE1A
`#define' `__RMI_DE2A'  __RMI_DE2A
`#define' `__RMI_FBLABS'  __RMI_FBLABS
`#define' `__RMI_VTRUCCO'  __RMI_VTRUCCO
`#define' `__RMI_WXEDA'  __RMI_WXEDA
`#define' `__RMI_EMULATORS'  __RMI_EMULATORS
`#define' `__RMI_ZXNEXT'  __RMI_ZXNEXT
`#define' `__RMI_MULTICORE'  __RMI_MULTICORE
`#define' `__RMI_ZXNEXT_AB'  __RMI_ZXNEXT_AB

`#define' `__REG_VERSION'  __REG_VERSION
`#define' `__RV_MAJOR'  __RV_MAJOR
`#define' `__RV_MINOR'  __RV_MINOR

`#define' `__REG_RESET'  __REG_RESET
`#define' `__RR_POWER_ON_RESET'  __RR_POWER_ON_RESET
`#define' `__RR_HARD_RESET'  __RR_HARD_RESET
`#define' `__RR_SOFT_RESET'  __RR_SOFT_RESET

`#define' `__REG_MACHINE_TYPE'  __REG_MACHINE_TYPE
`#define' `__RMT_LOCK_TIMING'  __RMT_LOCK_TIMING
`#define' `__RMT_TIMING_48'  __RMT_TIMING_48
`#define' `__RMT_TIMING_128'  __RMT_TIMING_128
`#define' `__RMT_TIMING_P3E'  __RMT_TIMING_P3E
`#define' `__RMT_TIMING_PENTAGON'  __RMT_TIMING_PENTAGON
`#define' `__RMT_CONFIG_MODE'  __RMT_CONFIG_MODE
`#define' `__RMT_48'  __RMT_48
`#define' `__RMT_128'  __RMT_128
`#define' `__RMT_P3E'  __RMT_P3E
`#define' `__RMT_PENTAGON'  __RMT_PENTAGON

`#define' `__REG_RAM_PAGE'  __REG_RAM_PAGE
`#define' `__RRP_RAM_DIVMMC'  __RRP_RAM_DIVMMC
`#define' `__RRP_ROM_DIVMMC'  __RRP_ROM_DIVMMC
`#define' `__RRP_ROM_MF'  __RRP_ROM_MF
`#define' `__RRP_ROM_SPECTRUM'  __RRP_ROM_SPECTRUM

`#define' `__REG_PERIPHERAL_1'  __REG_PERIPHERAL_1
`#define' `__RP1_JOY1_SINCLAIR'  __RP1_JOY1_SINCLAIR
`#define' `__RP1_JOY1_SINCLAIR_1'  __RP1_JOY1_SINCLAIR_1
`#define' `__RP1_JOY1_SINCLAIR_2'  __RP1_JOY1_SINCLAIR_2
`#define' `__RP1_JOY1_KEMPSTON'  __RP1_JOY1_KEMPSTON
`#define' `__RP1_JOY1_KEMPSTON_1'  __RP1_JOY1_KEMPSTON_1
`#define' `__RP1_JOY1_KEMPSTON_2'  __RP1_JOY1_KEMPSTON_2
`#define' `__RP1_JOY1_CURSOR'  __RP1_JOY1_CURSOR
`#define' `__RP1_JOY1_MD_1'  __RP1_JOY1_MD_1
`#define' `__RP1_JOY1_MD_2'  __RP1_JOY1_MD_2
`#define' `__RP1_JOY2_SINCLAIR'  __RP1_JOY2_SINCLAIR
`#define' `__RP1_JOY2_SINCLAIR_1'  __RP1_JOY2_SINCLAIR_1
`#define' `__RP1_JOY2_SINCLAIR_2'  __RP1_JOY2_SINCLAIR_2
`#define' `__RP1_JOY2_KEMPSTON'  __RP1_JOY2_KEMPSTON
`#define' `__RP1_JOY2_KEMPSTON_1'  __RP1_JOY2_KEMPSTON_1
`#define' `__RP1_JOY2_KEMPSTON_2'  __RP1_JOY2_KEMPSTON_2
`#define' `__RP1_JOY2_CURSOR'  __RP1_JOY2_CURSOR
`#define' `__RP1_JOY2_MD_1'  __RP1_JOY2_MD_1
`#define' `__RP1_JOY2_MD_2'  __RP1_JOY2_MD_2
`#define' `__RP1_RATE_50'  __RP1_RATE_50
`#define' `__RP1_RATE_60'  __RP1_RATE_60
`#define' `__RP1_ENABLE_SCANDOUBLER'  __RP1_ENABLE_SCANDOUBLER

`#define' `__REG_PERIPHERAL_2'  __REG_PERIPHERAL_2
`#define' `__RP2_ENABLE_TURBO'  __RP2_ENABLE_TURBO
`#define' `__RP2_DAC_I2S'  __RP2_DAC_I2S
`#define' `__RP2_DAC_JAP'  __RP2_DAC_JAP
`#define' `__RP2_ENABLE_LIGHTPEN'  __RP2_ENABLE_LIGHTPEN
`#define' `__RP2_ENABLE_DIVMMC'  __RP2_ENABLE_DIVMMC
`#define' `__RP2_ENABLE_MULTIFACE'  __RP2_ENABLE_MULTIFACE
`#define' `__RP2_PS2_KEYBOARD'  __RP2_PS2_KEYBOARD
`#define' `__RP2_PS2_MOUSE'  __RP2_PS2_MOUSE
`#define' `__RP2_PSGMODE_AY'  __RP2_PSGMODE_AY
`#define' `__RP2_PSGMODE_YM'  __RP2_PSGMODE_YM
`#define' `__RP2_PSGMODE_DISABLE'  __RP2_PSGMODE_DISABLE

`#define' `__REG_TURBO_MODE'  __REG_TURBO_MODE
`#define' `__RTM_3MHZ'  __RTM_3MHZ
`#define' `__RTM_7MHZ'  __RTM_7MHZ
`#define' `__RTM_14MHZ'  __RTM_14MHZ

`#define' `__REG_PERIPHERAL_3'  __REG_PERIPHERAL_3
`#define' `__RP3_STEREO_ABC'  __RP3_STEREO_ABC
`#define' `__RP3_STEREO_ACB'  __RP3_STEREO_ACB
`#define' `__RP3_ENABLE_SPEAKER'  __RP3_ENABLE_SPEAKER
`#define' `__RP3_ENABLE_SPECDRUM'  __RP3_ENABLE_SPECDRUM
`#define' `__RP3_ENABLE_COVOX'  __RP3_ENABLE_COVOX
`#define' `__RP3_ENABLE_TIMEX'  __RP3_ENABLE_TIMEX
`#define' `__RP3_ENABLE_TURBOSOUND'  __RP3_ENABLE_TURBOSOUND
`#define' `__RP3_DISABLE_CONTENTION'  __RP3_DISABLE_CONTENTION
`#define' `__RP3_UNLOCK_7FFD'  __RP3_UNLOCK_7FFD

`#define' `__REG_PERIPHERAL_4'  __REG_PERIPHERAL_4
`#define' `__RP4_SCANLINES_OFF'  __RP4_SCANLINES_OFF
`#define' `__RP4_SCANLINES_25'  __RP4_SCANLINES_25
`#define' `__RP4_SCANLINES_50'  __RP4_SCANLINES_50
`#define' `__RP4_SCANLINES_75'  __RP4_SCANLINES_75

`#define' `__REG_SUB_VERSION'  __REG_SUB_VERSION

`#define' `__REG_VIDEO_PARAM'  __REG_VIDEO_PARAM

`#define' `__REG_ANTI_BRICK'  __REG_ANTI_BRICK
`#define' `__RAB_COMMAND_NORMALCORE'  __RAB_COMMAND_NORMALCORE
`#define' `__RAB_BUTTON_DIVMMC'  __RAB_BUTTON_DIVMMC
`#define' `__RAB_BUTTON_MULTIFACE'  __RAB_BUTTON_MULTIFACE

`#define' `__REG_VIDEO_TIMING'  __REG_VIDEO_TIMING

`#define' `__REG_LAYER_2_RAM_PAGE'  __REG_LAYER_2_RAM_PAGE
`#define' `__RL2RP_MASK'  __RL2RP_MASK
`#define' `__REG_LAYER_2_RAM_BANK'  __REG_LAYER_2_RAM_BANK
`#define' `__RL2RB_MASK'  __RL2RB_MASK

`#define' `__REG_LAYER_2_SHADOW_RAM_PAGE'  __REG_LAYER_2_SHADOW_RAM_PAGE
`#define' `__RL2SRP_MASK'  __RL2SRP_MASK
`#define' `__REG_LAYER_2_SHADOW_RAM_BANK'  __REG_LAYER_2_SHADOW_RAM_BANK
`#define' `__RL2SRB_MASK'  __RL2SRB_MASK

`#define' `__REG_GLOBAL_TRANSPARENCY_COLOR'  __REG_GLOBAL_TRANSPARENCY_COLOR

`#define' `__REG_SPRITE_LAYER_SYSTEM'  __REG_SPRITE_LAYER_SYSTEM
`#define' `__RSLS_ENABLE_LORES'  __RSLS_ENABLE_LORES
`#define' `__RSLS_LAYER_PRIORITY_SLU'  __RSLS_LAYER_PRIORITY_SLU
`#define' `__RSLS_LAYER_PRIORITY_LSU'  __RSLS_LAYER_PRIORITY_LSU
`#define' `__RSLS_LAYER_PRIORITY_SUL'  __RSLS_LAYER_PRIORITY_SUL
`#define' `__RSLS_LAYER_PRIORITY_LUS'  __RSLS_LAYER_PRIORITY_LUS
`#define' `__RSLS_LAYER_PRIORITY_USL'  __RSLS_LAYER_PRIORITY_USL
`#define' `__RSLS_LAYER_PRIORITY_ULS'  __RSLS_LAYER_PRIORITY_ULS
`#define' `__RSLS_SPRITES_OVER_BORDER'  __RSLS_SPRITES_OVER_BORDER
`#define' `__RSLS_SPRITES_VISIBLE'  __RSLS_SPRITES_VISIBLE

`#define' `__REG_LAYER_2_OFFSET_X'  __REG_LAYER_2_OFFSET_X

`#define' `__REG_LAYER_2_OFFSET_Y'  __REG_LAYER_2_OFFSET_Y

`#define' `__REG_CLIP_WINDOW_LAYER_2'  __REG_CLIP_WINDOW_LAYER_2

`#define' `__REG_CLIP_WINDOW_SPRITES'  __REG_CLIP_WINDOW_SPRITES

`#define' `__REG_CLIP_WINDOW_ULA'  __REG_CLIP_WINDOW_ULA

`#define' `__REG_CLIP_WINDOW_CONTROL'  __REG_CLIP_WINDOW_CONTROL
`#define' `__RCWC_RESET_ULA_CLIP_INDEX'  __RCWC_RESET_ULA_CLIP_INDEX
`#define' `__RCWC_RESET_SPRITE_CLIP_INDEX'  __RCWC_RESET_SPRITE_CLIP_INDEX
`#define' `__RCWC_RESET_LAYER_2_CLIP_INDEX'  __RCWC_RESET_LAYER_2_CLIP_INDEX

`#define' `__REG_ACTIVE_VIDEO_LINE_H'  __REG_ACTIVE_VIDEO_LINE_H

`#define' `__REG_ACTIVE_VIDEO_LINE_L'  __REG_ACTIVE_VIDEO_LINE_L

`#define' `__REG_LINE_INTERRUPT_CONTROL'  __REG_LINE_INTERRUPT_CONTROL
`#define' `__RLIC_INTERRUPT_FLAG'  __RLIC_INTERRUPT_FLAG
`#define' `__RLIC_DISABLE_ULA_INTERRUPT'  __RLIC_DISABLE_ULA_INTERRUPT
`#define' `__RLIC_ENABLE_LINE_INTERRUPT'  __RLIC_ENABLE_LINE_INTERRUPT
`#define' `__RLIC_LINE_INTERRUPT_VALUE_H'  __RLIC_LINE_INTERRUPT_VALUE_H

`#define' `__REG_LINE_INTERRUPT_VALUE_L'  __REG_LINE_INTERRUPT_VALUE_L

`#define' `__REG_KEYMAP_ADDRESS_H'  __REG_KEYMAP_ADDRESS_H

`#define' `__REG_KEYMAP_ADDRESS_L'  __REG_KEYMAP_ADDRESS_L

`#define' `__REG_KEYMAP_DATA_H'  __REG_KEYMAP_DATA_H

`#define' `__REG_KEYMAP_DATA_L'  __REG_KEYMAP_DATA_L

`#define' `__REG_DAC_MONO'  __REG_DAC_MONO

`#define' `__REG_LORES_OFFSET_X'  __REG_LORES_OFFSET_X

`#define' `__REG_LORES_OFFSET_Y'  __REG_LORES_OFFSET_Y

`#define' `__REG_PALETTE_INDEX'  __REG_PALETTE_INDEX

`#define' `__REG_PALETTE_VALUE_8'  __REG_PALETTE_VALUE_8

`#define' `__REG_ULANEXT_PALETTE_FORMAT'  __REG_ULANEXT_PALETTE_FORMAT

`#define' `__REG_PALETTE_CONTROL'  __REG_PALETTE_CONTROL
`#define' `__RPC_DISABLE_AUTOINC'  __RPC_DISABLE_AUTOINC
`#define' `__RPC_SELECT_ULA_PALETTE_0'  __RPC_SELECT_ULA_PALETTE_0
`#define' `__RPC_SELECT_ULA_PALETTE_1'  __RPC_SELECT_ULA_PALETTE_1
`#define' `__RPC_SELECT_LAYER_2_PALETTE_0'  __RPC_SELECT_LAYER_2_PALETTE_0
`#define' `__RPC_SELECT_LAYER_2_PALETTE_1'  __RPC_SELECT_LAYER_2_PALETTE_1
`#define' `__RPC_SELECT_SPRITES_PALETTE_0'  __RPC_SELECT_SPRITES_PALETTE_0
`#define' `__RPC_SELECT_SPRITES_PALETTE_1'  __RPC_SELECT_SPRITES_PALETTE_1
`#define' `__RPC_ENABLE_SPRITES_PALETTE_0'  __RPC_ENABLE_SPRITES_PALETTE_0
`#define' `__RPC_ENABLE_SPRITES_PALETTE_1'  __RPC_ENABLE_SPRITES_PALETTE_1
`#define' `__RPC_ENABLE_LAYER_2_PALETTE_0'  __RPC_ENABLE_LAYER_2_PALETTE_0
`#define' `__RPC_ENABLE_LAYER_2_PALETTE_1'  __RPC_ENABLE_LAYER_2_PALETTE_1
`#define' `__RPC_ENABLE_ULA_PALETTE_0'  __RPC_ENABLE_ULA_PALETTE_0
`#define' `__RPC_ENABLE_ULA_PALETTE_1'  __RPC_ENABLE_ULA_PALETTE_1
`#define' `__RPC_ENABLE_ULANEXT'  __RPC_ENABLE_ULANEXT

`#define' `__REG_PALETTE_VALUE_16'  __REG_PALETTE_VALUE_16

`#define' `__REG_FALLBACK_COLOR'  __REG_FALLBACK_COLOR

`#define' `__REG_SPRITE_TRANSPARENCY_INDEX'  __REG_SPRITE_TRANSPARENCY_INDEX

`#define' `__REG_MMU0'  __REG_MMU0
`#define' `__REG_MMU1'  __REG_MMU1
`#define' `__REG_MMU2'  __REG_MMU2
`#define' `__REG_MMU3'  __REG_MMU3
`#define' `__REG_MMU4'  __REG_MMU4
`#define' `__REG_MMU5'  __REG_MMU5
`#define' `__REG_MMU6'  __REG_MMU6
`#define' `__REG_MMU7'  __REG_MMU7

`#define' `__REG_COPPER_DATA'  __REG_COPPER_DATA

`#define' `__REG_COPPER_CONTROL_L'  __REG_COPPER_CONTROL_L

`#define' `__REG_COPPER_CONTROL_H'  __REG_COPPER_CONTROL_H
`#define' `__RCCH_COPPER_STOP'  __RCCH_COPPER_STOP
`#define' `__RCCH_COPPER_RUN_LOOP_RESET'  __RCCH_COPPER_RUN_LOOP_RESET
`#define' `__RCCH_COPPER_RUN_LOOP'  __RCCH_COPPER_RUN_LOOP
`#define' `__RCCH_COPPER_RUN_VBI'  __RCCH_COPPER_RUN_VBI

`#define' `__REG_DEBUG'  __REG_DEBUG
')
