
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target error
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target messages
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target ioctls
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
       
   ; for the MC68C50 ACIA
   
   PUBLIC ACIA_CTRL_ADDR, ACIA_STATUS_ADDR, ACIA_DATA_ADDR
   
   defc ACIA_CTRL_ADDR         = $80    ; Address of Control Register (write only)
   defc ACIA_STATUS_ADDR       = $80    ; Address of Status Register (read only)
   defc ACIA_DATA_ADDR         = $81    ; Address of Data Register
   
   PUBLIC ACIA_CLK_DIV_01, ACIA_CLK_DIV_16, ACIA_CLK_DIV_64
   PUBLIC ACIA_RESET
   
   defc ACIA_CLK_DIV_01        = $00    ; Divide the Clock by 1
   defc ACIA_CLK_DIV_16        = $01    ; Divide the Clock by 16
   defc ACIA_CLK_DIV_64        = $02    ; Divide the Clock by 64 (default value)
   defc ACIA_RESET             = $03    ; Master Reset (issue before any other Control word)
   
   PUBLIC ACIA_7E2, ACIA_7O2, ACIA_7E1, ACIA_7O1
   PUBLIC ACIA_8N2, ACIA_8N1, ACIA_8E1, ACIA_8O1
   
   defc ACIA_7E2               = $00    ; 7 Bits Even Parity 2 Stop Bits
   defc ACIA_7O2               = $04    ; 7 Bits  Odd Parity 2 Stop Bits
   defc ACIA_7E1               = $08    ; 7 Bits Even Parity 1 Stop Bit
   defc ACIA_7O1               = $0C    ; 7 Bits  Odd Parity 1 Stop Bit
   defc ACIA_8N2               = $10    ; 8 Bits   No Parity 2 Stop Bits
   defc ACIA_8N1               = $14    ; 8 Bits   No Parity 1 Stop Bit
   defc ACIA_8E1               = $18    ; 8 Bits Even Parity 1 Stop Bit
   defc ACIA_8O1               = $1C    ; 8 Bits  Odd Parity 1 Stop Bit
   
   PUBLIC ACIA_TDI_RTS0, ACIA_TEI_RTS0
   PUBLIC ACIA_TDI_RTS1, ACIA_TDI_BRK
   PUBLIC ACIA_TEI_MASK
   
   defc ACIA_TDI_RTS0          = $00    ; _RTS low,  Transmitting Interrupt Disabled
   defc ACIA_TEI_RTS0          = $20    ; _RTS low,  Transmitting Interrupt Enabled
   defc ACIA_TDI_RTS1          = $40    ; _RTS high, Transmitting Interrupt Disabled
   defc ACIA_TDI_BRK           = $60    ; _RTS low,  Transmitting Interrupt Disabled, BRK on Tx
   
   defc ACIA_TEI_MASK          = $60    ; Mask for the Tx Interrupt & RTS bits
   
   PUBLIC ACIA_REI
   
   defc ACIA_REI               = $80    ; Receive Interrupt Enabled
   
   PUBLIC ACIA_RDRF, ACIA_TDRE, ACIA_DCD, ACIA_CTS
   PUBLIC ACIA_FE, ACIA_OVRN, ACIA_PE, ACIA_IRQ
   
   defc ACIA_RDRF              = $01	; Receive Data Register Full
   defc ACIA_TDRE              = $02	; Transmit Data Register Empty
   defc ACIA_DCD               = $04	; Data Carrier Detect
   defc ACIA_CTS               = $08	; Clear To Send
   defc ACIA_FE                = $10	; Framing Error (Received Byte)
   defc ACIA_OVRN              = $20	; Overrun (Received Byte
   defc ACIA_PE                = $40	; Parity Error (Received Byte)
   defc ACIA_IRQ               = $80	; IRQ (Either Transmitted or Received Byte)
   
   PUBLIC ACIA_TX_SIZE, ACIA_RX_SIZE, ACIA_RX_FULLISH
   
   defc ACIA_RX_SIZE           = $80	            ; Size of the Rx Buffer
   defc ACIA_RX_FULLISH        = ACIA_RX_SIZE - 4   ; Size of the Rx Buffer, when not_RTS is signalled
   defc ACIA_TX_SIZE           = $80	            ; Size of the Tx Buffer   
      
;; end target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
