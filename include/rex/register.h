/****************************************************************
 *		register.h					*
 *			Header for Rex addin program.		*
 *								*
 ****************************************************************/

#ifndef _REGISTER_
#define _REGISTER_


extern int __LIB__ output8(int, int);
extern int __LIB__ input8(int);

#define REGISTER_WRITE( arg1, arg2 )		output8( arg1, arg2 )
#define REGISTER_READ( arg1 )			input8( arg1 )


#define REG_MEMTYPE				0x00
#define REG_BANK1_LO				0x01
#define REG_BANK1_HI				0x02
#define REG_BANK2_LO				0x03
#define REG_BANK2_HI				0x04
#define REG_INT_REGDAT				0x05
#define REG_INT_REGRST				0x06
#define REG_INT_MASK				0x07
#define REG_HALT				0x08
#define REG_FRC					0x09
#define REG_EXEC				0x0a
#define REG_EXT_CTRL				0x0b
#define REG_BLD_CTRL				0x0c
#define REG_KI_DATA				0x10
#define REG_KO_DATA				0x11
#define REG_P_DATA				0x12
#define REG_P_IOSET				0x13
#define REG_P_OUTSET				0x14
#define REG_ALM					0x15
#define REG_MELODY				0x16
#define REG_MELFRQ_LO				0x17
#define REG_MELFRQ_HI				0x18
#define REG_MLDALM				0x19
#define REG_RMT_CTRL1				0x1a
#define REG_RMT_CTRL2				0x1b
#define REG_RMT_CTRL3				0x1c
#define REG_SIOCLK				0x1d
#define REG_RTC					0x1f
#define REG_SRLCD_DSP				0x20
#define REG_SRLCD_SEG				0x21
#define REG_SRLCD_LO				0x22
#define REG_SRLCD_HI				0x23
#define REG_SRLCD_COM				0x24
#define REG_RMLCD_SEG1				0x25
#define REG_RMLCD_SEG2				0x27
#define REG_RMLCD_SEG3				0x29
#define REG_RMLCD_COM				0x2b
#define REG_DRV_CTRL				0x2d
#define	REG_RTC_1SEC				0x30
#define REG_RTC_10SEC				0x31
#define REG_RTC_1MIN				0x32
#define REG_RTC_10MIN				0x33
#define REG_RTC_1HR				0x34
#define REG_RTC_10HR				0x35
#define REG_RTC_DAY				0x36
#define REG_RTC_1DAY				0x37
#define REG_RTC_10DAY				0x38
#define REG_RTC_1MON				0x39
#define REG_RTC_10MON				0x3a
#define REG_RTC_1YR				0x3b
#define REG_RTC_10YR				0x3c
#define REG_RTC_PAGE				0x3d
#define REG_RTC_TEST				0x3e
#define REG_RTC_RESET				0x3f
#define	REG_RTC_24				0x3a
#define REG_RTC_URU				0x3b
#define REG_SIO_RDB				0x40
#define REG_SIO_TDB				0x40
#define REG_SIO_DLL				0x40
#define REG_SIO_IER				0x41
#define REG_SIO_DLM				0x41
#define REG_SIO_IIR				0x42
#define REG_SIO_LCR				0x43
#define REG_SIO_MCR				0x44
#define REG_SIO_LSR				0x45
#define REG_SIO_MSR				0x46
#define REG_SIO_SCR				0x47

/* LCDC I/O & RS232C Driver */
#define REG_LCEN 				0x50
#define REG_LCMD        			0x51

/* Key Scan */
#define REG_SCNEN				0x60
#define REG_ATPC				0x68
#define REG_COLD				0x69
#define REG_COLU				0x6A
#define REG_ROWD				0x6B
#define REG_ROWU				0x6C

/* Card Status Register */
#define REG_CDSTS        			0x70


#define MemoryType16M				0x00
#define MemoryType32M				(1<<0)


#define InterruptRegisterKEY			(1<<0)
#define InterruptRegisterRTC			(1<<1)
#define InterruptRegisterSIO			(1<<2)
#define InterruptRegisterBLD			(1<<3)
#define InterruptRegisterTIM1			(1<<4)
#define InterruptRegisterTIM64			(1<<5)
#define InterruptRegisterTIM8K			(1<<6)
#define InterruptRegisterEXT			(1<<7)


#define InterruptMaskKEY			(1<<0)
#define InterruptMaskRTC			(1<<1)
#define InterruptMaskSIO			(1<<2)
#define InterruptMaskBLD			(1<<3)
#define InterruptMaskTIM1			(1<<4)
#define InterruptMaskTIM64			(1<<5)
#define InterruptMaskTIM8K			(1<<6)
#define InterruptMaskEXT			(1<<7)


#define HaltSettingStop				0x00
#define HaltSettingIdle				0x01


#define KinputDataKI0				(1<<0)
#define KinputDataKI1				(1<<1)
#define	KinputDataKI2				(1<<2)
#define	KinputDataKI3				(1<<3)
#define KinputDataKI4				(1<<4)
#define KinputDataKI5				(1<<5)
#define KinputDataKI6				(1<<6)
#define KinputDataKI7				(1<<7)


#endif


