


IF FORbic
    defc UPD_7220_FIFO_READ = 0x99
    defc UPD_7220_STATUS_READ = 0x98
    defc UPD_7220_COMMAND_WRITE = 0x99
    defc UPD_7220_PARAMETER_WRITE = 0x98
    defc A5105_SCREEN_MODE = 0x9d
    defc UPD7220_EXPORT_DIRECT = 1
ENDIF

IF FORqx10
    defc UPD_7220_FIFO_READ = 0x39
    defc UPD_7220_STATUS_READ = 0x38
    defc UPD_7220_COMMAND_WRITE = 0x39
    defc UPD_7220_PARAMETER_WRITE = 0x38
    defc A5105_SCREEN_MODE = 0x3d
    defc UPD7220_EXPORT_DIRECT = 1
ENDIF

; Set cursor _CURS (3/4 parmaeters)



defc UPD7220_COMMAND_RESET           = 0x00
defc UPD7220_COMMAND_SYNC            = 0x0e ; & = 0xfe
defc UPD7220_COMMAND_VSYNC           = 0x6e ; & = 0xfe
defc UPD7220_COMMAND_CCHAR           = 0x4b
defc UPD7220_COMMAND_START           = 0x6b
defc UPD7220_COMMAND_BCTRL           = 0x0c ; & = 0xfe
defc UPD7220_COMMAND_05              = 0x05
defc UPD7220_COMMAND_ZOOM            = 0x46
defc UPD7220_COMMAND_CURS            = 0x49
defc UPD7220_COMMAND_PRAM            = 0x70 ; & = 0xf0
defc UPD7220_COMMAND_PITCH           = 0x47
defc UPD7220_COMMAND_WDAT            = 0x20 ; & = 0xe4
defc UPD7220_COMMAND_MASK            = 0x4a
defc UPD7220_COMMAND_FIGS            = 0x4c
defc UPD7220_COMMAND_FIGD            = 0x6c
defc UPD7220_COMMAND_GCHRD           = 0x68
defc UPD7220_COMMAND_RDAT            = 0xa0 ; & = 0xe4
defc UPD7220_COMMAND_CURD            = 0xe0
defc UPD7220_COMMAND_LPRD            = 0xc0
defc UPD7220_COMMAND_DMAR            = 0xa4 ; & = 0xe4
defc UPD7220_COMMAND_DMAW            = 0x24 ; & = 0xe4
defc UPD7220_COMMAND_5A              = 0x5a
