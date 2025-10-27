
SECTION bss_driver

PUBLIC ideBuffer

; Space for the IDE Buffer
; used to respond to Drive ID requests, as sufficient buffer is not provided.

ideBuffer:  defs 512
