#ifndef __ATJ2085_PORTS_H__
#define __ATJ2085_PORTS_H__

/*-----------------------------------------------------------------------------*/
/*MCU Clock Control Registers												   */
/*-----------------------------------------------------------------------------*/
#define MCU_CLKCTRL_REG1     	       (0x00)			/* default 0x00 */
/* Bit 7-6 Wait state for external memory access */
#define MCU_EXT_MEM_WS_0			    0x00
#define MCU_EXT_MEM_WS_1			    0x40
#define MCU_EXT_MEM_WS_2			    0x80
#define MCU_EXT_MEM_WS_3			    0xC0
/* Bit 5 reserved */
#define MCU_CLK_RES				0x20
/* Bit 4 MCU clock source select */
#define MCU_CLK_SRC_SEL				    0x10
/* Bit 3-0 MCU Clock division control */
#define MCU_CLK_DIV_NONE			    0x0
#define MCU_CLK_DIV_1 				    0x1
#define MCU_CLK_DIV_4 				    0x2
#define MCU_CLK_DIV_8 				    0x3
#define MCU_CLK_DIV_16 				    0x4
#define MCU_CLK_DIV_32 				    0x5
#define MCU_CLK_DIV_64				    0x6
#define MCU_CLK_DIV_128 			    0x7
#define MCU_CLK_DIV_256				    0x8
#define MCU_CLK_DIV_512				    0x9
#define MCU_CLK_DIV_1024			    0xA
#define MCU_CLK_DIV_DC 				    0xB
/*#define MCU_CLK_DIV_256				0xC*/
/*#define MCU_CLK_DIV_512				0xD*/
/*#define MCU_CLK_DIV_1024			    0xE*/
/*#define MCU_CLK_DIV_DC 				0xF*/

#define WHOKNOWSWHATTHISIS             (0x70)
/* Bit 7-6 */

#define B1_2_MEMMAP_REG        	       (0x70)
/* Bit 5-4 */
#define B1_2_MEMMAP_B1_B2               0x30
#define B1_2_MEMMAP_B1                  0x20
#define B1_2_MEMMAP_B2                  0x10
#define B1_2_MEMMAP_NONE                0x00

#define MCU_CLKCTRL_REG     	       (0x70)
/* Bit 3 */
#define MCU_CLKCTRL_PLL                 0x08

#define DMA_CLKCTRL_REG      	       (0x70)
/* Bit 2-0 */

/*-----------------------------------------------------------------------------*/
/* External Memory Page Control Registers 									   */
/*-----------------------------------------------------------------------------*/
#define EM_PAGE_LO_REG       	       (0x01)			/* default 0x00 */
/* Bit 7-0 extended page address bits for EMA 22-15*/

#define EM_PAGE_HI_REG                 (0x02)
/* Bit 7-6 reserved*/
/* Bit 5-0 extended page address bits for EMA 28-26 */
/* Bit 5-3 */
#define EM_PAGE_HI_CE0_INV		        0x00
#define EM_PAGE_HI_CE1_INV		        0x08
#define EM_PAGE_HI_CE2_INV		        0x10
#define EM_PAGE_HI_CE3_INV		        0x18
/* Bit 2-0 extended page address bits for EMA 25-23 */

#define EM_PAGE_INC_DEC  			   (0x03)
/* Bit 7-0 2's complemnt to add to page address */

/*-----------------------------------------------------------------------------*/
/* MCU-A15 Control Register 												   */
/*-----------------------------------------------------------------------------*/
#define MCU_A15CTRL_REG  			   (0x04)			/* default 0x00 */
/* Bit 7-0 */
#define MCU_A15_WD_MASK					0x80
#define MCU_A15_EXT_RST_MASK		    0x40
#define MCU_A15_LOWBAT_MASK			    0x20
#define MCU_A15_RESERVED				0x10
#define MCU_A15_DCDIS_NMI_MASK	        0x08
#define MCU_A15_SIRQ_MASK				0x04
#define MCU_A15_NMI_MASK				0x02
#define MCU_A15_A15_MASK				0x01

/*-----------------------------------------------------------------------------*/
/* Internal MROM SRAM Page Register																					   */
/*-----------------------------------------------------------------------------*/
#define INTERNAL_MROM_SRAM_PAGE_REG	   (0x05)			/* default 0x00 */
/* Bit 7-0 */
#define INT_MROM_SRAM_LOW_IPM_TO_MCU	0x80
#define INT_MROM_SRAM_HI_IPM_TO_MCU		0x40
#define INT_MROM_SRAM_LOW_IDM_TO_MCU	0x20
#define INT_MROM_SRAM_HI_IDM_TO_MCU		0x10
#define INT_MROM_SRAM_CONCURRENT_MODE	0x08
/* Bit 3-0 Extended IPM/IDM Page address bit */
#define INT_MROM_SRAM_ZRAM2				0x7
#define INT_MROM_SRAM_IDM_HIGH_BLOCK	0x6
#define INT_MROM_SRAM_IDM_MID_BLOCK		0x5
#define INT_MROM_SRAM_IDM_LOW_BLOCK		0x4
#define INT_MROM_SRAM_IDM_RESERVED		0x3
#define INT_MROM_SRAM_IPM_HIGH_BLOCK	0x2
#define INT_MROM_SRAM_IPM_MID_BLOCK		0x1
#define INT_MROM_SRAM_IPM_LOW_BLOCK		0x0

/*-----------------------------------------------------------------------------*/
/*DMA1 CNTRL																																	 */
/*-----------------------------------------------------------------------------*/
#define DMA1_SRCADDR0_REG    (0x06)
#define DMA1_SRCADDR1_REG    (0x07)
#define DMA1_SRCADDR2_REG    (0x08)
#define DMA1_SRCADDR3_REG    (0x09)
#define DMA1_SRCADDR4_REG    (0x0a)
#define DMA1_IPMSRC_REG      (0x0a)
#define DMA1_IDMSRC_REG      (0x0a)
#define DMA1_ZRAM2SRC_REG    (0x0a)

#define DMA1_DSTADDR0_REG    (0x0b)
#define DMA1_DSTADDR1_REG    (0x0c)
#define DMA1_DSTADDR2_REG    (0x0d)
#define DMA1_DSTADDR3_REG    (0x0e)
#define DMA1_DSTADDR4_REG    (0x0f)
#define DMA1_IPMDST_REG      (0x0f)
#define DMA1_IDMDST_REG      (0x0f)
#define DMA1_ZRAM2DST_REG    (0x0f)

#define DMA1_CNTR_LO_REG     (0x10)
#define DMA1_CNTR_HI_REG     (0x11)
#define DMA1_MODE_REG        (0x12)
#define DMA1_COMMAND_REG     (0x13)

/*-----------------------------------------------------------------------------*/
/*DMA2 CNTRL																																	 */
/*-----------------------------------------------------------------------------*/
#define DMA2_SRCADDR0_REG    (0x14)
#define DMA2_SRCADDR1_REG    (0x15)
#define DMA2_SRCADDR2_REG    (0x16)
#define DMA2_SRCADDR3_REG    (0x17)
#define DMA2_SRCADDR4_REG    (0x18)
#define DMA2_IPMSRC_REG      (0x18)
#define DMA2_IDMSRC_REG      (0x18)
#define DMA2_ZRAM2SRC_REG    (0x18)

#define DMA2_DSTADDR0_REG    (0x19)
#define DMA2_DSTADDR1_REG    (0x1a)
#define DMA2_DSTADDR2_REG    (0x1b)
#define DMA2_DSTADDR3_REG    (0x1c)
#define DMA2_DSTADDR4_REG    (0x1d)
#define DMA2_IPMDST_REG      (0x1d)
#define DMA2_IDMDST_REG      (0x1d)
#define DMA2_ZRAM2DST_REG    (0x1d)

#define DMA2_CNTR_LO_REG     (0x1e)
#define DMA2_CNTR_HI_REG     (0x1f)
#define DMA2_MODE_REG        (0x20)
#define DMA2_COMMAND_REG     (0x21)

/*-----------------------------------------------------------------------------*/
/*CTC1		  																																	 */
/*-----------------------------------------------------------------------------*/
#define CTC1_PRESCALE_REG                   (0x22)			/* default 0xxxxxxxb */
/* Bit 7 Enable/Disable */
#define CTC1_ENABLE				       0x80
/* Bit 6-0 Prescaler.  Clk source of CTC1 is from undivided MCU CLK */
/* Divide by 1 - 128 */

#define CTC1_PERIOD_LO_REG                  (0x23)			/* default 0xXX */
/* Bit 7-0 TPERIOD[7:0] period low register */

#define CTC1_PERIOD_HI_REG                  (0x24)			/* default 0xXX */
/* Bit 7-0 TPERIOD[15:8] period high register */

/*-----------------------------------------------------------------------------*/
/*IRQ STATUS																																	 */
/*-----------------------------------------------------------------------------*/
#define IRQ_STATUS_REG       		        0x25   		/* default 0x00 */
/*write 1 to any bit will clear the bit */
#define IRQ_STATUS_CTC_PENDING				0x80
#define IRQ_STATUS_DMA2_HALF_PENDING		0x40
#define IRQ_STATUS_DMA2_END_PENDING			0x20
#define IRQ_STATUS_DMA1_HALF_PENDING		0x10
#define IRQ_STATUS_DMA1_END_PENDING			0x08
#define IRQ_STATUS_SIRQ_PENDING				0x04
#define IRQ_STATUS_RESERVED					0x02
#define IRQ_STATUS_RESET_DMA1_DMA2			0x01	/* Reset the DMA statemachine.  Reverts to 0 */

/*-----------------------------------------------------------------------------*/
/*MASTER INTERRUPT CONTROL																										 */
/*-----------------------------------------------------------------------------*/
#define MINT_STATUS_REG    		       (0x26)		/* default 0x00 */
/* Bit 7-0 */
#define MINT_STATUS_ADC					0x80
#define MINT_STATUS_KEYBOARD		    0x40
#define MINT_STATUS_RTC					0x20
#define MINT_STATUS_DMA_CTC			    0x10
#define MINT_STATUS_I2C					0x08
#define MINT_STATUS_SIRQ				0x08
#define MINT_STATUS_SPI					0x08
#define MINT_STATUS_USB					0x04
#define MINT_STATUS_UART				0x02
#define MINT_STATUS_IR					0x02
#define MINT_STATUS_SPDIF				0x02
#define MINT_STATUS_DSP					0x01

#define MINT_ENABLE_REG      		   (0x27)		/* default 0x00 */
/* Bit 7-0 */
#define MINT_ENABLE_ADC					0x80
#define MINT_ENABLE_KEYBOARD		    0x40
#define MINT_ENABLE_RTC					0x20
#define MINT_ENABLE_DMA_CTC			    0x10
#define MINT_ENABLE_I2C					0x08
#define MINT_ENABLE_SIRQ				0x08
#define MINT_ENABLE_SPI					0x08
#define MINT_ENABLE_USB					0x04
#define MINT_ENABLE_UART				0x02
#define MINT_ENABLE_IR					0x02
#define MINT_ENABLE_SPDIF				0x02
#define MINT_ENABLE_DSP					0x01

/*-----------------------------------------------------------------------------*/
/*DSP CONTROL																																	 */
/*-----------------------------------------------------------------------------*/
#define DSP_STATUS_CONTROL_REG	0x2e
#define DSP_BOOTMODE_REG    		0x2f
#define DSP_HIP_REG0        		0x30
#define DSP_HIP_REG1        		0x31
#define DSP_HIP_REG2        		0x32
#define DSP_HIP_REG3        		0x33
#define DSP_HIP_REG4        		0x34
#define DSP_HIP_REG5        		0x35
#define DSP_HIP_REG6        		0x36
#define DSP_HIP_REG7        		0x37

/*-----------------------------------------------------------------------------*/
/*USB INTERFACE																																 */
/*-----------------------------------------------------------------------------*/
#define USB_RESCTRL_REG     	   (0x3e)
/* Bit 7 */
#define USB_RESCTRL_ENABLE          0x80
/* Bit 6-3 Reserved*/
/* Bit 2-0 */
#define USB_RESCTRL_1_8_K           0x07
#define USB_RESCTRL_1_7_K           0x06
#define USB_RESCTRL_1_6_K           0x05
#define USB_RESCTRL_1_5_K           0x04
#define USB_RESCTRL_1_4_K           0x03
#define USB_RESCTRL_1_3_K           0x02
#define USB_RESCTRL_1_2_K           0x01
#define USB_RESCTRL_1_1_K           0x00

#define USB_STATUS_CONTROL_REG     (0x50)
/* Bit 7-0 */
#define USB_CONTROL_SUSPEND         0x80
#define USB_STATUS_POWER            0x40
#define USB_STATUS_DPLUS_LEVEL      0x20
#define USB_STATUS_DMINUS_LEVEL     0x10
#define USB_STATUS_BUS_ACTIVE       0x08
#define USB_CONTROL_FORCE_DRIVE     0x04
#define USB_CONTROL_FORCE_DPLUS     0x02
#define USB_CONTROL_FORCE_DMINUS    0x01

#define USB_DEVADDR_REG     	   (0x51)
/* Bit 7 */
#define USB_DEVADDR_ENABLE     	    0x80
/* Bit 6-0 */
#define USB_DEVADDR_MASK     	    0x7F

#define USB_INT_STATUS_REG  	   (0x52)
/* Bit 7-4 */
#define USB_INT_BUS_RESET  	        0x80
#define USB_INT_BUS_CON_DISC        0x40
#define USB_INT_EP0_SETUP  	        0x20
#define USB_INT_WAKEUP_IRQ 	        0x10
/* Bit 3-0 Reserved */

#define USB_EP_STATUS_REG   	   (0x53)
/* Bit 7-0 */
#define USB_EP_ENDPOINT3_OUT        0x80
#define USB_EP_ENDPOINT3_IN         0x40
#define USB_EP_ENDPOINT2_OUT        0x20
#define USB_EP_ENDPOINT2_IN         0x10
#define USB_EP_ENDPOINT1_OUT        0x08
#define USB_EP_ENDPOINT1_IN         0x04
#define USB_EP_CONTROL_WRITE        0x02
#define USB_EP_CONTROL_READ         0x01

#define USB_FRAME_HI_REG    	   (0x54)
/* Bit 7 */
#define USB_FRAME_HI_CRC5_CHECK     0x80
/* Bit 6-3 Reserved */
/* Bit 2-0 */
#define USB_FRAME_HI_MASK           0x07

#define USB_FRAME_LO_REG    	   (0x55)
/* Bit 7-0 */

#define USB_RESERVED56_REG  	   (0x56)

#define USB_SETUP_STATUS_REG	   (0x57)
/* Bit 7-4 */
#define USB_SETUP_DATA_TOGGLE	    0x80
#define USB_SETUP_DATA_VALID  	    0x40
#define USB_SETUP_IGNORE_TOKEN	    0x20
#define USB_SETUP_ACK_TX    	    0x10
/* Bit 3-0 */
#define USB_SETUP_DATA_COUNT_MASK   0x0F

#define USB_SETUP_DATA0_REG 	   (0x58)
#define USB_SETUP_DATA1_REG 	   (0x59)
#define USB_SETUP_DATA2_REG 	   (0x5a)
#define USB_SETUP_DATA3_REG 	   (0x5b)
#define USB_SETUP_DATA4_REG 	   (0x5c)
#define USB_SETUP_DATA5_REG 	   (0x5d)
#define USB_SETUP_DATA6_REG 	   (0x5e)
#define USB_SETUP_DATA7_REG 	   (0x5f)

#define USB_EPI_REG         	   (0x60)
/* Bit 7-3 reserved */
/* Bit 2-0 */
#define USB_EPI_ENDPOINT3_OUT       0x07
#define USB_EPI_ENDPOINT3_IN        0x06
#define USB_EPI_ENDPOINT2_OUT       0x05
#define USB_EPI_ENDPOINT2_IN        0x04
#define USB_EPI_ENDPOINT1_OUT       0x03
#define USB_EPI_ENDPOINT1_IN        0x02
#define USB_EPI_CONTROL_WRITE       0x01
#define USB_EPI_CONTROL_READ        0x00

#define USB_EPI_MODE_REG    	   (0x61)
/* Bit 7-3 (2) reserved */
/* Bit 2 if EP1IN or EP2IN or EP3IN */
#define USB_EPI_MODE_ISONBR         0x04
/* Bit 1 if EP1IN or EP2IN or EP3IN or EP1OUT or EP2OUT or EP3OUT */
#define USB_EPI_MODE_ISO            0x02
/* Bit 1 if EPI=0 or 1*/
#define USB_EPI_MODE_COMPLETE       0x02
/* Bit 0 Common */
#define USB_EPI_MODE_STALL          0x01

#define USB_EPI_START_ADDR_HI_REG  (0x62)
#define USB_EPI_START_ADDR_LO_REG  (0x63)

#define USB_EPI_CNTR_HI_REG 	   (0x64)
#define USB_EPI_CNTR_LO_REG 	   (0x65)

#define USB_EPI_MPS_REG     	   (0x66)
/* Bit 7-6 */
#define USB_EPI_MPS_SPR             0x80    /* Read  */
#define USB_EPI_MPS_FORCE_TOGGLE    0x80    /* Write */
#define USB_EPI_MPS_NEW_TOGGLE      0x40    /* Read  */
#define USB_EPI_MPS_CURRENT_TOGGLE  0x40    /* Write */
/* Bit 5-0 Maximum Packet Size */
#define USB_EPI_MPS_MASK            0x3F


#define USB_RESERVED67_REG  	   (0x67)

#define USB_EPI_EPSBR_REG   	   (0x68)
/* Bit 7-0 */
#define USB_EPI_EPSBR_EP3_OUT       0x80
#define USB_EPI_EPSBR_EP3_IN        0x40
#define USB_EPI_EPSBR_EP2_OUT       0x20
#define USB_EPI_EPSBR_EP2_IN        0x10
#define USB_EPI_EPSBR_EP1_OUT       0x08
#define USB_EPI_EPSBR_EP1_IN        0x04
#define USB_EPI_EPSBR_CTL_WRITE     0x02
#define USB_EPI_EPSBR_CTL_READ      0x01

#define USB_EPI_EPSNS_REG   	   (0x69)
/* Bit 7-0 */
#define USB_EPI_EPSNS_EP3_OUT_NAK   0x80
#define USB_EPI_EPSNS_EP3_IN_NAK    0x40
#define USB_EPI_EPSNS_EP2_OUT_NAK   0x20
#define USB_EPI_EPSNS_EP2_IN_NAK    0x10
#define USB_EPI_EPSNS_EP1_OUT_NAK   0x08
#define USB_EPI_EPSNS_EP1_IN_NAK    0x04
#define USB_EPI_EPSNS_CTL_WRITE     0x02
#define USB_EPI_EPSNS_CTL_READ      0x01

#define USB_EPI_EPSST_REG   	   (0x6a)
/* Bit 7-0 */
#define USB_EPI_EPSST_EP3_OUT_STALL 0x80
#define USB_EPI_EPSST_EP3_IN_STALL  0x40
#define USB_EPI_EPSST_EP2_OUT_STALL 0x20
#define USB_EPI_EPSST_EP2_IN_STALL  0x10
#define USB_EPI_EPSST_EP1_OUT_STALL 0x08
#define USB_EPI_EPSST_EP1_IN_STALL  0x04
#define USB_EPI_EPSST_CTL_WRITE     0x02
#define USB_EPI_EPSST_CTL_READ      0x01

#define USB_IRQSTATUS_REG     	   (0x6b)

#define USB_JOHNDOE1_REG     	   (0x6c)
#define USB_JOHNDOE2_REG     	   (0x6e)
#define USB_JOHNDOE3_REG     	   (0x6f)

#define USB_RESERVED76_REG  	   (0x76)

/*-----------------------------------------------------------------------------*/
/*(SAMSUNG) NAND FLASH SMC																										 */
/*-----------------------------------------------------------------------------*/
#define NAND_ENABLE_REG    		 		   (0x28)		/* default 0x00 */
/* Bit 7-4 reserved */
/* Bit 3-0 */                 	
#define NAND_ENABLE_CE3_INV		 			0x08
#define NAND_ENABLE_CE2_INV		 			0x04
#define NAND_ENABLE_CE1_INV		 			0x02
#define NAND_ENABLE_STATE_MACHINE		    0x01

#define NAND_CEMODE_REG    		 		   (0x29)		/* default 0x00 */
/* Bit 7-4 reserved */
/* Bit 3-0 Set new mode or old mode for banks */
#define NAND_CE_NEW_MODE_CE3	 			0x08
#define NAND_CE_NEW_MODE_CE2	 			0x04
#define NAND_CE_NEW_MODE_CE1	 			0x02
#define NAND_CEMODE_FLASH_TYPE			    0x01

#define NAND_CMD_REG       				   (0x2a)
#define NAND_CA_REG        				   (0x2b)
#define NAND_RA_REG        				   (0x2c)
#define NAND_BA_REG1       				   (0x2d)
#define NAND_BA_REG2       				   (0xec)
#define NAND_ECCCTRL_REG   				   (0xcc)
#define NAND_ECC_REG0      				   (0xcd)
#define NAND_ECC_REG1      				   (0xce)
#define NAND_ECC_REG2      				   (0xcf)

/*-----------------------------------------------------------------------------*/
/*I2C INTERFACE																																 */
/*-----------------------------------------------------------------------------*/
#define I2C_CONTROL_REG      				(0x7a)      /* default 0x00 */
/* Bit 7-4 */
#define I2C_CONTROL_ENABLE				0x80
#define I2C_CONTROL_FAST_ENABLE				0x40
#define I2C_CONTROL_IRQ_ENABLE  			0x20
#define I2C_CONTROL_SLAVE				0x10
/* Bit 3-2 Generate bus control in master mode */
#define I2C_CONTROL_REPEAT_START			0x0C
#define I2C_CONTROL_GENERATE_STOP			0x04
#define I2C_CONTROL_GENERATE_START			0x08
#define I2C_CONTROL_GENERATE_NONE			0x00
/* Bit 1-0 */
#define I2C_CONTROL_RELEASE_CLOCK_DATA	            0x02
#define I2C_CONTROL_ACK					0x01

#define I2C_STATUS_REG       				(0x7b)      /* default 0x00 */
/* Bit 7-0 */
#define I2C_STATUS_BUFFER				0x80
#define I2C_STATUS_STOP_BIT 				0x40
#define I2C_STATUS_START_BIT      			0x20
#define I2C_STATUS_READ_WRITE				0x10
#define I2C_STATUS_DATA_ADDRESS      			0x08
#define I2C_STATUS_IRQ_PENDING				0x04
#define I2C_STATUS_WRITE_COLLISION  	            0x02
#define I2C_STATUS_OVERFLOW				0x01

#define I2C_ADDR_REG         			        0x71
/* Bit 7-1 I2C Slave Address */
#define I2C_ADDR_SLAVE_ADDRESS_MASK                 0xfe
/* Bit 0 */
#define I2C_ADDR_READ_WRITE_CONTROL                 0x01

#define I2C_DATA_REG         				(0x7c)
/* Bit 7-0 Data/Address */

#define JOHNDOE5       				(0x7d)

/*-----------------------------------------------------------------------------*/
/*UART INTERFACE																																 */
/*-----------------------------------------------------------------------------*/
#define UART_CONTROL_REG      				(0x9d)

/*-----------------------------------------------------------------------------*/
/*KEY SCAN INTERFACE																													 */
/*-----------------------------------------------------------------------------*/
#define KEYSCAN_DATA_REG                           (0xc0)      /* default 0xXX */
/* Bit 7-0 KeyScan Register 12Bytes to read a write will reset */

#define KEYSCAN_CTRL_REG                           (0xc1)      /* default 0x00 */
/* Bit 7 */
#define KEYSCAN_CTRL_ENABLE                         0x80
/* Bit 6-5 */
#define KEYSCAN_CTRL_DEBOUNCE_MASK                  0x60
#define KEYSCAN_CTRL_DEBOUNCE_320                   0x60
#define KEYSCAN_CTRL_DEBOUNCE_160                   0x40
#define KEYSCAN_CTRL_DEBOUNCE_80                    0x20
#define KEYSCAN_CTRL_DEBOUNCE_40                    0x00
/* Bit 4-0*/
#define KEYSCAN_CTRL_RESERVED1                      0x10
#define KEYSCAN_CTRL_RESERVED2                      0x08
#define KEYSCAN_CTRL_MASK_KEYIN2                    0x04
#define KEYSCAN_CTRL_MASK_KEYIN1                    0x02
#define KEYSCAN_CTRL_MASK_KEYIN0                    0x01

/*-----------------------------------------------------------------------------*/
/*GPIO AND MULTI FUNCTION CONFIGURATION										   */
/*-----------------------------------------------------------------------------*/
#define MFP_GPOA_SELECT_REG                        (0xee)     /* default 0x01 */
/* Bit 7-5 */
#define MFP_SELECT_MASK                             0xe0
#define MFP_SELECT_F4                               0x60
#define MFP_SELECT_F3                               0x40
#define MFP_SELECT_F2                               0x20
#define MFP_SELECT_F1                               0x00
/* Bit 4-3 */
#define MFP_SELECT_CS0S                             0x10
#define GPOA2_ENABLE                                0x08
/* Bit 2-0 */
#define GPOA2_OUTPUT_2                              0x04
#define GPOA2_OUTPUT_1                              0x02
#define GPOA2_OUTPUT_0                              0x01

#define GPIOB_CONFIG_REG                           (0xef)     /* default 0x00 */
/* Bit 7 */
#define GPIOB_CONFIG_RESERVED1                      0x80    /* DO NOT WRITE WITH 1 */
/* Bit 6-4 GPIO B6-4 enable or KEY02-KEY00 select*/
#define GPIOB_CONFIG_B6_INV                         0x40
#define GPIOB_CONFIG_B5_INV                         0x20
#define GPIOB_CONFIG_B4_INV                         0x10
/* Bit 3 */
#define GPIOB_CONFIG_RESERVED2                      0x08    /* DO NOT WRITE WITH 1 */
/* Bit 2-0 */
#define GPIOB_CONFIG_B2_INV                         0x04
#define GPIOB_CONFIG_B1_INV                         0x02
#define GPIOB_CONFIG_B0_INV                         0x01

#define GPIOB_OUTPUT_ENABLE_REG                    (0xf0)   /* default 0x00 */
/* Bit 7 */
#define GPIOB_OUTPUT_RESERVED1                      0x80    /* DO NOT WRITE WITH 1 */
/* Bit 6-4 GPIOB Output Enable */
#define GPIOB_OUTPUT_ENABLE_6                       0x40
#define GPIOB_OUTPUT_ENABLE_5                       0x20
#define GPIOB_OUTPUT_ENABLE_4                       0x10
/* Bit 3 */
#define GPIOB_OUTPUT_RESERVED2                      0x08    /* DO NOT WRITE WITH 1 */
/* Bit 2-0 GPIOB Output Enable */
#define GPIOB_OUTPUT_ENABLE_2                       0x04
#define GPIOB_OUTPUT_ENABLE_1                       0x02
#define GPIOB_OUTPUT_ENABLE_0                       0x01
#define GPIOB_OUTPUT_ENABLE_ALL         (GPIOB_OUTPUT_ENABLE_0 | GPIOB_OUTPUT_ENABLE_1 | GPIOB_OUTPUT_ENABLE_2 | GPIOB_OUTPUT_ENABLE_4 | GPIOB_OUTPUT_ENABLE_5 | GPIOB_OUTPUT_ENABLE_6)

#define GPIOB_INPUT_ENABLE_REG                     (0xf1)   /* default 0x00 */
/* Bit 7 */
#define GPIOB_INPUT_RESERVED1                       0x80    /* DO NOT WRITE WITH 1 */
/* Bit 6-4 GPIOB Input Enable */
#define GPIOB_INPUT_ENABLE_6                        0x40
#define GPIOB_INPUT_ENABLE_5                        0x20
#define GPIOB_INPUT_ENABLE_4                        0x10
/* Bit 3 */
#define GPIOB_INPUT_RESERVED2                       0x08    /* DO NOT WRITE WITH 1 */
/* Bit 2-0 GPIOB Input Enable */
#define GPIOB_INPUT_ENABLE_2                        0x04
#define GPIOB_INPUT_ENABLE_1                        0x02
#define GPIOB_INPUT_ENABLE_0                        0x01
#define GPIOB_INPUT_ENABLE_ALL          (GPIOB_INPUT_ENABLE_0 | GPIOB_INPUT_ENABLE_1 |GPIOB_INPUT_ENABLE_2 | GPIOB_INPUT_ENABLE_4 | GPIOB_INPUT_ENABLE_5 | GPIOB_INPUT_ENABLE_6)

#define GPIOB_DATA_REG                             (0xf2)   /* default 0x00 */
/* Bit 7-0 Data input output register */
#define GPIOB_DATA_RESERVED1                        0x80    /* DO NOT WRITE WITH 1 */
/* Bit 6-4 */
#define GPIOB_DATA_BIT_6                            0x40
#define GPIOB_DATA_BIT_5                            0x20
#define GPIOB_DATA_BIT_4                            0x10
/* Bit 3 */
#define GPIOB_DATA_RESERVED2                        0x08    /* DO NOT WRITE WITH 1 */
/* Bit 2-0  */
#define GPIOB_DATA_BIT_2                            0x04
#define GPIOB_DATA_BIT_1                            0x02
#define GPIOB_DATA_BIT_0                            0x01
#define GPIOB_DATA_BIT_MASK              (GPIOB_DATA_BIT_0 | GPIOB_DATA_BIT_1 | GPIOB_DATA_BIT_2 | GPIOB_DATA_BIT_4 | GPIOB_DATA_BIT_5 | GPIOB_DATA_BIT_6)


#define GPIOC_ENABLE_REG                           (0xf3)   /* default 0x07 */
/* Bit 7 */
#define GPIOC_ENABLE_RESERVED1                      0x80    /* DO NOT WRITE WITH 1 */
/* Bit 6-4 Input Enable*/
#define GPIOC_OUTPUT_ENABLE_2                       0x40
#define GPIOC_OUTPUT_ENABLE_1                       0x20
#define GPIOC_OUTPUT_ENABLE_0                       0x10
/* Bit 3 */
#define GPIOC_ENABLE_RESERVED2                      0x08    /* DO NOT WRITE WITH 1 */
/* Bit 2-0 Output Enable */
#define GPIOC_INPUT_ENABLE_2                        0x04
#define GPIOC_INPUT_ENABLE_1                        0x02
#define GPIOC_INPUT_ENABLE_0                        0x01

#define GPIOC_DATA_REG                             (0xf4)   /* default 0x03 */
/* Bit 7-3 Reserved */
#define GPIOC_DATA_RESERVED1                        0x80    /* DO NOT WRITE WITH 1 */
#define GPIOC_DATA_RESERVED2                        0x40    /* DO NOT WRITE WITH 1 */
#define GPIOC_DATA_RESERVED3                        0x20    /* DO NOT WRITE WITH 1 */
#define GPIOC_DATA_RESERVED4                        0x10    /* DO NOT WRITE WITH 1 */
#define GPIOC_DATA_RESERVED5                        0x08    /* DO NOT WRITE WITH 1 */
/* Bit 2-0  */
#define GPIOC_DATA_BIT_2                            0x04
#define GPIOC_DATA_BIT_1                            0x02
#define GPIOC_DATA_BIT_0                            0x01
#define GPIOC_DATA_BIT_MASK              (GPIOC_DATA_BIT_0 | GPIOC_DATA_BIT_1 | GPIOC_DATA_BIT_2)

/* Used in BRECF644.BIN */
#define JOHNDOE1                         (0xf5)
#define JOHNDOE2                         (0xf7)
#define JOHNDOE3                         (0xf8)
#define JOHNDOE4                         (0xfa)

#define GPIOG_ENABLE_REG                           (0xfe)   /* default 0x00 */
/* Bit 7-5 Reserved */
#define GPIOG_ENABLE_RESERVED1                      0x80    /* DO NOT WRITE WITH 1 */
#define GPIOG_ENABLE_RESERVED2                      0x40    /* DO NOT WRITE WITH 1 */
#define GPIOG_ENABLE_RESERVED3                      0x20    /* DO NOT WRITE WITH 1 */
/* Bit 4 Input Enable*/
#define GPIOG_OUTPUT_ENABLE_0                       0x10
/* Bit 3-1 */
#define GPIOG_ENABLE_RESERVED4                      0x08    /* DO NOT WRITE WITH 1 */
#define GPIOG_ENABLE_RESERVED5                      0x04    /* DO NOT WRITE WITH 1 */
#define GPIOG_ENABLE_RESERVED6                      0x02    /* DO NOT WRITE WITH 1 */
/* Bit 0 Output Enable */
#define GPIOG_INPUT_ENABLE_0                        0x01

#define GPIOG_DATA_REG                             (0xff)   /* default 0x00 */
/* Bit 7-1 Reserved */
#define GPIOG_DATA_RESERVED1                        0x80    /* DO NOT WRITE WITH 1 */
#define GPIOG_DATA_RESERVED2                        0x40    /* DO NOT WRITE WITH 1 */
#define GPIOG_DATA_RESERVED3                        0x20    /* DO NOT WRITE WITH 1 */
#define GPIOG_DATA_RESERVED4                        0x10    /* DO NOT WRITE WITH 1 */
#define GPIOG_DATA_RESERVED5                        0x08    /* DO NOT WRITE WITH 1 */
#define GPIOG_DATA_RESERVED6                        0x04    /* DO NOT WRITE WITH 1 */
#define GPIOG_DATA_RESERVED7                        0x02    /* DO NOT WRITE WITH 1 */
/* Bit 0  */
#define GPIOG_DATA_BIT_0                            0x01
#define GPIOG_DATA_BIT_MASK              (GPIOG_DATA_BIT_0)

/*-----------------------------------------------------------------------------*/
/*RTC/LOSC/WATCHDOG																														 */
/*-----------------------------------------------------------------------------*/
#define RTC_CONTROL_REG                            (0x43)   /* default 0x04 */
/* Bit 7-0 */
#define RTC_CONTROL_ALARM_ENABLE			0x80
#define RTC_CONTROL_TIMER_ENABLE 			0x40
#define RTC_CONTROL_IRQ2HZEN_ENABLE      		0x20
#define RTC_CONTROL_CLEAR_RTC_COUNT			0x10
#define RTC_CONTROL_LOAD_RTC_COUNT      		0x08
#define RTC_CONTROL_RESERVED1				0x04
#define RTC_CONTROL_RESERVED2  	                    0x02
#define RTC_CONTROL_OVERFLOW				0x01

#define RTC_IRQSTATUS_REG                          (0x44)   /* default 0x00 */
/* Bit 7-0 */
#define RTC_IRQSTATUS_XTAL_OSC_ENABLE		0x80
#define RTC_IRQSTATUS_CLK_SOURCE 			0x40
#define RTC_IRQSTATUS_RESERVED1      		    0x20
#define RTC_IRQSTATUS_RESERVED2			    0x10
#define RTC_IRQSTATUS_RESERVED3      		    0x08
#define RTC_IRQSTATUS_RTC_ALARM_IRQ			0x04
#define RTC_IRQSTATUS_RTC_TIMER_IRQ  	            0x02
#define RTC_IRQSTATUS_2HZ_IRQ				0x01

#define RTC_TIME_LO_REG                            (0x45)
#define RTC_TIME_MI_REG                            (0x46)
#define RTC_TIME_HI_REG                            (0x47)

#define RTC_ALARM_LO_REG                           (0x48)   /* default 0x22 */
#define RTC_ALARM_MI_REG                           (0x49)   /* default 0x22 */
#define RTC_ALARM_HI_REG                           (0x4a)   /* default 0x22 */

#define LOSC_DIV_LO_REG                            (0x4b)   /* default 0x22 */
#define LOSC_DIV_MI_REG                            (0x4c)   /* default 0x22 */
#define LOSC_DIV_HI_REG                            (0x4d)   /* default 0x22 */

#define WATCHDOG_REG                               (0x4e)   /* default 0x22 */
/* Bit 7 */
#define WATCHDOG_ENABLE            		0x80
/* Bit 6-4 Watch dog timer select */
#define WATCHDOG_MASK          	    		0x70
#define WATCHDOG_180S          	 		0x70
#define WATCHDOG_90S      	            0x60
#define WATCHDOG_45S	        	    0x50
#define WATCHDOG_22_2S          	    0x40
#define WATCHDOG_5_6S			       0x30
#define WATCHDOG_1_4S  	                       0x20
#define WATCHDOG_0_352S			0x10
#define WATCHDOG_0_176S			0x00
/* Bit 3-0 */
#define WATCHDOG_RESET      		0x08
#define WATCHDOG_RESERVED1		0x04
#define WATCHDOG_RESERVED2		0x02
#define WATCHDOG_RESERVED3		0x01

/*-----------------------------------------------------------------------------*/
/*HOSC/PLL																																		 */
/*-----------------------------------------------------------------------------*/
#define HFC_CONTROL_REG      0x40   /* def=04h */
#define PLL_PERFORMANCE_REG  0x41   /* def=55h */
#define PLL_CONTROL_REG      (0x42)

/*-----------------------------------------------------------------------------*/
/*PMU/DC-DC																																		 */
/*-----------------------------------------------------------------------------*/
#define VOLTAGE_CONTROL_REG  0x3f
/* def=0ech (DCDC_CONTROL_REG) */
#define DCDC_CONTROL_REG     0x4f
/* def=0101b */
#define BATTERY_MON_REG      0xd0
/* def=28h */
/* define POWER_CONTROL_REG   0dfh */
#define  POWER_CONTROL_REG   0xdf

/*-----------------------------------------------------------------------------*/
/*ADC/DAC/HEADPHONE																														 */
/*-----------------------------------------------------------------------------*/
#define DAC_CONTROL_REG1    0x80  /* def=03h */
#define DAC_RATECTRL_REG    0x81  /* write only */
#define DAC_PCMOUT_LO_REG   0x88  /* write only */
#define DAC_PCMOUT_MI_REG   0x89  /* write only */
#define DAC_PCMOUT_HI_REG   0x8a  /* def=15h */
#define FIFO_STATUS_REG     0x8b  /* def=07h */
#define DAC_CONTROL_REG2    0x91

/*-----------------------------------------------------------------------------*/
/*DAC ANALOG																																	 */
/*-----------------------------------------------------------------------------*/
/* def=40h */
#define DACA_VOLCTRL_REG  0x9e
#define DACA_BLKCTRL_REG  0xdd

/*-----------------------------------------------------------------------------*/
/*ADC																																					 */
/*-----------------------------------------------------------------------------*/
#define ADC_DATA_REG         0x9a   /* read only */
#define SARADC_CONTROL_REG   0xd1   /* def=04h */
#define ADC_PERFORMANCE_REG  0xd3   /* def=03h */
#define ADC_MODULEPERF_REG   0x9f   /* def=5dh */
#define ADC_CONTROL_REG1     0xd4   /* def=05h */
#define ADC_CONTROL_REG2     0xd5
#define ADC_GAINCTRL_REG     0xd6   /* def=55h */
#define ADC_FIFOCTRL_REG     0xd7
#define ADC_BUSCTRL_REG      0x9b
#define LRADC_DATA_REG       0xd8   /* read only */
#define SARADC_IRQCTRL_REG   0xde   /* write (def=80h) */
#define SARADC_IRQSTAT_REG   0xde   /* read (def=80h) */

#endif /*__ATJ2085_PORTS_H__*/
