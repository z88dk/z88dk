/*
  09/03/2006 22:02:
  fc: Fixed indexes in ISR_Install() & ISR_Remove().

  01/03/2006 20:01
  fc: Fixed the differents interrupts handler.
      Added a retargetable mechanism so a handler can be installed by a third party application.
      It's a primitive way but we aren't using multitasking, are we ?
*/

#include <ATJ2085_Ports.h>
#include <drivers/isr.h>
#include <drivers/rtc.h>
#include <drivers/usb.h>

/* Minimal default ISR handlers */
/* --- */
void DEFAULT_ADC_ISR( void ) {
#asm
	in	a, (SARADC_IRQSTAT_REG)
	out	(SARADC_IRQCTRL_REG), a
#endasm
}

/* --- */
void DEFAULT_KEYBOARD_ISR( void ) {
#asm
	ld	a, MINT_STATUS_KEYBOARD
	out     (MINT_STATUS_REG), a
#endasm
}

/* --- */
void DEFAULT_RTC_ISR( void ) {
#asm
	in	a, (RTC_IRQSTATUS_REG)
	out	(RTC_IRQSTATUS_REG), a
#endasm
}

/* --- */
void DEFAULT_DMA_CTC_ISR( void ) {
#asm
	in	a, (IRQ_STATUS_REG)
	out	(IRQ_STATUS_REG), a
#endasm
}

/* --- */
void DEFAULT_UART_ISR( void ) {
#asm
	in	a, (UART_CONTROL_REG)
	out	(UART_CONTROL_REG), a
#endasm
}

/* --- */
void DEFAULT_USB_ISR( void ) {
#asm
	in	a, (USB_IRQSTATUS_REG)
	out	(USB_IRQSTATUS_REG), a
#endasm
}

/* --- */
void DEFAULT_I2C_ISR( void ) {
#asm
	in	a, (I2C_CONTROL_REG)
	out	(I2C_CONTROL_REG), a
#endasm
}

/* --- */
void DEFAULT_DSP_ISR( void ) {
#asm
	ld      a, MINT_STATUS_DSP
	out	(MINT_STATUS_REG), a
#endasm
}

void *_Current_ISR_Table[] = {
	DEFAULT_ADC_ISR,
	DEFAULT_KEYBOARD_ISR,
	DEFAULT_RTC_ISR,
	DEFAULT_DMA_CTC_ISR,
	DEFAULT_UART_ISR,
	DEFAULT_USB_ISR,
	DEFAULT_I2C_ISR,
	DEFAULT_DSP_ISR
};

void *_Default_ISR_Table[] = {
	DEFAULT_ADC_ISR,
	DEFAULT_KEYBOARD_ISR,
	DEFAULT_RTC_ISR,
	DEFAULT_DMA_CTC_ISR,
	DEFAULT_UART_ISR,
	DEFAULT_USB_ISR,
	DEFAULT_I2C_ISR,
	DEFAULT_DSP_ISR
};

void _ISR_Handler(void) {
#asm
	in	a, (MINT_STATUS_REG)
	rla
	jp	nc, no_adc_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_ADC)
	push	hl
	ret
no_adc_isr:
	rla
	jp	nc, no_keyboard_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_KEYBOARD)
	push	hl
	ret
no_keyboard_isr:
	rla
	jp	nc, no_rtc_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_RTC)
	push	hl
	ret
no_rtc_isr:
	rla
	jp	nc, no_dma_ctc_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_DMA_CTC)
	push	hl
	ret
no_dma_ctc_isr:
	rla
	jp	nc, no_uart_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_UART)
	push	hl
	ret
no_uart_isr:
	rla
	jp	nc, no_usb_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_USB)
	push	hl
	ret
no_usb_isr:
	rla
	jp	nc, no_i2c_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_I2C)
	push	hl
	ret
no_i2c_isr:
	rla
	jp	nc, no_dsp_isr
	ld	hl, (__Current_ISR_Table + ISR_HANDLER_DSP)
	push	hl
	ret
no_dsp_isr:
#endasm

}

/* --- */
void misr( void ) {
#asm
misr_start:
	di
	ex	af, af
	exx
	call	__ISR_Handler
	exx
	ex	af, af
	ei
	reti
misr_end:
#endasm
}

void nmisr( void ) {
#asm
nmisr_start:
	retn
nmisr_end:
#endasm
}

/* 
  Set interrupts to IM 1, i.e. MI to 0x0038, NMI to 0x066
*/
void ISR_Initialise( void ) {
#asm
	di

	im	1

	; Copy ISR to 0x0038
	ld	hl, misr_start
	ld	de, 0x0038
	ld	bc, misr_end - misr_start
	ldir

	; Copy NMI ISR to 0x0066
	ld	hl, nmisr_start
	ld	de, 0x0066
	ld	bc, nmisr_end - nmisr_start
	ldir
#endasm
}

/*
  Install an user interrupt
*/
int ISR_Install(int Int_Number, void *Proc) {
	if(Int_Number >= ISR_HANDLER_ADC && Int_Number <= ISR_HANDLER_DSP) {
		#asm
			di
		#endasm
		_Current_ISR_Table[Int_Number >> 1] = Proc;
		#asm
			ei
		#endasm
		return(1);
	}
	return(0);
}

/*
  Restore the system interrupt
  (All must be restored forcibly right after program's end).
*/
int ISR_Remove(int Int_Number) {
	if(Int_Number >= ISR_HANDLER_ADC && Int_Number <= ISR_HANDLER_DSP) {
		#asm
			di
		#endasm
			_Current_ISR_Table[Int_Number  >> 1] = _Default_ISR_Table[Int_Number  >> 1];
		#asm
			ei
		#endasm
		return(1);
	}
	return(0);
}
