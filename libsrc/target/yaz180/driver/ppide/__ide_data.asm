SECTION data_driver

PUBLIC ideStatus, ideLock

; IDE Status byte
; set bit 0 : User selects master (0) or slave (1) drive
; bit 1 : Flag 0 = master not previously accessed 
; bit 2 : Flag 0 = slave not previously accessed

ideStatus:  defb 0
ideLock:    defb $FE


SECTION bss_driver

PUBLIC ideBuffer

; Space for the IDE Buffer
; used to respond to Drive ID requests, as sufficient buffer is not provided.

ideBuffer:  defs 512

