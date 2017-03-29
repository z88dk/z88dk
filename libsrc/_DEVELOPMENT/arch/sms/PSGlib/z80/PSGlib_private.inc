EXTERN __IO_PSG

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

; keep consistent with c header

defc PSG_STOPPED   = 0
defc PSG_PLAYING   = 1

defc SFX_CHANNEL2     = 0x01
defc SFX_CHANNEL3     = 0x02
defc SFX_CHANNEL2AND3 = 0x03
