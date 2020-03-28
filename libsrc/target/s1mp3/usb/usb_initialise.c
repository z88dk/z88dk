
#include <ATJ2085_Ports.h>
#include <drivers/usb.h>

void USB_Initialise( void )
{
#asm
    	; Enable USB resistor pullups
	ld      a, USB_RESCTRL_1_5_K
	or      a, USB_RESCTRL_ENABLE
	out     (USB_RESCTRL_REG), a

	ld	a, 0xff
	out	(USB_INT_STATUS_REG), a
	out	(USB_EP_STATUS_REG), a
    	out	(USB_EPI_EPSNS_REG), a
    	out	(USB_EPI_EPSST_REG), a

        xor	a
        out	(USB_EPI_CNTR_HI_REG), a
        ld	a, 0x40
        out	(USB_EPI_CNTR_LO_REG), a

        xor	a
        out	(CTC1_PRESCALE_REG), a
        out	(CTC1_PERIOD_LO_REG), a
        ld	a, 0x30
        out	(CTC1_PERIOD_HI_REG), a

    	; Enable USB Interrupt in Master Interrupt Register
	in      a, (MINT_ENABLE_REG)
	or      a, MINT_ENABLE_USB
	out     (MINT_ENABLE_REG), a
#endasm
}
