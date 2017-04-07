INCLUDE "config_private.inc"

defc PSGPort       = __IO_PSG
defc PSGDataPort   = __IO_PSG

defc PSGLatch      = 0x80
defc PSGData       = 0x40

defc PSGChannel0   = 0x00
defc PSGChannel1   = 0x20
defc PSGChannel2   = 0x40
defc PSGChannel3   = 0x60
defc PSGVolumeData = 0x10

defc PSGWait       = 0x38
defc PSGSubString  = 0x08
defc PSGLoop       = 0x01
defc PSGEnd        = 0x00

defc PSG_STOPPED   = __PSGLIB_PSG_STOPPED
defc PSG_PLAYING   = __PSGLIB_PSG_PLAYING

defc SFX_CHANNEL2     = __PSGLIB_SFX_CHANNEL2
defc SFX_CHANNEL3     = __PSGLIB_SFX_CHANNEL3
defc SFX_CHANNEL2AND3 = __PSGLIB_SFX_CHANNELS2AND3
