
SECTION data_driver

PUBLIC ideBuffer, ideStatus

;IDE Status byte
;set bit 0 : User selects master (0) or slave (1) drive
;bit 1 : Flag 0 = master not previously accessed 
;bit 2 : Flag 0 = slave not previously accessed

ideBuffer:  defs 512   ; Space for the IDE Buffer
    
ideStatus:  defb 0

