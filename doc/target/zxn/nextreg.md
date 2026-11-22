# ZX Spectrum Next registers and their z88dk constants

Generated from the ZX Spectrum Next FPGA register reference, annotated with
the constant names z88dk defines for the `zxn` target.

- Register reference: <https://gitlab.com/SpectrumNext/ZX_Spectrum_Next_FPGA/-/blob/master/cores/zxnext/nextreg.txt>
- z88dk constants: `libsrc/newlib/target/zxn/config/`, reachable from C and assembler through `<arch/zxn.h>`
- Generated: 2026-09-26

In C the constants are used as written here. In assembler the same names carry a
`__` prefix, so `REG_TILEMAP_CONTROL` is `__REG_TILEMAP_CONTROL`.

Registers with no constant are marked _(none)_ — they are described by the
hardware reference but z88dk has no name for them yet.

## Register summary

| Register | Name | z88dk constant |
| --- | --- | --- |
| `0x00` (0) | Machine ID | `REG_MACHINE_ID` |
| `0x01` (1) | Core Version | `REG_VERSION` |
| `0x02` (2) | Reset | `REG_RESET` |
| `0x03` (3) | Machine Type | `REG_MACHINE_TYPE` |
| `0x04` (4) | Config Mapping | `REG_RAM_PAGE` |
| `0x05` (5) | Peripheral 1 Setting | `REG_PERIPHERAL_1` |
| `0x06` (6) | Peripheral 2 Setting | `REG_PERIPHERAL_2` |
| `0x07` (7) | CPU Speed | `REG_TURBO_MODE` |
| `0x08` (8) | Peripheral 3 Setting | `REG_PERIPHERAL_3` |
| `0x09` (9) | Peripheral 4 Setting | `REG_PERIPHERAL_4` |
| `0x0A` (10) | Peripheral 5 Setting | `REG_PERIPHERAL_5` |
| `0x0B` (11) | Joystick I/O Mode | `REG_JOYSTICK_IO_MODE` |
| `0x0E` (14) | Core Version | `REG_SUB_VERSION` |
| `0x0F` (15) | Board ID | `REG_VIDEO_PARAM` |
| `0x10` (16) | Core Boot | `REG_ANTI_BRICK` |
| `0x11` (17) | Video Timing | `REG_VIDEO_TIMING` |
| `0x12` (18) | Layer 2 Active RAM bank | `REG_LAYER_2_RAM_PAGE` |
| `0x13` (19) | Layer 2 Shadow RAM bank | `REG_LAYER_2_SHADOW_RAM_PAGE` |
| `0x14` (20) | Global Transparency Colour | `REG_GLOBAL_TRANSPARENCY_COLOR` |
| `0x15` (21) | Sprite and Layers System | `REG_SPRITE_LAYER_SYSTEM` |
| `0x16` (22) | Layer 2 X Scroll LSB | `REG_LAYER_2_OFFSET_X` |
| `0x17` (23) | Layer 2 Y Scroll | `REG_LAYER_2_OFFSET_Y` |
| `0x18` (24) | Clip Window Layer 2 | `REG_CLIP_WINDOW_LAYER_2` |
| `0x19` (25) | Clip Window Sprites | `REG_CLIP_WINDOW_SPRITES` |
| `0x1A` (26) | Clip Window ULA/LoRes | `REG_CLIP_WINDOW_ULA` |
| `0x1B` (27) | Clip Window Tilemap | `REG_CLIP_WINDOW_TILEMAP` |
| `0x1C` (28) | Clip Window Control | `REG_CLIP_WINDOW_CONTROL` |
| `0x1E` (30) | Active Video Line (MSB) | `REG_ACTIVE_VIDEO_LINE_H` |
| `0x1F` (31) | Active Video Line (LSB) | `REG_ACTIVE_VIDEO_LINE_L` |
| `0x20` (32) | Generate Maskable Interrupt | `REG_GENERATE_MASKABLE_INTERRUPT` |
| `0x22` (34) | Line Interrupt control | `REG_LINE_INTERRUPT_CONTROL` |
| `0x23` (35) | Line Interrupt Value LSB | `REG_LINE_INTERRUPT_VALUE_L` |
| `0x24` (36) | Reserved | _(none)_ |
| `0x26` (38) | ULA X Scroll | `REG_ULA_OFFSET_X` |
| `0x27` (39) | ULA Y Scroll | `REG_ULA_OFFSET_Y` |
| `0x28` (40) | PS/2 Keymap Address MSB | `REG_KEYMAP_ADDRESS_H` |
| `0x29` (41) | PS/2 Keymap Address LSB | `REG_KEYMAP_ADDRESS_L` |
| `0x2A` (42) | PS/2 Keymap Data MSB | `REG_KEYMAP_DATA_H` |
| `0x2B` (43) | PS/2 Keymap Data LSB | `REG_KEYMAP_DATA_L` |
| `0x2C` (44) | DAC B Mirror (left) | `REG_DAC_LEFT` |
| `0x2D` (45) | DAC A+D Mirror (mono) | `REG_DAC_MONO` |
| `0x2E` (46) | DAC C Mirror (right) | `REG_DAC_RIGHT` |
| `0x2F` (47) | Tilemap X Scroll MSB | `REG_TILEMAP_OFFSET_X_MSB` |
| `0x30` (48) | Tilemap X Scroll LSB | `REG_TILEMAP_OFFSET_X_LSB` |
| `0x31` (49) | Tilemap Offset Y | `REG_TILEMAP_OFFSET_Y` |
| `0x32` (50) | LoRes X Scroll | `REG_LORES_OFFSET_X` |
| `0x33` (51) | LoRes Y Scroll | `REG_LORES_OFFSET_Y` |
| `0x34` (52) | Sprite Number | `REG_SPRITE_NUMBER` |
| `0x35` (53) | Sprite Attribute 0 | `REG_SPRITE_ATTR_0`<br>`REG_SPRITE_ATTR_X` |
| `0x75` (117) | Sprite Attribute 0 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR_0_INCREMENT`<br>`REG_SPRITE_ATTR_X_INCREMENT` |
| `0x36` (54) | Sprite Attribute 1 | `REG_SPRITE_ATTR_1`<br>`REG_SPRITE_ATTR_Y` |
| `0x76` (118) | Sprite Attribute 1 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR_1_INCREMENT`<br>`REG_SPRITE_ATTR_Y_INCREMENT` |
| `0x37` (55) | Sprite Attribute 2 | `REG_SPRITE_ATTR2` |
| `0x77` (119) | Sprite Attribute 2 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR2_INCREMENT` |
| `0x38` (56) | Sprite Attribute 3 | `REG_SPRITE_ATTR3` |
| `0x78` (120) | Sprite Attribute 3 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR3_INCREMENT` |
| `0x39` (57) | Sprite Attribute 4 | `REG_SPRITE_ATTR4` |
| `0x79` (121) | Sprite Attribute 4 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR4_INCREMENT` |
| `0x40` (64) | Palette Index | `REG_PALETTE_INDEX` |
| `0x41` (65) | Palette Value (8 bit colour) | `REG_PALETTE_VALUE_8` |
| `0x42` (66) | ULANext Attribute Byte Format | `REG_ULANEXT_PALETTE_FORMAT` |
| `0x43` (67) | Palette Control | `REG_PALETTE_CONTROL` |
| `0x44` (68) | Palette Value (9 bit colour) | `REG_PALETTE_VALUE_16` |
| `0x4A` (74) | Fallback Colour | `REG_FALLBACK_COLOR` |
| `0x4B` (75) | Sprite Transparency Index | `REG_SPRITE_TRANSPARENCY_INDEX` |
| `0x4C` (76) | Tilemap Transparency Index | `REG_TILEMAP_TRANSPARENCY_INDEX` |
| `0x50` (80) | MMU slot 0 | `REG_MMU0` |
| `0x51` (81) | MMU slot 1 | `REG_MMU1` |
| `0x52` (82) | MMU slot 2 | `REG_MMU2` |
| `0x53` (83) | MMU slot 3 | `REG_MMU3` |
| `0x54` (84) | MMU slot 4 | `REG_MMU4` |
| `0x55` (85) | MMU slot 5 | `REG_MMU5` |
| `0x56` (86) | MMU slot 6 | `REG_MMU6` |
| `0x57` (87) | MMU slot 7 | `REG_MMU7` |
| `0x60` (96) | Copper Data 8-bit Write | `REG_COPPER_DATA` |
| `0x61` (97) | Copper Address LSB | `REG_COPPER_CONTROL_L` |
| `0x62` (98) | Copper Control | `REG_COPPER_CONTROL_H` |
| `0x63` (99) | Copper Data 16-bit Write | `REG_COPPER_DATA_16` |
| `0x64` (100) | Vertical Line Count Offset | `REG_LINE_INTERRUPT_OFFSET` |
| `0x68` (104) | ULA Control | `REG_ULA_CONTROL` |
| `0x69` (105) | Display Control 1 | `REG_DISPLAY_CONTROL` |
| `0x6A` (106) | LoRes Control | `REG_LORES_CONTROL` |
| `0x6B` (107) | Tilemap Control | `REG_TILEMAP_CONTROL` |
| `0x6C` (108) | Default Tilemap Attribute | `REG_DEFAULT_TILEMAP_ATTRIBUTE` |
| `0x6E` (110) | Tilemap Base Address | `REG_TILEMAP_BASE_ADDRESS` |
| `0x6F` (111) | Tile Definitions Base Address | `REG_TILE_DEFINITIONS_BASE_ADDRESS` |
| `0x70` (112) | Layer 2 Control | `REG_LAYER_2_CONTROL` |
| `0x71` (113) | Layer 2 X Scroll MSB | `REG_LAYER_2_OFFSET_X_MSB` |
| `0x75` (117) | Sprite Attribute 0 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR_0_INCREMENT`<br>`REG_SPRITE_ATTR_X_INCREMENT` |
| `0x76` (118) | Sprite Attribute 1 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR_1_INCREMENT`<br>`REG_SPRITE_ATTR_Y_INCREMENT` |
| `0x77` (119) | Sprite Attribute 2 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR2_INCREMENT` |
| `0x78` (120) | Sprite Attribute 3 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR3_INCREMENT` |
| `0x79` (121) | Sprite Attribute 4 with automatic post increment of Sprite Number | `REG_SPRITE_ATTR4_INCREMENT` |
| `0x7F` (127) | User Register 0 | `REG_USER_0` |
| `0x80` (128) | Expansion Bus Enable | `REG_EXPANSION_BUS_ENABLE` |
| `0x81` (129) | Expansion Bus Control | `REG_EXPANSION_BUS_CONTROL` |
| `0x82`–`0x85` (130–133) | Internal Port Decoding Enables (0x85 is MSB) (soft reset if bit 31 = 1, hard reset if bit 31 = 0 : all 1) | `REG_INTERNAL_PORT_DECODING_0`<br>`REG_INTERNAL_PORT_DECODING_1`<br>`REG_INTERNAL_PORT_DECODING_2`<br>`REG_INTERNAL_PORT_DECODING_3` |
| `0x86`–`0x89` (134–137) | Expansion Bus Decoding Enables (0x89 is MSB) (soft reset if bit 31 = 0, hard reset if bit 31 = 1 : all 1) | `REG_EXPANSION_BUS_DECODING_0`<br>`REG_EXPANSION_BUS_DECODING_1`<br>`REG_EXPANSION_BUS_DECODING_2`<br>`REG_EXPANSION_BUS_DECODING_3` |
| `0x8A` (138) | Expansion Bus IO Propagate | `REG_EXPANSION_BUS_IO_PROPAGATE` |
| `0x8C` (140) | Alternate ROM | `REG_ALTERNATE_ROM` |
| `0x8E` (142) | Spectrum 128K Memory Mapping | `REG_SPECTRUM_128K_MAPPING` |
| `0x8F` (143) | Memory Mapping Mode | `REG_MEMORY_MAPPING_MODE` |
| `0x90`–`0x93` (144–147) | PI GPIO Output Enable (0x93 is MSB) | `REG_PI_GPIO_OUTPUT_ENABLE_0`<br>`REG_PI_GPIO_OUTPUT_ENABLE_1`<br>`REG_PI_GPIO_OUTPUT_ENABLE_2`<br>`REG_PI_GPIO_OUTPUT_ENABLE_3` |
| `0x98`–`0x9B` (152–155) | PI GPIO (0x9B is MSB) | `REG_PI_GPIO_0`<br>`REG_PI_GPIO_1`<br>`REG_PI_GPIO_2`<br>`REG_PI_GPIO_3` |
| `0xA0` (160) | PI Peripheral Enable | `REG_PI_PERIPHERAL_ENABLE` |
| `0xA2` (162) | PI I2S Audio Control | `REG_PI_I2S_AUDIO_CONTROL` |
| `0xA8` (168) | ESP Wifi GPIO Output Enable | `REG_ESP_GPIO_OUTPUT_ENABLE` |
| `0xA9` (169) | ESP Wifi GPIO | `REG_ESP_GPIO` |
| `0xB0` (176) | Extended Keys 0 | `REG_EXTENDED_KEYS_0` |
| `0xB1` (177) | Extended Keys 1 | `REG_EXTENDED_KEYS_1` |
| `0xB2` (178) | Extended MD Pad Buttons | `REG_EXTENDED_MD_PAD_BUTTONS` |
| `0xB8` (184) | Divmmc Entry Points 0 | `REG_DIVMMC_ENTRY_POINTS_0` |
| `0xB9` (185) | Divmmc Entry Points Valid 0 | `REG_DIVMMC_ENTRY_POINTS_VALID_0` |
| `0xBA` (186) | Divmmc Entry Points Timing 0 | `REG_DIVMMC_ENTRY_POINTS_TIMING_0` |
| `0xBB` (187) | Divmmc Entry Points 1 | `REG_DIVMMC_ENTRY_POINTS_1` |
| `0xC0` (192) | Interrupt Control | `REG_INTERRUPT_CONTROL` |
| `0xC2` (194) | NMI Return Address LSB | `REG_NMI_RETURN_ADDRESS_L` |
| `0xC3` (195) | NMI Return Address MSB | `REG_NMI_RETURN_ADDRESS_H` |
| `0xC4` (196) | INT EN 0 | `REG_INTERRUPT_ENABLE_0` |
| `0xC5` (197) | INT EN 1 | `REG_INTERRUPT_ENABLE_1` |
| `0xC6` (198) | INT EN 2 | `REG_INTERRUPT_ENABLE_2` |
| `0xC7` (199) | Reserved, write 0 | _(none)_ |
| `0xC8` (200) | INT Status 0 | `REG_INTERRUPT_STATUS_0` |
| `0xC9` (201) | INT Status 1 | `REG_INTERRUPT_STATUS_1` |
| `0xCA` (202) | INT Status 2 | `REG_INTERRUPT_STATUS_2` |
| `0xCB` (203) | Reserved, write 0xFF | _(none)_ |
| `0xCC` (204) | DMA INT EN 0 | `REG_DMA_INTERRUPT_ENABLE_0` |
| `0xCD` (205) | DMA INT EN 1 | `REG_DMA_INTERRUPT_ENABLE_1` |
| `0xCE` (206) | DMA INT EN 2 | `REG_DMA_INTERRUPT_ENABLE_2` |
| `0xCF` (207) | Reserved, write 0 | _(none)_ |
| `0xD8` (216) | I/O Traps (experimental) | `REG_IO_TRAPS` |
| `0xD9` (217) | I/O Trap Write (experimental) | `REG_IO_TRAP_WRITE` |
| `0xDA` (218) | I/O Trap Cause (experimental) | `REG_IO_TRAP_CAUSE` |
| `0xF0` (240) | XDEV CMD | `REG_XDEV_COMMAND` |
| `0xF8` (248) | XADC REG | `REG_XADC_REGISTER` |
| `0xF9` (249) | XADC D0 | `REG_XADC_DATA_L` |
| `0xFA` (250) | XADC D1 | `REG_XADC_DATA_H` |
| `0xFF` (255) | Reserved for internal use | `REG_DEBUG` |

## Registers in detail

### `0x00` (0) — Machine ID

**`REG_MACHINE_ID`**

```
(R)
  0000 1000 = EMULATORS
//
  0000 1010 = ZX Spectrum Next
  1111 1010 = ZX Spectrum Next Anti-brick
//
  1001 1010 = ZX Spectrum Next Core on UnAmiga Reloaded
  1010 1010 = ZX Spectrum Next Core on UnAmiga
  1011 1010 = ZX Spectrum Next Core on SiDi
  1100 1010 = ZX Spectrum Next Core on MIST
  1101 1010 = ZX Spectrum Next Core on MiSTer
  1110 1010 = ZX Spectrum Next Core on ZX-DOS
```

Value constants:

| Constant | Value |
| --- | --- |
| `RMI_DE1A` | `0x01` |
| `RMI_DE2A` | `0x02` |
| `RMI_EMULATORS` | `0x08` |
| `RMI_FBLABS` | `0x05` |
| `RMI_MULTICORE` | `0x0B` |
| `RMI_VTRUCCO` | `0x06` |
| `RMI_WXEDA` | `0x07` |
| `RMI_ZXNEXT` | `0x0A` |
| `RMI_ZXNEXT_AB` | `0xFA` |

### `0x01` (1) — Core Version

**`REG_VERSION`**

```
(R)
  bits 7:4 = Major version number
  bits 3:0 = Minor version number
  see nextreg 0x0E for sub minor version number
```

Value constants:

| Constant | Value |
| --- | --- |
| `RV_MAJOR` | `0xF0` |
| `RV_MINOR` | `0x0F` |

### `0x02` (2) — Reset

**`REG_RESET`**

```
(R)
  bit 7 = 1 if the reset signal to the expansion bus and esp is asserted
  bits 6:5 = Reserved
  bit 4 = 1 if multiface nmi was generated by an i/o trap (experimental, see nextreg 0xDA)
  bit 3 = 1 if multiface nmi was generated by this nextreg
  bit 2 = 1 if divmmc nmi was generated by this nextreg
  bit 1 = 1 if the last reset was a hard reset *
  bit 0 = 1 if the last reset was a soft reset *
  * Only one of bits 1:0 will be set
(W)
  bit 7 = Assert and hold reset to the expansion bus and the esp wifi (hard reset = 0)
  bits 6:5 = Reserved must be zero
  bit 4 = Clear i/o trap (write zero to clear) (experimental) **
  bit 3 = Generate multiface nmi (write zero to clear) **
  bit 2 = Generate divmmc nmi (write zero to clear) **
  bit 1 = Generate a hard reset (reboot) *
  bit 0 = Generate a soft reset *
  * Hard reset has precedence
  ** These signals are ignored if the multiface, divmmc, dma or external nmi master is active
  ** Copper cannot clear these bits
  ** An i/o trap could occur at the same time as mf / divmmc cause; always check this bit in nmi isr if important
```

Value constants:

| Constant | Value |
| --- | --- |
| `RR_HARD_RESET` | `0x02` |
| `RR_POWER_ON_RESET` | `0x04` |
| `RR_SOFT_RESET` | `0x01` |

### `0x03` (3) — Machine Type

**`REG_MACHINE_TYPE`**

```
(R)
  bit 7 = nextreg 0x44 second byte indicator
  bits 6:4 = Display timing
  bit 3 = User lock on display timing applied
  bits 2-0 = Machine type
(W)
  A write to this register disables the bootrom
  bit 7 = 1 to allow changes to bits 6:4
  bits 6:4 = Selects display timing
    affects port decoding and contention
    000 = Internal Use
    001 = ZX 48K display timing
    010 = ZX 128K/+2 display timing
    011 = ZX +2A/+2B/+3 display timing
    100 = Pentagon display timing (changes to 50 Hz)
  bit 3 = 1 to toggle user lock on display timing (hard reset = 0)
  bits 2:0 = Selects machine type (config mode only)
    determines roms loaded
    000 = Configuration mode
    001 = ZX 48K
    010 = ZX 128K/+2
    011 = ZX +2A/+2B/+3
    100 = Pentagon
```

Value constants:

| Constant | Value |
| --- | --- |
| `RMT_128` | `0x02` |
| `RMT_48` | `0x01` |
| `RMT_CONFIG_MODE` | `0x00` |
| `RMT_LOCK_TIMING` | `0x80` |
| `RMT_P3E` | `0x03` |
| `RMT_PENTAGON` | `0x04` |
| `RMT_TIMING_128` | `0x20` |
| `RMT_TIMING_48` | `0x10` |
| `RMT_TIMING_P3E` | `0x30` |
| `RMT_TIMING_PENTAGON` | `0x40` |

### `0x04` (4) — Config Mapping

**`REG_RAM_PAGE`**

```
config mode only, bootrom disabled
(W)
  bits 7:0 = 16K SRAM bank mapped to 0x0000-0x3FFF (hard reset = 0)
  ** On issue 2 pcbs, even multiplies of 256K are unreliable if storing data in sram for the next core started.
  ** Bit 7 ignored except on issue 5 pcb
```

Value constants:

| Constant | Value |
| --- | --- |
| `RRP_RAM_DIVMMC` | `0x08` |
| `RRP_ROM_DIVMMC` | `0x04` |
| `RRP_ROM_MF` | `0x05` |
| `RRP_ROM_SPECTRUM` | `0x00` |

### `0x05` (5) — Peripheral 1 Setting

**`REG_PERIPHERAL_1`**

```
(R/W)
  bits 7:6 = Joystick 1 mode (LSB)
  bits 5:4 = Joystick 2 mode (LSB)
  bit 3 = Joystick 1 mode (MSB)
  bit 2 = 50/60 Hz mode (0 = 50Hz, 1 = 60Hz, Pentagon forces 50Hz)
  bit 1 = Joystick 2 mode (MSB)
  bit 0 = Enable scandoubler (1 = enabled for vga, 0 for crt)
Joystick modes:
  000 = Sinclair 2 (12345)
  001 = Kempston 1 (port 0x1F)
  010 = Cursor (56780)
  011 = Sinclair 1 (67890)
  100 = Kempston 2 (port 0x37)
  101 = MD 1 (3 or 6 button joystick port 0x1F)
  110 = MD 2 (3 or 6 button joystick port 0x37)
  111 = User Defined Keys Joystick
  * Joysticks can be placed in i/o mode via nextreg 0x0B
  * Programming the user defined keys joystick is done through the ps2 keymap interface
  on nextreg 0x28, nextreg 0x29 and nextreg 0x2B:
  1. Write 128 to nextreg 0x28
  2. Write 0 (left joystick) or 16 (right joystick) to nextreg 0x29
  3. Write twelve bytes to nextreg 0x2B in order. The bytes correspond to the twelve
  buttons on an md pad (MODE=11 X Z Y START A C B U D L R=0)
  4. Each byte written identifies a key in the 8x7 membrane; bits 5:3 select the row
  and bits 2:0 select the column with 111 meaning no action
  * In kempston and md modes, excess buttons on a controller not read via ports will
  generate key input if so programmed
```

Value constants:

| Constant | Value |
| --- | --- |
| `RP1_ENABLE_SCANDOUBLER` | `0x01` |
| `RP1_JOY1_CURSOR` | `0x80` |
| `RP1_JOY1_KEMPSTON` | `0x40` |
| `RP1_JOY1_KEMPSTON_1` | `0x40` |
| `RP1_JOY1_KEMPSTON_2` | `0x08` |
| `RP1_JOY1_MD_1` | `0x48` |
| `RP1_JOY1_MD_2` | `0x88` |
| `RP1_JOY1_SINCLAIR` | `0xC0` |
| `RP1_JOY1_SINCLAIR_1` | `0xC0` |
| `RP1_JOY1_SINCLAIR_2` | `0x00` |
| `RP1_JOY2_CURSOR` | `0x20` |
| `RP1_JOY2_KEMPSTON` | `0x02` |
| `RP1_JOY2_KEMPSTON_1` | `0x10` |
| `RP1_JOY2_KEMPSTON_2` | `0x02` |
| `RP1_JOY2_MD_1` | `0x12` |
| `RP1_JOY2_MD_2` | `0x22` |
| `RP1_JOY2_SINCLAIR` | `0x00` |
| `RP1_JOY2_SINCLAIR_1` | `0x30` |
| `RP1_JOY2_SINCLAIR_2` | `0x00` |
| `RP1_RATE_50` | `0x00` |
| `RP1_RATE_60` | `0x04` |

### `0x06` (6) — Peripheral 2 Setting

**`REG_PERIPHERAL_2`**

```
(R/W)
  bit 7 = Enable F8 cpu speed hotkey and F5/F6 expansion bus hotkeys (soft reset = 1)
  bit 6 = Divert BEEP only to internal speaker (hard reset = 0)
  bit 5 = Enable F3 50/60 Hz hotkey (soft reset = 1)
  bit 4 = Enable divmmc nmi by DRIVE button (hard reset = 0)
  bit 3 = Enable multiface nmi by M1 button (hard reset = 0)
  bit 2 = PS/2 mode (0 = keyboard primary, 1 = mouse primary; config mode only)
  bits 1-0 = Audio chip mode (00 = YM, 01 = AY, 10 = ZXN-8950, 11 = Hold all AY in reset)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RP2_DAC_I2S` | `0x00` |
| `RP2_DAC_JAP` | `0x40` |
| `RP2_ENABLE_DIVMMC` | `0x10` |
| `RP2_ENABLE_LIGHTPEN` | `0x20` |
| `RP2_ENABLE_MULTIFACE` | `0x08` |
| `RP2_ENABLE_TURBO` | `0x80` |
| `RP2_PS2_KEYBOARD` | `0x00` |
| `RP2_PS2_MOUSE` | `0x04` |
| `RP2_PSGMODE_AY` | `0x03` |
| `RP2_PSGMODE_DISABLE` | `0x00` |
| `RP2_PSGMODE_YM` | `0x02` |

### `0x07` (7) — CPU Speed

**`REG_TURBO_MODE`**

```
(R)
  bits 7:6 = Reserved
  bits 5:4 = Current actual cpu speed
  bits 3:2 = Reserved
  bits 1:0 = Programmed cpu speed
(W)
  bits 7:2 = Reserved, must be 0
  bits 1:0 = Set cpu speed (soft reset = 00)
    00 = 3.5 MHz
    01 = 7 MHz
    10 = 14 MHz
    11 = 28 MHz
```

Value constants:

| Constant | Value |
| --- | --- |
| `RTM_14MHZ` | `0x02` |
| `RTM_28MHZ` | `0x03` |
| `RTM_3MHZ` | `0x00` |
| `RTM_7MHZ` | `0x01` |

### `0x08` (8) — Peripheral 3 Setting

**`REG_PERIPHERAL_3`**

```
(R/W)
  bit 7 = Unlock port 0x7ffd (read 1 indicates port 0x7ffd is not locked)
  bit 6 = Disable ram and port contention (soft reset = 0)
  bit 5 = AY stereo mode (0 = ABC, 1 = ACB) (hard reset = 0)
  bit 4 = Enable internal speaker (hard reset = 1)
  bit 3 = Enable 8-bit DACs (A,B,C,D) (hard reset = 0)
  bit 2 = Enable port 0xff Timex video mode read (hides floating bus on 0xff) (hard reset = 0)
  bit 1 = Enable turbosound (currently selected AY is frozen when disabled) (hard reset = 0)
  bit 0 = Implement issue 2 keyboard (hard reset = 0)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RP3_DISABLE_CONTENTION` | `0x40` |
| `RP3_ENABLE_COVOX` | `0x08` |
| `RP3_ENABLE_SPEAKER` | `0x10` |
| `RP3_ENABLE_SPECDRUM` | `0x08` |
| `RP3_ENABLE_TIMEX` | `0x04` |
| `RP3_ENABLE_TURBOSOUND` | `0x02` |
| `RP3_STEREO_ABC` | `0x00` |
| `RP3_STEREO_ACB` | `0x20` |
| `RP3_UNLOCK_7FFD` | `0x80` |

### `0x09` (9) — Peripheral 4 Setting

**`REG_PERIPHERAL_4`**

```
(R/W)
  bit 7 = Place AY 2 in mono mode (hard reset = 0)
  bit 6 = Place AY 1 in mono mode (hard reset = 0)
  bit 5 = Place AY 0 in mono mode (hard reset = 0)
  bit 4 = Sprite id lockstep (nextreg 0x34 and port 0x303B are in lockstep) (soft reset = 0)
  bit 3 = Reset divmmc mapram bit (port 0xe3 bit 6) (read returns 0)
  bit 2 = 1 to silence hdmi audio (hard reset = 0)
  bits 1:0 = Scanline weight
    00 = scanlines off
    01 = scanlines 50%
    10 = scanlines 25%
    11 = scanlines 12.5%
```

Value constants:

| Constant | Value |
| --- | --- |
| `RP4_SCANLINES_25` | `0x03` |
| `RP4_SCANLINES_50` | `0x02` |
| `RP4_SCANLINES_75` | `0x01` |
| `RP4_SCANLINES_OFF` | `0x00` |

### `0x0A` (10) — Peripheral 5 Setting

**`REG_PERIPHERAL_5`**

```
(R/W)
  bit 7:6 = Multiface type (hard reset = 00) (config mode only)
    00 = Multiface +3 (enable port 0x3F, disable port 0xBF)
    01 = Multiface 128 v87.2 (enable port 0xBF, disable port 0x3F)
    10 = Multiface 128 v87.12 (enable port 0x9F, disable port 0x1F)
    11 = Multiface 1 (enable port 0x9F, disable port 0x1F)
  bit 5 = 1 to swap sd0 and sd1 (hard reset = 0) (config mode only) *
  bit 4 = Enable divmmc automap (hard reset = 0)
  bit 3 = 1 to reverse left and right mouse buttons (hard reset = 0)
  bit 2 = Reserved, must be 0
  bits 1:0 = mouse dpi (hard reset = 01)
    00 = low dpi
    01 = default
    10 = medium dpi
    11 = high dpi
  * only affects future writes to port 0xE7
```

Value constants:

| Constant | Value |
| --- | --- |
| `RP5_ENABLE_DIVMMC_AUTOMAP` | `0x10` |
| `RP5_MOUSE_DEFAULT_DPI` | `0x01` |
| `RP5_MOUSE_HIGH_DPI` | `0x03` |
| `RP5_MOUSE_LOW_DPI` | `0x00` |
| `RP5_MOUSE_MEDIUM_DPI` | `0x02` |
| `RP5_MOUSE_REVERSE_BUTTONS` | `0x08` |
| `RP5_MULTIFACE_1` | `0xC0` |
| `RP5_MULTIFACE_128_V87_12` | `0x80` |
| `RP5_MULTIFACE_128_V87_2` | `0x40` |
| `RP5_MULTIFACE_P3` | `0x00` |
| `RP5_SWAP_SD0_SD1` | `0x20` |

### `0x0B` (11) — Joystick I/O Mode

**`REG_JOYSTICK_IO_MODE`**

```
(R/W) (soft reset = 0x01)
  bit 7 = 1 to enable i/o mode
  bit 6 = Reserved, must be 0
  bits 5:4 = I/O Mode
    00 = bit bang
    01 = clock
    10 = uart on left joystick port
    11 = uart on right joystick port
  bits 3:1 = Reserved, must be 0
  bit 0 = Parameter
    bit bang : copied to pin 7
    clock    : 0 = hold high when clock becomes high, 1 = run *
    uart     : 0 = redirect esp uart0 to joystick, 1 = redirect pi uart1 to joystick
               (Tx out on pin 7, Rx in from pin 9, CTS_n in from pin 6 **)
  The state of output pin 7 is stored internally in a register and is retained across changing
  modes and while i/o mode is disabled.  While in i/o mode, keyboard joystick types (Sinclair,
  Cursor, etc) produce no readings but the current state of pins can still be read via the
  Kempston ports.  When leaving i/o mode, joystick operation resumes after ~64 scan lines
  have passed.
  * CTC channel 3 is currently used to drive pin 7 in clock mode.  Freq = Fctc3 / 2.
  ** CTS_n is only active if the seleced uart is in hw flow control mode.
```

Value constants:

| Constant | Value |
| --- | --- |
| `RJIM_ENABLE_IO_MODE` | `0x80` |
| `RJIM_MODE_BIT_BANG` | `0x00` |
| `RJIM_MODE_CLOCK` | `0x10` |
| `RJIM_MODE_UART_LEFT_PORT` | `0x20` |
| `RJIM_MODE_UART_RIGHT_PORT` | `0x30` |
| `RJIM_PARAMETER` | `0x01` |

### `0x0E` (14) — Core Version

**`REG_SUB_VERSION`**

```
Sub-minor number
(R)
  see nextreg 0x01 for the major and minor version number
```

### `0x0F` (15) — Board ID

**`REG_VIDEO_PARAM`**

```
(R)
  bits 7:4 = Reserved, 0
  bits 3:0 = Board ID
    0000 = ZXN Issue 2, XC6SLX16-2FTG256, 128Mbit W25Q128JV, 24bit spi, 64K*8 core size
    0001 = ZXN Issue 3, XC6SLX16-2FTG256, 128Mbit W25Q128JV, 24bit spi, 64K*8 core size
    0010 = ZXN Issue 4, XC7A15T-1CSG324, 256Mbit MX25L25645G, 32bit spi, 64K*34 core size
    0011 = ZXN Issue 5, XC7A35T-2CSG324, 256Mbit MX25L25645G, 32bit spi, 64K*34 core size
```

### `0x10` (16) — Core Boot

**`REG_ANTI_BRICK`**

```
(R)
  bit 7 = Reserved
  bits 6:2 = Cored ID
  bit 1 = Button DRIVE (divmmc) is pressed
  bit 0 = Button M1 (multiface) is pressed
(W)
  bit 7 = Start selected core
  bits 6:5 = Reserved, must be 0
  bits 4:0 = Core ID 0-31 (config mode only) *
  * A write of an out of range core id is ignored; this is the preferred way to determine max id
```

Value constants:

| Constant | Value |
| --- | --- |
| `RAB_BUTTON_DIVMMC` | `0x02` |
| `RAB_BUTTON_MULTIFACE` | `0x01` |
| `RAB_COMMAND_NORMALCORE` | `0x80` |

### `0x11` (17) — Video Timing

**`REG_VIDEO_TIMING`**

```
Writable in config mode only.
(R/W)
  bits 7:3 = Reserved, must be 0
  bits 2:0 = Mode (VGA = 0..6, HDMI = 7)
    000 = Base VGA timing, clk28 = 28000000  \ HDMI compatible
    001 = VGA setting 1, clk28 = 28571429    / HDMI compatible
    010 = VGA setting 2, clk28 = 29464286
    011 = VGA setting 3, clk28 = 30000000
    100 = VGA setting 4, clk28 = 31000000
    101 = VGA setting 5, clk28 = 32000000
    110 = VGA setting 6, clk28 = 33000000
    * 50/60Hz selection depends on bit 2 of nextreg 0x05
```

### `0x12` (18) — Layer 2 Active RAM bank

**`REG_LAYER_2_RAM_PAGE`**

```
(R/W)
  bit 7 = Reserved, must be 0
  bits 6:0 = Starting 16K RAM bank (soft reset = 8)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RL2RP_MASK` | `0x3F` |

### `0x13` (19) — Layer 2 Shadow RAM bank

**`REG_LAYER_2_SHADOW_RAM_PAGE`**

```
(R/W)
  bit 7 = Reserved, must be 0
  bits 6:0 = Starting 16K RAM bank (soft reset = 11)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RL2SRP_MASK` | `0x3F` |

### `0x14` (20) — Global Transparency Colour

**`REG_GLOBAL_TRANSPARENCY_COLOR`**

```
(R/W)
  bits 7:0 = Transparency colour value (soft reset = 0xe3)
  * Note: This value is 8-bit, so the transparency colour is compared against
      the MSB bits of the final 9-bit colour only.
  * Note: This colour only applies to Layer 2, ULA and LoRes.
      Sprites use nextreg 0x4B and the tilemap uses nextreg 0x4C for transparency except in text mode
```

### `0x15` (21) — Sprite and Layers System

**`REG_SPRITE_LAYER_SYSTEM`**

```
(R/W)
  bit 7 = Enable lores mode (soft reset = 0)
  bit 6 = Sprite priority (1 = sprite 0 on top, 0 = sprite 127 on top) (soft reset = 0)
  bit 5 = Enable sprite clipping in over border mode (soft reset = 0)
  bits 4:2 = Set layer priority (eg SLU = sprites over layer 2 over ula) (soft reset = 000)
    000 - S L U
    001 - L S U
    010 - S U L
    011 - L U S
    100 - U S L
    101 - U L S
    110 - (U|T)S(T|U)(B+L) Blending layer and Layer 2 combined, colours clamped to [0,7]
    111 - (U|T)S(T|U)(B+L-5) Blending layer and Layer 2 combined, colours clamped to [0,7]
  bit 1 = Enable sprites over border (soft reset = 0)
  bit 0 = Enable sprites (soft reset = 0)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RSLS_ENABLE_LORES` | `0x80` |
| `RSLS_ENABLE_SPRITES_CLIPING_OVER_BORDER` | `0x20` |
| `RSLS_LAYER_PRIORITY_LSU` | `0x04` |
| `RSLS_LAYER_PRIORITY_LUS` | `0x0C` |
| `RSLS_LAYER_PRIORITY_SLU` | `0x00` |
| `RSLS_LAYER_PRIORITY_SUL` | `0x08` |
| `RSLS_LAYER_PRIORITY_ULS` | `0x14` |
| `RSLS_LAYER_PRIORITY_USL` | `0x10` |
| `RSLS_SPRITES_OVER_BORDER` | `0x02` |
| `RSLS_SPRITES_VISIBLE` | `0x01` |

### `0x16` (22) — Layer 2 X Scroll LSB

**`REG_LAYER_2_OFFSET_X`**

```
(R/W)
  bits 7:0 = X Offset (0-255) (soft reset = 0)
```

### `0x17` (23) — Layer 2 Y Scroll

**`REG_LAYER_2_OFFSET_Y`**

```
(R/W)
  bits 7:0 = Y Offset (limited to 0-191 when vertical resolution is 192 pixels) (soft reset = 0)
```

### `0x18` (24) — Clip Window Layer 2

**`REG_CLIP_WINDOW_LAYER_2`**

```
(R/W)
  bits 7:0 = Clip window coordinate (inclusive)
  1st write - X1 position (soft reset = 0)
  2nd write - X2 position (soft reset = 255)
  3rd write - Y1 position (soft reset = 0)
  4rd write - Y2 position (soft reset = 191)
  Reads do not advance the clip position
```

### `0x19` (25) — Clip Window Sprites

**`REG_CLIP_WINDOW_SPRITES`**

```
(R/W)
  bits 7:0 = Clip window coordinate (inclusive)
  1st write - X1 position (soft reset  = 0)
  2nd write - X2 position (soft reset = 255)
  3rd write - Y1 position (soft reset = 0)
  4rd write - Y2 position (soft reset = 191)
  Reads do not advance the clip position
  When the clip window is enabled for sprites in "over border" mode,
  the X coords are internally doubled and the clip window origin is
  moved to the sprite origin inside the border.
```

### `0x1A` (26) — Clip Window ULA/LoRes

**`REG_CLIP_WINDOW_ULA`**

```
(R/W)
  bits 7:0 = Clip window coordinate (inclusive) *
  1st write = X1 position (soft reset = 0)
  2nd write = X2 position (soft reset = 255)
  3rd write = Y1 position (soft reset = 0)
  4rd write = Y2 position (soft reset = 191)
  Reads do not advance the clip position
  * LoRes may get a separate clip window in the future
```

### `0x1B` (27) — Clip Window Tilemap

**`REG_CLIP_WINDOW_TILEMAP`**

```
(R/W)
  bits 7:0 = Clip window coordinate (inclusive)
  1st write = X1 position (soft reset = 0)
  2nd write = X2 position (soft reset = 159)
  3rd write = Y1 position (soft reset = 0)
  4rd write = Y2 position (soft reset = 255)
  Reads do not advance the clip position
  The X coordinates are internally doubled.
```

### `0x1C` (28) — Clip Window Control

**`REG_CLIP_WINDOW_CONTROL`**

```
(R) (may change)
  bits 7:6 = Tilemap clip index
  bits 5:4 = ULA/Lores clip index
  bits 3:2 = Sprite clip index
  bits 1:0 = Layer 2 clip index
(W) (may change)
  bits 7:4 = Reserved, must be 0
  bit 3 = Reset the tilemap clip index
  bit 2 = Reset the ULA/LoRes clip index
  bit 1 = Reset the sprite clip index
  bit 0 = Reset the Layer 2 clip index
```

Value constants:

| Constant | Value |
| --- | --- |
| `RCWC_RESET_LAYER_2_CLIP_INDEX` | `0x01` |
| `RCWC_RESET_SPRITE_CLIP_INDEX` | `0x02` |
| `RCWC_RESET_TILEMAP_CLIP_INDEX` | `0x08` |
| `RCWC_RESET_ULA_CLIP_INDEX` | `0x04` |

### `0x1E` (30) — Active Video Line (MSB)

**`REG_ACTIVE_VIDEO_LINE_H`**

```
(R)
  bits 7:1 = Reserved
  bit 0 = Active line MSB
```

### `0x1F` (31) — Active Video Line (LSB)

**`REG_ACTIVE_VIDEO_LINE_L`**

```
(R)
  bits 7:0 = Active line LSB
```

### `0x20` (32) — Generate Maskable Interrupt

**`REG_GENERATE_MASKABLE_INTERRUPT`**

```
(R/W)
  bit 7 = line
  bit 6 = ula
  bits 5:4 = reserved
  bits 3:0 = ctc 3:0
  * Set bits on R indicate whether an interrupt occurred or is pending (alias of bits in NR 0xC8 - 0xCA)
  * Set bits on W always generate a maskable interrupt ignoring enables (NR 0xC4 - 0xC6)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RGMI_CTC_CHANNEL_0` | `0x01` |
| `RGMI_CTC_CHANNEL_1` | `0x02` |
| `RGMI_CTC_CHANNEL_2` | `0x04` |
| `RGMI_CTC_CHANNEL_3` | `0x08` |
| `RGMI_LINE` | `0x80` |
| `RGMI_ULA` | `0x40` |

### `0x22` (34) — Line Interrupt control

**`REG_LINE_INTERRUPT_CONTROL`**

```
(R/W)
  bit 7 = (R) Indicates if the ula is asserting an interrupt (even if disabled)
  bits 7:3 = Reserved, must be 0
  bit 2 = Disables ula interrupt (soft reset = 0) **
  bit 1 = Enables line Interrupt (soft reset = 0) **
  bit 0 = MSB of line interrupt value (soft reset = 0)
  ** Aliases of interrupt enable bits in nextreg 0xC4
```

Value constants:

| Constant | Value |
| --- | --- |
| `RLIC_DISABLE_ULA_INTERRUPT` | `0x04` |
| `RLIC_ENABLE_LINE_INTERRUPT` | `0x02` |
| `RLIC_INTERRUPT_FLAG` | `0x80` |
| `RLIC_LINE_INTERRUPT_VALUE_H` | `0x01` |

### `0x23` (35) — Line Interrupt Value LSB

**`REG_LINE_INTERRUPT_VALUE_L`**

```
(R/W)
  bits 7:0 = Line Interrupt value LSB (soft reset = 0)
```

### `0x24` (36) — Reserved

_No z88dk constant._

```
  Protection against "OUT (0x3B),A", see Disciple Disk Interface for example
  In legacy modes set selected nextreg to 0x24
```

### `0x26` (38) — ULA X Scroll

**`REG_ULA_OFFSET_X`**

```
(R/W)
  bits 7:0 = X Offset (0-255) (soft reset = 0)
```

### `0x27` (39) — ULA Y Scroll

**`REG_ULA_OFFSET_Y`**

```
(R/W)
  bits 7:0 = Y Offset (0-191) (soft reset = 0)
```

### `0x28` (40) — PS/2 Keymap Address MSB

**`REG_KEYMAP_ADDRESS_H`**

```
(R)
  bits 7:0 = Stored palette value from nextreg 0x44
(W)
  bit 7 = 0 to select ps2 keymap, 1 to select key joystick
  bits 6:1 = Reserved, must be 0
  bit 0 = MSB address
```

### `0x29` (41) — PS/2 Keymap Address LSB

**`REG_KEYMAP_ADDRESS_L`**

```
(W)
  bits 7:0 = LSB adress
```

### `0x2A` (42) — PS/2 Keymap Data MSB

**`REG_KEYMAP_DATA_H`**

```
(W)
  bits 7:1 = Reserved, must be 0
  bit 0 = MSB data
  * Not currently used by hardware, write 0
```

### `0x2B` (43) — PS/2 Keymap Data LSB

**`REG_KEYMAP_DATA_L`**

```
(W) (write causes the data to be written and auto-increments the keymap address)
  bits 7:0 = LSB data
```

### `0x2C` (44) — DAC B Mirror (left)

**`REG_DAC_LEFT`**

```
(R)
  bits 7:0 = MSB of current I2S (pi) left side sample
             the LSB is latched and can be read from nextreg 0x2D later
(W)
  bits 7:0 = 8-bit sample written to left side DAC B (soft reset = 0x80)
```

### `0x2D` (45) — DAC A+D Mirror (mono)

**`REG_DAC_MONO`**

```
(R)
  bits 7:0 = LSB of last I2S (pi) sample read from nextreg 0x2C or nextreg 0x2E
(W)
  bits 7:0 = 8-bit sample written to DACs A and D (soft reset = 0x80)
```

### `0x2E` (46) — DAC C Mirror (right)

**`REG_DAC_RIGHT`**

```
(R)
  bits 7:0 = MSB of current I2S (pi) right side sample
             the LSB is latched and can be read from nextreg 0x2D later
(W)
  bits 7:0 = 8-bit sample written to right side DAC C (soft reset = 0x80)
```

### `0x2F` (47) — Tilemap X Scroll MSB

**`REG_TILEMAP_OFFSET_X_MSB`**

```
(R/W)
  bits 7:2 = Reserved, must be 0
  bits 1:0 = MSB X Offset (soft reset = 0)
  Meaningful Range is 0-319 in 40 char mode, 0-639 in 80 char mode
```

### `0x30` (48) — Tilemap X Scroll LSB

**`REG_TILEMAP_OFFSET_X_LSB`**

```
(R/W)
  bits 7:0 = LSB X Offset (soft reset = 0)
  Meaningful range is 0-319 in 40 char mode, 0-639 in 80 char mode
```

### `0x31` (49) — Tilemap Offset Y

**`REG_TILEMAP_OFFSET_Y`**

```
(R/W)
  bits 7:0 = Y Offset (0-255) (soft reset = 0)
```

### `0x32` (50) — LoRes X Scroll

**`REG_LORES_OFFSET_X`**

```
(R/W)
  bits 7:0 = X Offset (0-255) (soft reset = 0)
  LoRes scrolls in "half-pixels" at the same resolution and smoothness as Layer 2.
```

### `0x33` (51) — LoRes Y Scroll

**`REG_LORES_OFFSET_Y`**

```
(R/W)
  bits 7:0 = Y Offset (0-191) (soft reset = 0)
  LoRes scrolls in "half-pixels" at the same resolution and smoothness as Layer 2.
```

### `0x34` (52) — Sprite Number

**`REG_SPRITE_NUMBER`**

```
(R/W)
  If the sprite number is in lockstep with port 0x303B (nextreg 0x09 bit 4 is set)
    bit 7 = Pattern address offset (add 128 to pattern address)
    bits 6:0 = Sprite number 0-127, Pattern number 0-63
    Selects which sprite has its attributes connected to the following registers.
    Effectively performs an out to port 0x303B with the same value
  Otherwise
    bit 7 = Ignored
    bits 6:0 = Sprite number 0-127
    Selects which sprite has its attributes connected to the following registers.
  Bit 7 always reads back as zero.
```

### `0x35` (53) — Sprite Attribute 0

**`REG_SPRITE_ATTR_0`**

**`REG_SPRITE_ATTR_X`**

### `0x75` (117) — Sprite Attribute 0 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR_0_INCREMENT`**

**`REG_SPRITE_ATTR_X_INCREMENT`**

```
(W)
  See documentation at https://www.specnext.com/sprites/
```

### `0x36` (54) — Sprite Attribute 1

**`REG_SPRITE_ATTR_1`**

**`REG_SPRITE_ATTR_Y`**

### `0x76` (118) — Sprite Attribute 1 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR_1_INCREMENT`**

**`REG_SPRITE_ATTR_Y_INCREMENT`**

```
(W)
  See documentation at https://www.specnext.com/sprites/
```

### `0x37` (55) — Sprite Attribute 2

**`REG_SPRITE_ATTR2`**

Value constants:

| Constant | Value |
| --- | --- |
| `RSA2_ENABLE_X_MIRRORING` | `0x08` |
| `RSA2_ENABLE_Y_MIRRORING` | `0x04` |
| `RSA2_RELATIVE_ANCHOR_PALETTE` | `0x01` |
| `RSA2_ROTATE_CLOCKWISE` | `0x02` |

### `0x77` (119) — Sprite Attribute 2 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR2_INCREMENT`**

```
(W)
  See documentation at https://www.specnext.com/sprites/
```

### `0x38` (56) — Sprite Attribute 3

**`REG_SPRITE_ATTR3`**

Value constants:

| Constant | Value |
| --- | --- |
| `RSA3_USE_BYTE_4` | `0x40` |
| `RSA3_VISIBLE` | `0x80` |

### `0x78` (120) — Sprite Attribute 3 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR3_INCREMENT`**

```
(W)
  See documentation at https://www.specnext.com/sprites/
```

### `0x39` (57) — Sprite Attribute 4

**`REG_SPRITE_ATTR4`**

Value constants:

| Constant | Value |
| --- | --- |
| `RSA4_ANCHOR_COMPOSITE` | `0x00` |
| `RSA4_ANCHOR_SPRITE_4BIT_0_127_PATTERN` | `0x80` |
| `RSA4_ANCHOR_SPRITE_4BIT_128_255_PATTERN` | `0xC0` |
| `RSA4_ANCHOR_SPRITE_8BIT` | `0x00` |
| `RSA4_ANCHOR_UNIFIED` | `0x20` |
| `RSA4_RELATIVE_ANCHOR_PATTERN` | `0x01` |
| `RSA4_RELATIVE_SPRITE` | `0x40` |
| `RSA4_X_SCALE_2X` | `0x08` |
| `RSA4_X_SCALE_4X` | `0x10` |
| `RSA4_X_SCALE_8X` | `0x18` |
| `RSA4_Y_SCALE_2X` | `0x04` |
| `RSA4_Y_SCALE_4X` | `0x02` |
| `RSA4_Y_SCALE_8X` | `0x06` |

### `0x79` (121) — Sprite Attribute 4 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR4_INCREMENT`**

```
(W)
  See documentation at https://www.specnext.com/sprites/
```

### `0x40` (64) — Palette Index

**`REG_PALETTE_INDEX`**

```
(R/W)
  bits 7:0 = Select the palette index to change the associated colour. (soft reset = 0)
  For the ULA only, INKs are mapped to indices 0-7, Bright INKS to indices 8-15,
   PAPERs to indices 16-23 and Bright PAPERs to indices 24-31.
  In ULANext mode, INKs come from a subset of indices 0-127 and PAPERs come from
   a subset of indices 128-255.  The number of active indices depends on the number
   of attribute bits assigned to INK and PAPER out of the attribute byte.
  In ULA+ mode, the top 64 entries hold the ula+ palette.
  The ULA always takes border colour from paper for standard ULA and ULAnext.
```

### `0x41` (65) — Palette Value (8 bit colour)

**`REG_PALETTE_VALUE_8`**

```
(R/W)
  bits 7:0 = Colour for the palette index selected by nextreg 0x40.
    The format is RRRGGGBB -  the lower blue bit of the 9-bit colour will be the logical
    OR of blue bits 1 and 0 of this 8-bit value.
    After the write, the palette index is auto-incremented to the next index if the
    auto-increment is enabled in nextreg 0x43.  Reads do not auto-increment.
    Any other bits associated with the index will be zeroed.
```

### `0x42` (66) — ULANext Attribute Byte Format

**`REG_ULANEXT_PALETTE_FORMAT`**

```
(R/W)
  bits 7:0 = Mask indicating which bits of an attribute byte are used to represent INK.
    Other bits represent PAPER. (soft reset = 0x07)
    The mask can only indicate a solid sequence of bits on the right side of an attribute
    byte (1, 3, 7, 15, 31, 63, 127 or 255).
    INKs are mapped to base index 0 in the palette and PAPERs and border are
    mapped to base index 128 in the palette.
    The 255 value enables the full ink colour mode making all the palette entries INK.
    In this case PAPER and border are both taken from the fallback colour in nextreg 0x4A.
    If the mask is not one of those listed above, the INK is taken as the logical AND of
    the mask with the attribute byte and the PAPER and border colour are again both taken
    from the fallback colour in nextreg 0x4A.
```

### `0x43` (67) — Palette Control

**`REG_PALETTE_CONTROL`**

```
(R/W)
  bit 7 = Disable palette write auto-increment (soft reset = 0)
  bits 6-4 = Select palette for reading or writing (soft reset = 000)
    000 = ULA first palette
    100 = ULA second palette
    001 = Layer 2 first palette
    101 = Layer 2 second palette
    010 = Sprites first palette
    110 = Sprites second palette
    011 = Tilemap first palette
    111 = Tilemap second palette
  bit 3 = Select Sprites palette (0 = first palette, 1 = second palette) (soft reset = 0)
  bit 2 = Select Layer 2 palette (0 = first palette, 1 = second palette) (soft reset = 0)
  bit 1 = Select ULA palette (0 = first palette, 1 = second palette) (soft reset = 0)
  bit 0 = Enabe ULANext mode (soft reset = 0)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RPC_DISABLE_AUTOINC` | `0x80` |
| `RPC_ENABLE_LAYER_2_PALETTE_0` | `0x00` |
| `RPC_ENABLE_LAYER_2_PALETTE_1` | `0x04` |
| `RPC_ENABLE_SPRITES_PALETTE_0` | `0x00` |
| `RPC_ENABLE_SPRITES_PALETTE_1` | `0x08` |
| `RPC_ENABLE_ULANEXT` | `0x01` |
| `RPC_ENABLE_ULA_PALETTE_0` | `0x00` |
| `RPC_ENABLE_ULA_PALETTE_1` | `0x02` |
| `RPC_SELECT_LAYER_2_PALETTE_0` | `0x10` |
| `RPC_SELECT_LAYER_2_PALETTE_1` | `0x50` |
| `RPC_SELECT_SPRITES_PALETTE_0` | `0x20` |
| `RPC_SELECT_SPRITES_PALETTE_1` | `0x60` |
| `RPC_SELECT_TILEMAP_PALETTE_0` | `0x30` |
| `RPC_SELECT_TILEMAP_PALETTE_1` | `0x70` |
| `RPC_SELECT_ULA_PALETTE_0` | `0x00` |
| `RPC_SELECT_ULA_PALETTE_1` | `0x40` |

### `0x44` (68) — Palette Value (9 bit colour)

**`REG_PALETTE_VALUE_16`**

```
(R/W)
  Two consecutive writes are needed to write the 9 bit colour
  1st write:
    bits 7:0 = RRRGGGBB
  2nd write:
    bits 7:1 = Reserved, must be 0
    bit 0 = lsb B
    If writing to an L2 palette
    bit 7 = 1 for L2 priority colour, 0 for normal.
      An L2 priority colour moves L2 above all layers.  If you need the same
      colour in both priority and normal modes, you will need to have two
      different entries with the same colour one with and one without priority.
  After two consecutive writes the palette index is auto-incremented if
  auto-increment is enabled in nextreg 0x43.
  Reads only return the 2nd byte and do not auto-increment.
  Writes to nextreg 0x40, 0x41, 0x43 reset to the 1st write.
```

### `0x4A` (74) — Fallback Colour

**`REG_FALLBACK_COLOR`**

```
(R/W)
  bits 7:0 = 8-bit colour used if all layers are transparent (soft reset = 0xe3)
```

### `0x4B` (75) — Sprite Transparency Index

**`REG_SPRITE_TRANSPARENCY_INDEX`**

```
(R/W)
  bits 7:0 = Sprite colour index treated as transparent (soft reset = 0xe3)
  For 4-bit sprites only the bottom 4-bits are used
```

### `0x4C` (76) — Tilemap Transparency Index

**`REG_TILEMAP_TRANSPARENCY_INDEX`**

```
(R/W)
  bits 7-4 = Reserved, must be 0
  bits 3-0 = Tilemap colour index treated as transparent (soft reset = 0xf)
```

### `0x50` (80) — MMU slot 0

**`REG_MMU0`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0x0000 - 0x1FFF (soft reset = 255)
  Pages range from 0 to 223 on a fully expanded Next.
  A 255 value causes the ROM to become visible.
```

### `0x51` (81) — MMU slot 1

**`REG_MMU1`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0x2000 - 0x3FFF (soft reset = 255)
  Pages range from 0 to 223 on a fully expanded Next.
  A 255 value causes the ROM to become visible.
```

### `0x52` (82) — MMU slot 2

**`REG_MMU2`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0x4000 - 0x5FFF (soft reset = 10)
  Pages range from 0 to 223 on a fully expanded Next.
```

### `0x53` (83) — MMU slot 3

**`REG_MMU3`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0x6000 - 0x7FFF (soft reset = 11)
  Pages range from 0 to 223 on a fully expanded Next.
```

### `0x54` (84) — MMU slot 4

**`REG_MMU4`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0x8000 - 0x9FFF (soft reset = 4)
  Pages range from 0 to 223 on a fully expanded Next.
```

### `0x55` (85) — MMU slot 5

**`REG_MMU5`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0xA000 - 0xBFFF (soft reset = 5)
  Pages range from 0 to 223 on a fully expanded Next.
```

### `0x56` (86) — MMU slot 6

**`REG_MMU6`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0xC000 - 0xDFFF (soft reset = 0)
  Pages range from 0 to 223 on a fully expanded Next.
```

### `0x57` (87) — MMU slot 7

**`REG_MMU7`**

```
(R/W)
  bits 7:0 = 8K RAM page occupying address 0xE000 - 0xFFFF (soft reset = 1)
  Pages range from 0 to 223 on a fully expanded Next.
```

### `0x60` (96) — Copper Data 8-bit Write

**`REG_COPPER_DATA`**

```
(W)
  bits 7:0 = Byte to write to copper instruction memory
  Note that each copper instruction is two bytes long
  After a write, the copper address is auto-incremented to the next memory position
```

### `0x61` (97) — Copper Address LSB

**`REG_COPPER_CONTROL_L`**

```
(R/W)
  bits 7:0 = Copper instruction memory address LSB (soft reset = 0)
  (Copper addresses range over 0 - 0x7FF = 2K)
```

### `0x62` (98) — Copper Control

**`REG_COPPER_CONTROL_H`**

```
(R/W)
  bits 7:6 = Start control (soft reset = 00)
    00 = Copper fully stopped
    01 = Copper start, execute the list from index 0, and loop to the start
    10 = Copper start, execute the list from last point, and loop to the start
    11 = Copper start, execute the list from index 0, and restart the list
         when the raster reaches position (0,0)
  bits 2:0 = Copper instruction memory address MSB (soft reset = 0)
  (Copper addresses range over 0 - 0x7FF = 2K)
  Writing the same start control value does not reset the copper
```

Value constants:

| Constant | Value |
| --- | --- |
| `RCCH_COPPER_RUN_LOOP` | `0x80` |
| `RCCH_COPPER_RUN_LOOP_RESET` | `0x40` |
| `RCCH_COPPER_RUN_VBI` | `0xC0` |
| `RCCH_COPPER_STOP` | `0x00` |

### `0x63` (99) — Copper Data 16-bit Write

**`REG_COPPER_DATA_16`**

```
(W)
  The 16-bit value is written in pairs.  The first 8-bits are the MSB and
  are destined for an even copper instruction address.  The second 8-bits are
  the LSB and are destined for an odd copper instruction address.
  After each write, the copper address is auto-incremented to the next memory position
  After a write to an odd address, the entire 16-bits is written to copper memory at once
```

### `0x64` (100) — Vertical Line Count Offset

**`REG_LINE_INTERRUPT_OFFSET`**

```
(R/W)
  bits 7:0 = Offset added to the vertical line counter affects copper, line interrupt and active line count.
  Normally the ula's pixel row 0 aligns with vertical line count 0.  With a non-zero
  offset, the ula's pixel row 0 will align with the vertical line offset.  Eg, if the offset is 32
  then vertical line 32 will correspond to the first pixel row in the ula and vertical line 0
  will align with the first pixel row of the tilemap and sprites.
  * Since a change in offset takes effect when the ula reaches row 0, the change can take up to
  one frame to occur.
```

### `0x68` (104) — ULA Control

**`REG_ULA_CONTROL`**

```
(R/W)
  bit 7 = Disable ULA output (soft reset = 0)
  bits 6:5 = Blending in SLU modes 6 & 7 (soft reset = 0)
           = 00 for ula as blend colour
           = 10 for ula/tilemap mix result as blend colour
           = 11 for tilemap as blend colour
           = 01 for no blending
  bit 4 = Cancel entries in 8x5 matrix for extended keys
  bit 3 = ULA+ enable (soft reset = 0)
  bit 2 = ULA half pixel scroll (may change) (soft reset = 0)
  bit 1 = Reserved, must be 0
  bit 0 = Enable stencil mode when both the ULA and tilemap are enabled (soft reset = 0)
  (if either are transparent the result is transparent otherwise the result is a logical AND of both colours)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RUC_CANCEL_EXTENDED_KEYS_IN_MATRIX` | `0x10` |
| `RUC_DISABLE_ULA_OUTPUT` | `0x80` |
| `RUC_ENABLE_STENCIL_MODE` | `0x01` |
| `RUC_ENABLE_ULA_PLUS` | `0x08` |
| `RUC_HALF_PIXEL_SCROLL` | `0x04` |
| `RUC_NO_BLENDING` | `0x20` |
| `RUC_TILEMAP_AS_BLEND_COLOR` | `0x60` |
| `RUC_ULA_AS_BLEND_COLOR` | `0x00` |
| `RUC_ULA_TILEMAP_MIX_AS_BLEND_COLOR` | `0x40` |

### `0x69` (105) — Display Control 1

**`REG_DISPLAY_CONTROL`**

```
(R/W)
  bit 7 = Enable layer 2 (alias port 0x123B bit 1)
  bit 6 = Enable ULA shadow display (alias port 0x7FFD bit 3)
  bits 5:0 = Port 0xFF bits 5:0 alias (Timex display modes)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RDC_ENABLE_LAYER_2` | `0x80` |
| `RDC_ENABLE_ULA_SHADOW_DISPLAY` | `0x40` |
| `RDC_TIMEX_DISPLAY_MODE_MASK` | `0x3F` |

### `0x6A` (106) — LoRes Control

**`REG_LORES_CONTROL`**

```
(R/W)
  bits 7-6 = Reserved, must be 0
  bit 5 = LoRes is Radastan mode (128x96x4, 6144 bytes) (soft reset = 0)
  bit 4 = LoRes Radastan timex display file xor (soft reset = 0)
  bits 3:0 = LoRes palette offset (bits 1:0 apply in ula+ mode) (soft reset = 0)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RLC_PALETTE_OFFSET_MASK` | `0x0F` |
| `RLC_RADASTAN_MODE` | `0x20` |
| `RLC_RADASTAN_TIMEX_XOR` | `0x10` |

### `0x6B` (107) — Tilemap Control

**`REG_TILEMAP_CONTROL`**

```
(R/W)
  bit 7 = 1 Enable the tilemap (soft reset = 0)
  bit 6 = 0 for 40x32, 1 for 80x32 (soft reset = 0)
  bit 5 = Eliminate the attribute entry in the tilemap (soft reset = 0)
  bit 4 = Palette select (soft reset = 0)
  bit 3 = Select textmode (soft reset = 0)
  bit 2 = Reserved, must be 0
  bit 1 = Activate 512 tile mode (soft reset = 0)
  bit 0 = Force tilemap on top of ULA (soft reset = 0)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RTC_ACTIVATE_512_TILE_MODE` | `0x02` |
| `RTC_ACTIVATE_TEXT_MODE` | `0x08` |
| `RTC_ELIMINATE_ATTRIBUTE_BYTE` | `0x20` |
| `RTC_ENABLE_TILEMAP` | `0x80` |
| `RTC_FORCE_TILEMAP_OVER_ULA` | `0x01` |
| `RTC_SELECT_PALETTE_0` | `0x00` |
| `RTC_SELECT_PALETTE_1` | `0x10` |

### `0x6C` (108) — Default Tilemap Attribute

**`REG_DEFAULT_TILEMAP_ATTRIBUTE`**

```
(R/W)
  Active if nextreg 0x6B bit 5 is set
  bits 7:4 = Palette offset (soft reset = 0)
  bit 3 = X mirror (soft reset = 0)
  bit 2 = Y mirror (soft reset = 0)
  bit 1 = Rotate (soft reset = 0)
  bit 0 = ULA over tilemap (soft reset = 0)
          (or bit 8 of the tile number if 512 tile mode is enabled)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RDTA_PALETTE_OFFSET_MASK` | `0xF0` |
| `RDTA_ROTATE` | `0x02` |
| `RDTA_TILE_INDEX_BIT_8` | `0x01` |
| `RDTA_ULA_OVER_TILEMAP` | `0x01` |
| `RDTA_X_MIRROR` | `0x08` |
| `RDTA_Y_MIRROR` | `0x04` |

### `0x6E` (110) — Tilemap Base Address

**`REG_TILEMAP_BASE_ADDRESS`**

```
(R/W) (soft reset = 0x6c00)
  bit 7 = 1 to select bank 7, 0 to select bank 5
  bit 6 = Reserved, must be 0
  bits 5:0 = MSB of address of the tilemap in Bank 5
  The value written into bits 5:0 is an offset into 16K bank 5 or 8K bank 7
  allowing the tilemap to be placed at any multiple of 256 bytes. The value
  written here can be thought of as the MSB of an address in bank 5 0x40-0x7f
  or bank 7 0xc0-0xff. Because bank 7 is only 8K in size, addresses wrap
  across the 8K boundary instead of the 16K boundary.
```

Value constants:

| Constant | Value |
| --- | --- |
| `RTBA_OFFSET_MASK` | `0x3F` |
| `RTBA_SELECT_BANK_7` | `0x80` |

### `0x6F` (111) — Tile Definitions Base Address

**`REG_TILE_DEFINITIONS_BASE_ADDRESS`**

```
(R/W) (soft reset = 0x4c00)
  bit 7 = 1 to select bank 7, 0 to select bank 5
  bit 6 = Reserved, must be 0
  bits 5:0 = MSB of address of tile definitions in Bank 5
  The value written into bits 5:0 is an offset into 16K bank 5 or 8K bank 7
  allowing the tile definitions to be placed at any multiple of 256 bytes. The
  value written here can be thought of as the MSB of an address in bank 5
  0x40-0x7f or bank 7 0xc0-0xff. Because bank 7 is only 8K in size, addresses
  wrap across the 8K boundary instead of the 16K boundary.
```

Value constants:

| Constant | Value |
| --- | --- |
| `RTDBA_OFFSET_MASK` | `0x3F` |
| `RTDBA_SELECT_BANK_7` | `0x80` |

### `0x70` (112) — Layer 2 Control

**`REG_LAYER_2_CONTROL`**

```
(R/W)
  bits 7:6 = Reserved, must be 0
  bits 5:4 = Layer 2 resolution (soft reset = 0)
    00 = 256x192x8
    01 = 320x256x8
    10 = 640x256x4
  bits 3:0 = Palette offset (soft reset = 0)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RL2C_PALETTE_OFFSET_MASK` | `0x0F` |

### `0x71` (113) — Layer 2 X Scroll MSB

**`REG_LAYER_2_OFFSET_X_MSB`**

```
(R/W)
   bits 7:1 = Reserved, must be 0
   bit 0 = MSB of scroll amount
```

### `0x75` (117) — Sprite Attribute 0 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR_0_INCREMENT`**

**`REG_SPRITE_ATTR_X_INCREMENT`**

```
(W)
  see nextreg 0x35
```

### `0x76` (118) — Sprite Attribute 1 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR_1_INCREMENT`**

**`REG_SPRITE_ATTR_Y_INCREMENT`**

```
(W)
  see nextreg 0x36
```

### `0x77` (119) — Sprite Attribute 2 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR2_INCREMENT`**

```
(W)
  see nextreg 0x37
```

### `0x78` (120) — Sprite Attribute 3 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR3_INCREMENT`**

```
(W)
  see nextreg 0x38
```

### `0x79` (121) — Sprite Attribute 4 with automatic post increment of Sprite Number

**`REG_SPRITE_ATTR4_INCREMENT`**

```
(W)
  see nextreg 0x39
```

### `0x7F` (127) — User Register 0

**`REG_USER_0`**

```
(R/W)
  bits 7:0 = Unused storage available to the user (soft reset = 0xff)

// NEXTREG 0x80 AND HIGHER ARE INACCESSIBLE TO THE COPPER
```

### `0x80` (128) — Expansion Bus Enable

**`REG_EXPANSION_BUS_ENABLE`**

```
(R/W) (hard reset = 0)
  IMMEDIATE
  bit 7 = 1 to enable the expansion bus
  bit 6 = 1 to enable romcs rom replacement from divmmc banks 14/15
  bit 5 = 1 to disable i/o cycles & ignore iorqula
  bit 4 = 1 to disable memory cycles & ignore romcs
  AFTER SOFT RESET (copied into bits 7-4)
  bit 3 = 1 to enable the expansion bus
  bit 2 = 1 to enable romcs rom replacement from divmmc banks 14/15
  bit 1 = 1 to disable i/o cycles & ignore iorqula
  bit 0 = 1 to disable memory cycles & ignore romcs
```

Value constants:

| Constant | Value |
| --- | --- |
| `REBE_DISABLE_IO_CYCLES` | `0x20` |
| `REBE_DISABLE_IO_CYCLES_ON_SOFT_RESET` | `0x02` |
| `REBE_DISABLE_MEMORY_CYCLES` | `0x10` |
| `REBE_DISABLE_MEMORY_CYCLES_ON_SOFT_RESET` | `0x01` |
| `REBE_ENABLE` | `0x80` |
| `REBE_ENABLE_ON_SOFT_RESET` | `0x08` |
| `REBE_ENABLE_ROMCS_REPLACEMENT` | `0x40` |
| `REBE_ENABLE_ROMCS_REPLACEMENT_ON_SOFT_RESET` | `0x04` |

### `0x81` (129) — Expansion Bus Control

**`REG_EXPANSION_BUS_CONTROL`**

```
(R/W) (hard reset = 0)
  bit 7 = 1 if ROMCS is asserted on the expansion bus (read only)
  bit 6 = 1 to allow peripherals to override the ULA on some even port reads (rotronics wafadrive)
  bit 5 = 1 to disable expansion bus nmi debounce (opus discovery)
  bit 4 = 1 to propagate the max cpu clock at all times including when the expansion bus is off
  bit 3 = 1 to enable +3 fdc signals on expansion bus (issue 5 only)
  bits 1-0 = max cpu speed when the expansion bus is on (currently fixed at 00 = 3.5MHz)
```

Value constants:

| Constant | Value |
| --- | --- |
| `REBC_ALLOW_ULA_OVERRIDE` | `0x40` |
| `REBC_DISABLE_NMI_DEBOUNCE` | `0x20` |
| `REBC_ENABLE_P3_FDC_SIGNALS` | `0x08` |
| `REBC_MAX_CPU_SPEED_3MHZ` | `0x00` |
| `REBC_MAX_CPU_SPEED_MASK` | `0x03` |
| `REBC_PROPAGATE_MAX_CPU_CLOCK` | `0x10` |
| `REBC_ROMCS_ASSERTED` | `0x80` |

### `0x82`–`0x85` (130–133) — Internal Port Decoding Enables (0x85 is MSB) (soft reset if bit 31 = 1, hard reset if bit 31 = 0 : all 1)

**`REG_INTERNAL_PORT_DECODING_0`**

**`REG_INTERNAL_PORT_DECODING_1`**

**`REG_INTERNAL_PORT_DECODING_2`**

**`REG_INTERNAL_PORT_DECODING_3`**

Value constants:

| Constant | Value |
| --- | --- |
| `RPD0_KEMPSTON_1` | `0x40` |
| `RPD0_KEMPSTON_2` | `0x80` |
| `RPD0_P3_FLOATING_BUS` | `0x10` |
| `RPD0_PORT_1FFD` | `0x08` |
| `RPD0_PORT_7FFD` | `0x02` |
| `RPD0_PORT_DFFD` | `0x04` |
| `RPD0_PORT_FF` | `0x01` |
| `RPD0_ZXN_DMA` | `0x20` |
| `RPD1_DIVMMC` | `0x01` |
| `RPD1_I2C` | `0x04` |
| `RPD1_LAYER_2` | `0x80` |
| `RPD1_MOUSE` | `0x20` |
| `RPD1_MULTIFACE` | `0x02` |
| `RPD1_SPI` | `0x08` |
| `RPD1_SPRITES` | `0x40` |
| `RPD1_UART` | `0x10` |
| `RPD2_AY` | `0x01` |
| `RPD2_DAC_MONO_GS_COVOX` | `0x40` |
| `RPD2_DAC_MONO_PENTAGON_ATM` | `0x20` |
| `RPD2_DAC_MONO_SPECDRUM` | `0x80` |
| `RPD2_DAC_SOUNDRIVE_1` | `0x02` |
| `RPD2_DAC_SOUNDRIVE_2` | `0x04` |
| `RPD2_DAC_STEREO_COVOX` | `0x10` |
| `RPD2_DAC_STEREO_PROFI_COVOX` | `0x08` |
| `RPD3_CTC` | `0x08` |
| `RPD3_PENTAGON_1024` | `0x04` |
| `RPD3_REGISTER_RESET_MODE` | `0x80` |
| `RPD3_ULA_PLUS` | `0x01` |
| `RPD3_Z80_DMA` | `0x02` |

### `0x86`–`0x89` (134–137) — Expansion Bus Decoding Enables (0x89 is MSB) (soft reset if bit 31 = 0, hard reset if bit 31 = 1 : all 1)

**`REG_EXPANSION_BUS_DECODING_0`**

**`REG_EXPANSION_BUS_DECODING_1`**

**`REG_EXPANSION_BUS_DECODING_2`**

**`REG_EXPANSION_BUS_DECODING_3`**

```
(R/W)
  bit 0 = port ff
  bit 1 = port 7ffd
  bit 2 = port dffd
  bit 3 = port 1ffd
  bit 4 = +3 floating bus
  bit 5 = port 6b zxn dma
  bit 6 = port 1f kempston / md1
  bit 7 = port 37 kempston 2 / md2
  -----
  bit 8 = port e3 divmmc control
  bit 9 = multiface (two variable ports)
  bit 10 = port 103b,113b i2c
  bit 11 = port e7,eb spi
  bit 12 = port 133b,143b,153b,163b uart
  bit 13 = port fadf,fbdf,ffdf mouse (also disables kempston alias on port df)
  bit 14 = port 57,5b,303b sprites
  bit 15 = port 123b layer2
  -----
  bit 16 = port fffd,bffd ay
  bit 17 = port 0f,1f,4f,5f dac soundrive mode 1
  bit 18 = port f1,f3,f9,fb dac soundrive mode 2
  bit 19 = port 3f,5f dac stereo profi covox
  bit 20 = port 0f,4f dac stereo covox
  bit 21 = port fb dac mono pentagon/atm (sd mode 2 off)
  bit 22 = port b3 dac mono gs covox
  bit 23 = port df dac mono specdrum, port 1f kempston alias
  -----
  bit 24 = port bf3b,ff3b ula+
  bit 25 = port 0b z80 dma
  bit 26 = port eff7 pentagon 1024 memory
  bit 27 = port 183b,193b,1a3b,1b3b,1c3b,1d3b,1e3b,1f3b z80 ctc
  ...
  ...
  bit 31 = register reset mode (soft or hard reset selection)
  -----
  The internal port decoding enables always apply.
  When the expansion bus is on, the expansion port decoding enables are logically ANDed with the internal enables.
  A zero bit indicates the internal device is disabled.  If the expansion bus is on, this allows io cycles for
  disabled ports to propagate to the expansion bus, otherwise corresponding io cycles to the expansion bus are filtered.
```

Value constants:

| Constant | Value |
| --- | --- |
| `RPD0_KEMPSTON_1` | `0x40` |
| `RPD0_KEMPSTON_2` | `0x80` |
| `RPD0_P3_FLOATING_BUS` | `0x10` |
| `RPD0_PORT_1FFD` | `0x08` |
| `RPD0_PORT_7FFD` | `0x02` |
| `RPD0_PORT_DFFD` | `0x04` |
| `RPD0_PORT_FF` | `0x01` |
| `RPD0_ZXN_DMA` | `0x20` |
| `RPD1_DIVMMC` | `0x01` |
| `RPD1_I2C` | `0x04` |
| `RPD1_LAYER_2` | `0x80` |
| `RPD1_MOUSE` | `0x20` |
| `RPD1_MULTIFACE` | `0x02` |
| `RPD1_SPI` | `0x08` |
| `RPD1_SPRITES` | `0x40` |
| `RPD1_UART` | `0x10` |
| `RPD2_AY` | `0x01` |
| `RPD2_DAC_MONO_GS_COVOX` | `0x40` |
| `RPD2_DAC_MONO_PENTAGON_ATM` | `0x20` |
| `RPD2_DAC_MONO_SPECDRUM` | `0x80` |
| `RPD2_DAC_SOUNDRIVE_1` | `0x02` |
| `RPD2_DAC_SOUNDRIVE_2` | `0x04` |
| `RPD2_DAC_STEREO_COVOX` | `0x10` |
| `RPD2_DAC_STEREO_PROFI_COVOX` | `0x08` |
| `RPD3_CTC` | `0x08` |
| `RPD3_PENTAGON_1024` | `0x04` |
| `RPD3_REGISTER_RESET_MODE` | `0x80` |
| `RPD3_ULA_PLUS` | `0x01` |
| `RPD3_Z80_DMA` | `0x02` |

### `0x8A` (138) — Expansion Bus IO Propagate

**`REG_EXPANSION_BUS_IO_PROPAGATE`**

```
(R/W)
  bits 7:6 = Reserved, must be 0
  bit 5 = Propagate port 0xeff7 io cycles (hard reset = 0)
  bit 4 = Propagate port 0xff io cycles (hard reset = 0)
  bit 3 = Propagate port 0x1ffd io cycles (hard reset = 0)
  bit 2 = Propagate port 0xdffd io cycles (hard reset = 0)
  bit 1 = Propagate port 0x7ffd io cycles (hard reset = 0)
  bit 0 = Propagate port 0xfe io cycles (hard reset = 0)
  If any of the bits are set, io cycles for the corresponding ports are propagated to the expansion bus when
  the expansion bus is on.  If the internal port decode is still active, any response sent by devices on the
  expansion bus will be ignored.  The purpose here is to allow external peripherals to monitor changes in state
  inside the zx next.
  Port 0xfe is treated specially so that external keyboards can be attached.  When its propagate bit is set,
  the value read from the bus will be mixed into keyboard reads on port 0xfe.
```

Value constants:

| Constant | Value |
| --- | --- |
| `REBIP_PORT_1FFD` | `0x08` |
| `REBIP_PORT_7FFD` | `0x02` |
| `REBIP_PORT_DFFD` | `0x04` |
| `REBIP_PORT_EFF7` | `0x20` |
| `REBIP_PORT_FE` | `0x01` |
| `REBIP_PORT_FF` | `0x10` |

### `0x8C` (140) — Alternate ROM

**`REG_ALTERNATE_ROM`**

```
(R/W) (hard reset = 0)
  IMMEDIATE
  bit 7 = 1 to enable alt rom
  bit 6 = 1 to make alt rom visible only during writes, otherwise replaces rom during reads
  bit 5 = 1 to lock ROM1 (48K rom)
  bit 4 = 1 to lock ROM0 (128K rom)
  AFTER SOFT RESET (copied into bits 7-4)
  bit 3 = 1 to enable alt rom
  bit 2 = 1 to make alt rom visible only during writes, otherwise replaces rom during reads
  bit 1 = 1 to lock ROM1 (48K rom)
  bit 0 = 1 to lock ROM0 (128K rom)
  The locking mechanism also applies if the alt rom is not enabled. For the +3 and zx next, if the two lock bits are not
  zero, then the corresponding rom page is locked in place. Other models use the bits to preferentially lock the corresponding
  48K rom or the 128K rom.
```

Value constants:

| Constant | Value |
| --- | --- |
| `RAR_ENABLE` | `0x80` |
| `RAR_ENABLE_ON_SOFT_RESET` | `0x08` |
| `RAR_LOCK_ROM0` | `0x10` |
| `RAR_LOCK_ROM0_ON_SOFT_RESET` | `0x01` |
| `RAR_LOCK_ROM1` | `0x20` |
| `RAR_LOCK_ROM1_ON_SOFT_RESET` | `0x02` |
| `RAR_WRITE_ONLY` | `0x40` |
| `RAR_WRITE_ONLY_ON_SOFT_RESET` | `0x04` |

### `0x8E` (142) — Spectrum 128K Memory Mapping

**`REG_SPECTRUM_128K_MAPPING`**

```
(R/W)
  bit 7 = port 0xdffd bit 0         \  RAM
  bits 6:4 = port 0x7ffd bits 2:0   /  bank 0-15
  R bit 3 = 1
  W bit 3 = 1 to change RAM bank, 0 = no change to mmu6 / mmu7 / RAM bank in ports 0x7ffd, 0xdffd
  bit 2 = port 0x1ffd bit 0            paging mode
  If bit 2 = paging mode = 0 (normal)
  bit 1 = port 0x1ffd bit 2         \  ROM
  bit 0 = port 0x7ffd bit 4         /  select
  If bit 2 = paging mode = 1 (special allRAM)
  bit 1 = port 0x1ffd bit 2         \  all
  bit 0 = port 0x1ffd bit 1         /  RAM
  Writes can affect all ports 0x7ffd, 0xdffd, 0x1ffd
  Writes always change the ROM / allRAM mapping
  Writes immediately change the current mmu mapping as if by port write
```

Value constants:

| Constant | Value |
| --- | --- |
| `RSM_ALL_RAM` | `0x04` |
| `RSM_ALL_RAM_MASK` | `0x03` |
| `RSM_CHANGE_RAM_BANK` | `0x08` |
| `RSM_RAM_BANK_MASK` | `0xF0` |
| `RSM_ROM_MASK` | `0x03` |

### `0x8F` (143) — Memory Mapping Mode

**`REG_MEMORY_MAPPING_MODE`**

```
(R/W) (hard reset = 0)
  bits 7:2 = Reserved, must be zero
  bits 1:0 = Mapping mode applied
    00 = Standard ZX 128k +3
    01 = Reserved
    10 = Pentagon 512K
    11 = Pentagon 1024K (limited to 768K on 1MB machines)
  * Standard ZX 128K +3 = principally ports 0x7ffd, 0xdffd, 0x1ffd
  * Pentagon 512K = principally port 0x7ffd
  * Pentagon 1024K = principally ports 0x7ffd, 0xeff7
  ** The mapping modes affect how ports 0x7ffd, 0xdffd, 0x1ffd and 0xeff7 carry out memory paging, see ports.txt
```

Value constants:

| Constant | Value |
| --- | --- |
| `RMMM_PENTAGON_1024K` | `0x03` |
| `RMMM_PENTAGON_512K` | `0x02` |
| `RMMM_ZX_128K_P3` | `0x00` |

### `0x90`–`0x93` (144–147) — PI GPIO Output Enable (0x93 is MSB)

**`REG_PI_GPIO_OUTPUT_ENABLE_0`**

**`REG_PI_GPIO_OUTPUT_ENABLE_1`**

**`REG_PI_GPIO_OUTPUT_ENABLE_2`**

**`REG_PI_GPIO_OUTPUT_ENABLE_3`**

```
(R/W)
  bits 27:0 Set bits enable GPIO output on the corresponding GPIO pin (soft reset = all 0)
  (GPIO pins 1:0 cannot be enabled)
```

### `0x98`–`0x9B` (152–155) — PI GPIO (0x9B is MSB)

**`REG_PI_GPIO_0`**

**`REG_PI_GPIO_1`**

**`REG_PI_GPIO_2`**

**`REG_PI_GPIO_3`**

```
(R/W)
  bits 27:0 Read / Write the GPIO pin state (soft reset = 0x00001ff)
  (writes only propagate when the corresponding pin has its output enabled)
```

### `0xA0` (160) — PI Peripheral Enable

**`REG_PI_PERIPHERAL_ENABLE`**

```
(R/W)
  bits 7:6 = Reserved, must be 0
  bit 5 = Enable UART on GPIO 14,15 (overrides gpio)* (soft reset = 0)
  bit 4 = 0 to connect Rx to GPIO 15, Tx to GPIO 14 (for comm with pi hats) (soft reset = 0)
        = 1 to connect Rx to GPIO 14, Tx to GPIO 15 (for comm with pi)
  bit 3 = Enable I2C on GPIO 2,3 (override gpio) (soft reset = 0)
  bits 2:1 = Reserved, must be 0
  bit 0 = Enable SPI on GPIO 7,8,9,10,11 (overrides gpio) (soft reset = 0)
  * GPIO 16,17 will function as rtr_n and cts_n if the uart is in hw flow control mode
```

Value constants:

| Constant | Value |
| --- | --- |
| `RPPE_ENABLE_I2C` | `0x08` |
| `RPPE_ENABLE_SPI` | `0x01` |
| `RPPE_ENABLE_UART` | `0x20` |
| `RPPE_UART_RX_ON_GPIO_14` | `0x10` |

### `0xA2` (162) — PI I2S Audio Control

**`REG_PI_I2S_AUDIO_CONTROL`**

```
(R/W)
  bits 7:6 = I2S enable (soft reset = 00)
    00 = i2s off
    01 = i2s is mono source right
    10 = i2s is mono source left
    11 = i2s is stereo
  bit 5 = Reserved, must be 0
  bit 4 = 0 PCM_DOUT to pi, PCM_DIN from pi (hats) (soft reset = 0)
        = 1 PCM_DOUT from pi, PCM_DIN to pi (pi)
  bit 3 = Mute left side (soft reset = 0)
  bit 2 = Mute right side (soft reset = 0)
//bit 1 = Slave mode (PCM_CLK, PCM_FS supplied externally) (soft reset = 0)
  bit 1 = Reserved must be 1
  bit 0 = Direct i2s audio to EAR on port 0xFE (soft reset = 0)

// 0xA3 (163) => PI I2S Clock Divide (Master Mode)
// (R/W)
//   bits 7:0 = Clock divide sets sample rate when in master mode (soft reset = 11)
//     clock divider = 538461 / SampleRateHz - 1
```

Value constants:

| Constant | Value |
| --- | --- |
| `RPIAC_I2S_MONO_LEFT` | `0x80` |
| `RPIAC_I2S_MONO_RIGHT` | `0x40` |
| `RPIAC_I2S_OFF` | `0x00` |
| `RPIAC_I2S_STEREO` | `0xC0` |
| `RPIAC_I2S_TO_EAR` | `0x01` |
| `RPIAC_MUTE_LEFT` | `0x08` |
| `RPIAC_MUTE_RIGHT` | `0x04` |
| `RPIAC_PCM_DOUT_FROM_PI` | `0x10` |
| `RPIAC_RESERVED_SET` | `0x02` |

### `0xA8` (168) — ESP Wifi GPIO Output Enable

**`REG_ESP_GPIO_OUTPUT_ENABLE`**

```
(R/W) (soft reset = 0)
  bit 2 = GPIO2 output enable (fixed at 0, GPIO2 is read-only)
  bit 0 = GPIO0 output enable
```

Value constants:

| Constant | Value |
| --- | --- |
| `RESPG_GPIO0` | `0x01` |
| `RESPG_GPIO2` | `0x04` |

### `0xA9` (169) — ESP Wifi GPIO

**`REG_ESP_GPIO`**

```
(R/W)
  bit 2 = Read / Write ESP GPIO2 (soft reset = 1)
  bit 0 = Read / Write ESP GPIO0 (soft reset = 1)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RESPG_GPIO0` | `0x01` |
| `RESPG_GPIO2` | `0x04` |

### `0xB0` (176) — Extended Keys 0

**`REG_EXTENDED_KEYS_0`**

```
(R)
  bit 7 = 1 if ; pressed
  bit 6 = 1 if " pressed
  bit 5 = 1 if , pressed
  bit 4 = 1 if . pressed
  bit 3 = 1 if UP pressed
  bit 2 = 1 if DOWN pressed
  bit 1 = 1 if LEFT pressed
  bit 0 = 1 if RIGHT pressed
  * Nextreg 0x68 bit 4 stops extended keys from making entries in the 8x5 matrix
```

Value constants:

| Constant | Value |
| --- | --- |
| `REK0_COMMA` | `0x20` |
| `REK0_DOWN` | `0x04` |
| `REK0_LEFT` | `0x02` |
| `REK0_PERIOD` | `0x10` |
| `REK0_QUOTE` | `0x40` |
| `REK0_RIGHT` | `0x01` |
| `REK0_SEMICOLON` | `0x80` |
| `REK0_UP` | `0x08` |

### `0xB1` (177) — Extended Keys 1

**`REG_EXTENDED_KEYS_1`**

```
(R)
  bit 7 = 1 if DELETE pressed
  bit 6 = 1 if EDIT pressed
  bit 5 = 1 if BREAK pressed
  bit 4 = 1 if INV VIDEO pressed
  bit 3 = 1 if TRUE VIDEO pressed
  bit 2 = 1 if GRAPH pressed
  bit 1 = 1 if CAPS LOCK pressed
  bit 0 = 1 if EXTEND pressed
  * Nextreg 0x68 bit 4 stops extended keys from making entries in the 8x5 matrix
```

Value constants:

| Constant | Value |
| --- | --- |
| `REK1_BREAK` | `0x20` |
| `REK1_CAPS_LOCK` | `0x02` |
| `REK1_DELETE` | `0x80` |
| `REK1_EDIT` | `0x40` |
| `REK1_EXTEND` | `0x01` |
| `REK1_GRAPH` | `0x04` |
| `REK1_INV_VIDEO` | `0x10` |
| `REK1_TRUE_VIDEO` | `0x08` |

### `0xB2` (178) — Extended MD Pad Buttons

**`REG_EXTENDED_MD_PAD_BUTTONS`**

```
(R)
  bit 7 = 1 if Right Pad X pressed
  bit 6 = 1 if Right Pad Z pressed
  bit 5 = 1 if Right Pad Y pressed
  bit 4 = 1 if Right Pad MODE pressed
  bit 3 = 1 if Left Pad X pressed
  bit 2 = 1 if Left Pad Z pressed
  bit 1 = 1 if Left Pad Y pressed
  bit 0 = 1 if Left Pad MODE pressed
```

Value constants:

| Constant | Value |
| --- | --- |
| `REMPB_LEFT_MODE` | `0x01` |
| `REMPB_LEFT_X` | `0x08` |
| `REMPB_LEFT_Y` | `0x02` |
| `REMPB_LEFT_Z` | `0x04` |
| `REMPB_RIGHT_MODE` | `0x10` |
| `REMPB_RIGHT_X` | `0x80` |
| `REMPB_RIGHT_Y` | `0x20` |
| `REMPB_RIGHT_Z` | `0x40` |

### `0xB8` (184) — Divmmc Entry Points 0

**`REG_DIVMMC_ENTRY_POINTS_0`**

```
(R/W) (soft reset = 0x83)
  bit 7 = 1 to enable automap on address 0x0038 (instruction fetch)
  bit 6 = 1 to enable automap on address 0x0030 (instruction fetch)
  bit 5 = 1 to enable automap on address 0x0028 (instruction fetch)
  bit 4 = 1 to enable automap on address 0x0020 (instruction fetch)
  bit 3 = 1 to enable automap on address 0x0018 (instruction fetch)
  bit 2 = 1 to enable automap on address 0x0010 (instruction fetch)
  bit 1 = 1 to enable automap on address 0x0008 (instruction fetch)
  bit 0 = 1 to enable automap on address 0x0000 (instruction fetch)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RDEP0_ADDRESS_0000` | `0x01` |
| `RDEP0_ADDRESS_0008` | `0x02` |
| `RDEP0_ADDRESS_0010` | `0x04` |
| `RDEP0_ADDRESS_0018` | `0x08` |
| `RDEP0_ADDRESS_0020` | `0x10` |
| `RDEP0_ADDRESS_0028` | `0x20` |
| `RDEP0_ADDRESS_0030` | `0x40` |
| `RDEP0_ADDRESS_0038` | `0x80` |

### `0xB9` (185) — Divmmc Entry Points Valid 0

**`REG_DIVMMC_ENTRY_POINTS_VALID_0`**

```
(R/W) (soft reset = 0x01)
  bit 7 = 1 for always else only when rom3 is present (0x0038)
  bit 6 = 1 for always else only when rom3 is present (0x0030)
  bit 5 = 1 for always else only when rom3 is present (0x0028)
  bit 4 = 1 for always else only when rom3 is present (0x0020)
  bit 3 = 1 for always else only when rom3 is present (0x0018)
  bit 2 = 1 for always else only when rom3 is present (0x0010)
  bit 1 = 1 for always else only when rom3 is present (0x0008)
  bit 0 = 1 for always else only when rom3 is present (0x0000)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RDEP0_ADDRESS_0000` | `0x01` |
| `RDEP0_ADDRESS_0008` | `0x02` |
| `RDEP0_ADDRESS_0010` | `0x04` |
| `RDEP0_ADDRESS_0018` | `0x08` |
| `RDEP0_ADDRESS_0020` | `0x10` |
| `RDEP0_ADDRESS_0028` | `0x20` |
| `RDEP0_ADDRESS_0030` | `0x40` |
| `RDEP0_ADDRESS_0038` | `0x80` |

### `0xBA` (186) — Divmmc Entry Points Timing 0

**`REG_DIVMMC_ENTRY_POINTS_TIMING_0`**

```
(R/W) (soft reset = 0x00)
  bit 7 = 1 for instant mapping else delayed (0x0038)
  bit 6 = 1 for instant mapping else delayed (0x0030)
  bit 5 = 1 for instant mapping else delayed (0x0028)
  bit 4 = 1 for instant mapping else delayed (0x0020)
  bit 3 = 1 for instant mapping else delayed (0x0018)
  bit 2 = 1 for instant mapping else delayed (0x0010)
  bit 1 = 1 for instant mapping else delayed (0x0008)
  bit 0 = 1 for instant mapping else delayed (0x0000)
```

Value constants:

| Constant | Value |
| --- | --- |
| `RDEP0_ADDRESS_0000` | `0x01` |
| `RDEP0_ADDRESS_0008` | `0x02` |
| `RDEP0_ADDRESS_0010` | `0x04` |
| `RDEP0_ADDRESS_0018` | `0x08` |
| `RDEP0_ADDRESS_0020` | `0x10` |
| `RDEP0_ADDRESS_0028` | `0x20` |
| `RDEP0_ADDRESS_0030` | `0x40` |
| `RDEP0_ADDRESS_0038` | `0x80` |

### `0xBB` (187) — Divmmc Entry Points 1

**`REG_DIVMMC_ENTRY_POINTS_1`**

```
(R/W) (soft reset = 0xCD)
  bit 7 = 1 to enable automap on addresses 0x3DXX (instruction fetch, instant, ROM3) > TRDOS
  bit 6 = 1 to disable automap on addresses 0x1FF8-0x1FFF (instruction fetch, delayed)
  bit 5 = 1 to enable automap on address 0x056A (instruction fetch, delayed, ROM3)   \ tape traps
  bit 4 = 1 to enable automap on address 0x04D7 (instruction fetch, delayed, ROM3)   / nextzxos (better compatibility)
  bit 3 = 1 to enable automap on address 0x0562 (instruction fetch, delayed, ROM3)   \ tape traps
  bit 2 = 1 to enable automap on address 0x04C6 (instruction fetch, delayed, ROM3)   / esxdos + original divmmc
  bit 1 = 1 to enable automap on address 0x0066 (instruction fetch + button, instant)
  bit 0 = 1 to enable automap on address 0x0066 (instruction fetch + button, delayed)

// INTERRUPTS
```

Value constants:

| Constant | Value |
| --- | --- |
| `RDEP1_DISABLE_1FF8` | `0x40` |
| `RDEP1_ESXDOS_TAPE_04C6` | `0x04` |
| `RDEP1_ESXDOS_TAPE_0562` | `0x08` |
| `RDEP1_NEXTZXOS_TAPE_04D7` | `0x10` |
| `RDEP1_NEXTZXOS_TAPE_056A` | `0x20` |
| `RDEP1_NMI_0066_DELAYED` | `0x01` |
| `RDEP1_NMI_0066_INSTANT` | `0x02` |
| `RDEP1_TRDOS_3DXX` | `0x80` |

### `0xC0` (192) — Interrupt Control

**`REG_INTERRUPT_CONTROL`**

```
(R/W) (soft reset = 0)
  bits 7:5 = Programmable portion of im2 vector*
  bit 4 = Reserved must be 0
  bit 3 = Enable stackless nmi response**
  bits 2:1 = Current Z80 interrupt mode 0,1,2 (read only, write ignored)
  bit 0 = Maskable interrupt mode: pulse (0) or hw im2 mode (1)
  * In hw im2 mode the interrupt vector generated is:
  bits 7:5 = nextreg 0xC0 bits 7:5
  bits 4:1 = 0  line interrupt (highest priority)
    = 1  uart0 Rx
    = 2  uart1 Rx
    = 3-10  ctc channels 0-7
    = 11 ula
    = 12 uart0 Tx
    = 13 uart1 Tx (lowest priority)
  bit 0 = 0
  * In hw im2 mode the expansion bus is the lowest priority interrupter
    and if no vector is supplied externally then 0xFF is generated.
  ** The return address pushed during an nmi acknowledge cycle will
    be written to nextreg instead of memory (the stack pointer will
    be decremented) and the first RETN after the acknowledge will
    take its return address from nextreg instead of memory (the stack
    pointer will be incremented).  If bit 3 = 0 and in other
    circumstances, RETN functions normally.
```

Value constants:

| Constant | Value |
| --- | --- |
| `RIC_ENABLE_STACKLESS_NMI` | `0x08` |
| `RIC_IM2_VECTOR_MASK` | `0xE0` |
| `RIC_MODE_HW_IM2` | `0x01` |
| `RIC_MODE_PULSE` | `0x00` |
| `RIC_Z80_INTERRUPT_MODE_MASK` | `0x06` |

### `0xC2` (194) — NMI Return Address LSB

**`REG_NMI_RETURN_ADDRESS_L`**

```
(R/W) (soft reset = 0)
```

### `0xC3` (195) — NMI Return Address MSB

**`REG_NMI_RETURN_ADDRESS_H`**

```
(R/W) (soft reset = 0)
  The return address written during an nmi acknowledge cycle is
  always stored in these registers.

--
```

### `0xC4` (196) — INT EN 0

**`REG_INTERRUPT_ENABLE_0`**

```
(R/W) (soft reset = 0x81)
  bit 7 = Expansion bus /INT
  bits 6:2 = Reserved must be 0
  bit 1 = Line **
  bit 0 = ULA **
  * If a device interrupt is disabled, it enters a polled mode
  ** Aliases of interrupt enable bits in nextreg 0x22
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI0_EXPANSION_BUS` | `0x80` |
| `RI0_LINE` | `0x02` |
| `RI0_NMI` | `0x80` |
| `RI0_ULA` | `0x01` |

### `0xC5` (197) — INT EN 1

**`REG_INTERRUPT_ENABLE_1`**

```
(R/W) (soft reset = 0)
  bit 7 = ctc channel 7 zc/to
  bit 6 = ctc channel 6 zc/to
  bit 5 = ctc channel 5 zc/to
  bit 4 = ctc channel 4 zc/to
  bit 3 = ctc channel 3 zc/to
  bit 2 = ctc channel 2 zc/to
  bit 1 = ctc channel 1 zc/to
  bit 0 = ctc channel 0 zc/to
  * If a device interrupt is disabled, it enters a polled mode
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI1_CTC_CHANNEL_0` | `0x01` |
| `RI1_CTC_CHANNEL_1` | `0x02` |
| `RI1_CTC_CHANNEL_2` | `0x04` |
| `RI1_CTC_CHANNEL_3` | `0x08` |
| `RI1_CTC_CHANNEL_4` | `0x10` |
| `RI1_CTC_CHANNEL_5` | `0x20` |
| `RI1_CTC_CHANNEL_6` | `0x40` |
| `RI1_CTC_CHANNEL_7` | `0x80` |

### `0xC6` (198) — INT EN 2

**`REG_INTERRUPT_ENABLE_2`**

```
(R/W) (soft reset = 0)
  bit 7 = Reserved must be zero
  bit 6 = UART1 Tx empty
  bit 5 = UART1 Rx near full     \ shared
  bit 4 = UART1 Rx available     / interrupt
  bit 3 = Reserved must be zero
  bit 2 = UART0 Tx empty
  bit 1 = UART0 Rx near full     \ shared
  bit 0 = UART0 Rx available     / interrupt
  * Rx near full overrides Rx available
  * If a device interrupt is disabled, it enters a polled mode
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI2_UART0_RX_AVAILABLE` | `0x01` |
| `RI2_UART0_RX_NEAR_FULL` | `0x02` |
| `RI2_UART0_TX_EMPTY` | `0x04` |
| `RI2_UART1_RX_AVAILABLE` | `0x10` |
| `RI2_UART1_RX_NEAR_FULL` | `0x20` |
| `RI2_UART1_TX_EMPTY` | `0x40` |

### `0xC7` (199) — Reserved, write 0

_No z88dk constant._

```

--
```

### `0xC8` (200) — INT Status 0

**`REG_INTERRUPT_STATUS_0`**

```
(R/W)
  bits 7:2 = Reserved must be 0
  bit 1 = Line
  bit 0 = ULA
  * (R) Set bits indicate the device generated an interrupt in the past or an interrupt is pending
  * (W) Set bits clear the status.  In hw im2 mode the status will continue to read as set until the
      interrupt pending condition is cleared
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI0_EXPANSION_BUS` | `0x80` |
| `RI0_LINE` | `0x02` |
| `RI0_NMI` | `0x80` |
| `RI0_ULA` | `0x01` |

### `0xC9` (201) — INT Status 1

**`REG_INTERRUPT_STATUS_1`**

```
(R/W)
  bit 7 = ctc channel 7 zc/to
  bit 6 = ctc channel 6 zc/to
  bit 5 = ctc channel 5 zc/to
  bit 4 = ctc channel 4 zc/to
  bit 3 = ctc channel 3 zc/to
  bit 2 = ctc channel 2 zc/to
  bit 1 = ctc channel 1 zc/to
  bit 0 = ctc channel 0 zc/to
  * (R) Set bits indicate the device generated an interrupt in the past or an interrupt is pending
  * (W) Set bits clear the status.  In hw im2 mode the status will continue to read as set until the
      interrupt pending condition is cleared
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI1_CTC_CHANNEL_0` | `0x01` |
| `RI1_CTC_CHANNEL_1` | `0x02` |
| `RI1_CTC_CHANNEL_2` | `0x04` |
| `RI1_CTC_CHANNEL_3` | `0x08` |
| `RI1_CTC_CHANNEL_4` | `0x10` |
| `RI1_CTC_CHANNEL_5` | `0x20` |
| `RI1_CTC_CHANNEL_6` | `0x40` |
| `RI1_CTC_CHANNEL_7` | `0x80` |

### `0xCA` (202) — INT Status 2

**`REG_INTERRUPT_STATUS_2`**

```
(R/W)
  bit 7 = Reserved must be zero
  bit 6 = UART1 Tx empty
  bit 5 = UART1 Rx half full    \ shared
  bit 4 = UART1 Rx available    / interrupt
  bit 3 = Reserved must be zero
  bit 2 = UART0 Tx empty
  bit 1 = UART0 Rx half full    \ shared
  bit 0 = UART0 Rx available    / interrupt
  * (R) Set bits indicate the device generated an interrupt in the past or an interrupt is pending
  * (W) Set bits clear the status.  In hw im2 mode the status will continue to read as set until the
      interrupt pending condition is cleared
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI2_UART0_RX_AVAILABLE` | `0x01` |
| `RI2_UART0_RX_NEAR_FULL` | `0x02` |
| `RI2_UART0_TX_EMPTY` | `0x04` |
| `RI2_UART1_RX_AVAILABLE` | `0x10` |
| `RI2_UART1_RX_NEAR_FULL` | `0x20` |
| `RI2_UART1_TX_EMPTY` | `0x40` |

### `0xCB` (203) — Reserved, write 0xFF

_No z88dk constant._

```

--
```

### `0xCC` (204) — DMA INT EN 0

**`REG_DMA_INTERRUPT_ENABLE_0`**

```
(R/W) (soft reset = 0)
  bit 7 = NMI
  bit 1 = Line
  bit 0 = ULA
  * Set bits indicate the corresponding interrupt will interrupt a dma operation when in hw im2 mode
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI0_EXPANSION_BUS` | `0x80` |
| `RI0_LINE` | `0x02` |
| `RI0_NMI` | `0x80` |
| `RI0_ULA` | `0x01` |

### `0xCD` (205) — DMA INT EN 1

**`REG_DMA_INTERRUPT_ENABLE_1`**

```
(R/W) (soft reset = 0)
  bit 7 = ctc channel 7 zc/to
  bit 6 = ctc channel 6 zc/to
  bit 5 = ctc channel 5 zc/to
  bit 4 = ctc channel 4 zc/to
  bit 3 = ctc channel 3 zc/to
  bit 2 = ctc channel 2 zc/to
  bit 1 = ctc channel 1 zc/to
  bit 0 = ctc channel 0 zc/to
  * Set bits indicate the corresponding interrupt will interrupt a dma operation when in hw im2 mode
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI1_CTC_CHANNEL_0` | `0x01` |
| `RI1_CTC_CHANNEL_1` | `0x02` |
| `RI1_CTC_CHANNEL_2` | `0x04` |
| `RI1_CTC_CHANNEL_3` | `0x08` |
| `RI1_CTC_CHANNEL_4` | `0x10` |
| `RI1_CTC_CHANNEL_5` | `0x20` |
| `RI1_CTC_CHANNEL_6` | `0x40` |
| `RI1_CTC_CHANNEL_7` | `0x80` |

### `0xCE` (206) — DMA INT EN 2

**`REG_DMA_INTERRUPT_ENABLE_2`**

```
(R/W) (soft reset = 0)
  bit 7 = Reserved must be zero
  bit 6 = UART1 Tx empty
  bit 5 = UART1 Rx half full     \ shared
  bit 4 = UART1 Rx available     / interrupt
  bit 3 = Reserved must be zero
  bit 2 = UART0 Tx empty
  bit 1 = UART0 Rx half full     \ shared
  bit 0 = UART0 Rx available     / interrupt
  * Set bits indicate the corresponding interrupt will interrupt a dma operation when in hw im2 mode
```

Value constants:

| Constant | Value |
| --- | --- |
| `RI2_UART0_RX_AVAILABLE` | `0x01` |
| `RI2_UART0_RX_NEAR_FULL` | `0x02` |
| `RI2_UART0_TX_EMPTY` | `0x04` |
| `RI2_UART1_RX_AVAILABLE` | `0x10` |
| `RI2_UART1_RX_NEAR_FULL` | `0x20` |
| `RI2_UART1_TX_EMPTY` | `0x40` |

### `0xCF` (207) — Reserved, write 0

_No z88dk constant._

```

Because interrupts are only sampled at the end of an instruction
by the Z80, each time the dma is interrupted one instruction of
progress is made in the main program.

--
```

### `0xD8` (216) — I/O Traps (experimental)

**`REG_IO_TRAPS`**

```
(R/W) (soft reset = 0)
   bits 7:1 = Reserved must be zero
   bit 0 = 1 to enable +3 FDC traps on ports 0x2ffd and 0x3ffd
  * An i/o trap generates a multiface nmi and is indicated in nextreg 0x02
  * Traps cannot be triggered by the dma or while the multiface, divmmc or external nmi is active
```

Value constants:

| Constant | Value |
| --- | --- |
| `RIT_ENABLE_P3_FDC_TRAPS` | `0x01` |

### `0xD9` (217) — I/O Trap Write (experimental)

**`REG_IO_TRAP_WRITE`**

```
(R/W)
   Holds byte written during trapped i/o write cycle
```

### `0xDA` (218) — I/O Trap Cause (experimental)

**`REG_IO_TRAP_CAUSE`**

```
   0 = none (zero at the same time nextreg 0x02 bit 4 is 0)
   1 = port_2ffd read
   2 = port_3ffd read
   3 = port_3ffd write
  * If nextreg 0x02 bit 4 indicates an i/o cycle was trapped, this register indicates the cause

--
```

Value constants:

| Constant | Value |
| --- | --- |
| `RITC_NONE` | `0x00` |
| `RITC_PORT_2FFD_READ` | `0x01` |
| `RITC_PORT_3FFD_READ` | `0x02` |
| `RITC_PORT_3FFD_WRITE` | `0x03` |

### `0xF0` (240) — XDEV CMD

**`REG_XDEV_COMMAND`**

```
R/W Issues 4 and 5 Only - (soft reset = 0x80)
  Select Mode
    (R)
      bit 7 = 1 if in select mode
      bits 1:0 = indicate currently selected device
        00 = none
        01 = Xilinx DNA
        10 = Xilinx XADC
    (W)
      bit 7 = 1 to enter select mode, 0 to enter selected device mode (no other bits have effect) ***
      bit 6 = 1 to change selected device **
      bits 1:0 = selected device
        00 = none
        01 = Xilinx DNA
        10 = Xilinx XADC
  Xilinx DNA Mode
    (R)
      bit 0 = dna bit (serial stream shifts left)
        the first eight bits read will indicate the length of the following dna bits
    (W)
      bit 7 = 1 to enter select mode (write has no other effect) *
        otherwise causes dna string to reload, ready for fresh read
  Xilinx XADC Mode (Documented in Xilinx Series 7 UG480)
    (R)
      bit 6 = 1 if XADC is busy with conversion (BUSY)
      bit 1 = 1 if XADC conversion completed since last read (EOC, read clears)
      bit 0 = 1 if XADC conversion sequence completed since last read (EOS, read clears)
    (W)
      bit 7 = 1 to enter select mode (write has no other effect) *
      bit 6 = 1 to reset XADC (RESET)
      bit 0 = 1 to start conversion (CONVST)
  * Re-enter select mode at any time by writing to the register with bit 7 set
  ** Select a device to communicate with by writing to the register with bits 6 & 7 set
  *** Exit select mode by writing zero to bit 7; thereafter the particular device is attached to the nextreg
```

Value constants:

| Constant | Value |
| --- | --- |
| `RXC_CHANGE_DEVICE` | `0x40` |
| `RXC_DEVICE_DNA` | `0x01` |
| `RXC_DEVICE_MASK` | `0x03` |
| `RXC_DEVICE_NONE` | `0x00` |
| `RXC_DEVICE_XADC` | `0x02` |
| `RXC_DNA_BIT` | `0x01` |
| `RXC_SELECT_MODE` | `0x80` |
| `RXC_XADC_BUSY` | `0x40` |
| `RXC_XADC_CONVST` | `0x01` |
| `RXC_XADC_EOC` | `0x02` |
| `RXC_XADC_EOS` | `0x01` |
| `RXC_XADC_RESET` | `0x40` |

### `0xF8` (248) — XADC REG

**`REG_XADC_REGISTER`**

```
(R/W Issues 4 and 5 Only) (hard reset = 0)
  bit 7 = 1 to write to XADC DRP port, 0 to read from XADC DRP port **
  bits 6:0 = XADC DRP register address DADDR
  * An XADC register read or write is/ initiated by writing to this register
  * There must be at least six 28 MHz cycles after each r/w to this register
  ** Reads as 0
```

Value constants:

| Constant | Value |
| --- | --- |
| `RXR_ADDRESS_MASK` | `0x7F` |
| `RXR_WRITE` | `0x80` |

### `0xF9` (249) — XADC D0

**`REG_XADC_DATA_L`**

```
(R/W Issues 4 and 5 Only) (hard reset = 0)
  bits 7:0 = LSB data connected to XADC DRP data bus D7:0
  * DRP reads store result here, DRP writes take value from here
```

### `0xFA` (250) — XADC D1

**`REG_XADC_DATA_H`**

```
(R/W Issues 4 and 5 Only) (hard reset = 0)
  bits 7:0 = MSB data connected to XADC DRP data bus D15:8
  * DRP reads store result here, DRP writes take value from here
```

### `0xFF` (255) — Reserved for internal use

**`REG_DEBUG`**

## Other value constants

Constants that are not nextreg bit values or whose register could not be
inferred from the name prefix.

| Constant | Value |
| --- | --- |
| `ROM3_BC_SPACES` | `0x30` |
| `ROM3_CLS` | `0xD6B` |
| `ROM3_MAKE_ROOM` | `0x1655` |
| `ROM3_RECLAIM_2` | `0x19E8` |

