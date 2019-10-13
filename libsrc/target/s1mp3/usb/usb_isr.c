/****************************************************************************************/
/*  Example Source Code for USB Enumeration using a PDIUSBD11 connected to a PIC16F87x	*/
/*  Copyright 2002 Craig Peacock, Craig.Peacock@beyondlogic.org                         */
/*  Version 1.2, 6th April 2002 http://www.beyondlogic.org                              */
/****************************************************************************************/

#include <stdio.h>
#include <string.h>
#include <drivers/ioport.h>
#include <drivers/usb.h>
#include "usbfull.h"
#include <ATJ2085_Ports.h>

void EP0SETUPInterrupt( void );

USB_DEVICE_DESCRIPTOR DeviceDescriptor = {
    USB_DEVICE_DESCRIPTOR_SIZE,     /* bLength */
    TYPE_DEVICE_DESCRIPTOR,         /* bDescriptorType */
    0x0110,                         /* bcdUSB USB Version 1.1 */
    0,                              /* bDeviceClass */
    0,                              /* bDeviceSubclass */
    0,                              /* bDeviceProtocol */
    8,                              /* bMaxPacketSize 8 Bytes */
    0x04B4,                         /* idVendor (Cypress Semi) */
    0x0002,                         /* idProduct (USB Thermometer Example) */
    0x0000,                         /* bcdDevice */
    1,                              /* iManufacturer String Index */
    0,                              /* iProduct String Index */
    0,                              /* iSerialNumber String Index */
    1                               /* bNumberConfigurations */
};

#ifdef oldone
USB_CONFIG_DATA ConfigurationDescriptor = {
    {                                   /* configuration descriptor */
    USB_CONFIGURATION_DESCRIPTOR_SIZE,  /* bLength */
    TYPE_CONFIGURATION_DESCRIPTOR,      /* bDescriptorType */
    USB_CONFIG_DATA_SIZE,               /* wTotalLength */
    1,                                  /* bNumInterfaces */
    1,                                  /* bConfigurationValue */
    0,                                  /* iConfiguration String Index */
    0x80,                               /* bmAttributes Bus Powered, No Remote Wakeup */
    0x32                                /* bMaxPower, 100mA */
    },
    {                              /* interface descriptor */
    USB_INTERFACE_DESCRIPTOR_SIZE, /* bLength */
    TYPE_INTERFACE_DESCRIPTOR,     /* bDescriptorType */
    0,                             /* bInterface Number */
    0,                             /* bAlternateSetting */
    2,                             /* bNumEndpoints */
    0xFF,                          /* bInterfaceClass (Vendor specific) */
    0xFF,                          /* bInterfaceSubClass */
    0xFF,                          /* bInterfaceProtocol */
    0                              /* iInterface String Index */
    },
    {                              /* endpoint descriptor */
    USB_ENDPOINT_DESCRIPTOR_SIZE,  /* bLength */
    TYPE_ENDPOINT_DESCRIPTOR,      /* bDescriptorType */
    0x01,                          /* bEndpoint Address EP1 OUT */
    0x02,                          /* bmAttributes - Interrupt */
    0x0008,                        /* wMaxPacketSize */
    0x00                           /* bInterval */
    },
    {                              /* endpoint descriptor */
    USB_ENDPOINT_DESCRIPTOR_SIZE,  /* bLength */
    TYPE_ENDPOINT_DESCRIPTOR,      /* bDescriptorType */
    0x81,                          /* bEndpoint Address EP1 IN */
    0x02,                          /* bmAttributes - Interrupt */
    0x0008,                        /* wMaxPacketSize */
    0x00                           /* bInterval */
    }
};
#endif

#define SIZEOF_CONFIG_DESCRIPTOR 32
static unsigned char ConfigurationDescriptor[]=
      { 0x09, TYPE_CONFIGURATION_DESCRIPTOR, SIZEOF_CONFIG_DESCRIPTOR, 0x00, 0x01, 0x01, 0x00, 0x80, 0x32,
        0x09, TYPE_INTERFACE_DESCRIPTOR, 0x00, 0x00, 0x02, 0x08, 0x05, 0x50, 0x00,
        0x07, TYPE_ENDPOINT_DESCRIPTOR, 0x01, 0x02, 0x40, 0x00, 0x00,
        0x07, TYPE_ENDPOINT_DESCRIPTOR, 0x82, 0x02, 0x40, 0x00, 0x00 };

LANGID_DESCRIPTOR LANGID_Descriptor = { /* LANGID String Descriptor Zero */
    LANGID_DESCRIPTOR_SIZE,             /* bLength */
    TYPE_STRING_DESCRIPTOR,             /* bDescriptorType */
    0x0409                              /* LANGID US English */
};

MANUFACTURER_DESCRIPTOR ManufacturerDescriptor = {   /* ManufacturerString 1 */
    MANUFACTURER_DESCRIPTOR_SIZE,                     /* bLength */
    TYPE_STRING_DESCRIPTOR,                           /* bDescriptorType */
    "B\0e\0y\0o\0n\0d\0 l\0o\0g\0i\0c\0"              /* ManufacturerString in UNICODE */
};

#define MAX_BUFFER_SIZE 80

unsigned char irqrcvd = 0xFF;

unsigned char circularbuffer[MAX_BUFFER_SIZE];
unsigned char inpointer;
unsigned char outpointer;

unsigned char *pSendBuffer;
unsigned char BytesToSend;
unsigned char CtlTransferInProgress;
unsigned char USBDeviceAddress = 0xAA;
unsigned char DeviceConfigured;

static unsigned char IPM_IDM_FB_Keeper;
static unsigned char ACK_Request_Sense_command = 0;
static unsigned char First_inquiry_command_flag = 0;
static unsigned char ConfigValue = 0;
static unsigned char AlternateSetting = 0;
static unsigned char USBPowerConnected = 0;
static unsigned char EP0DataCount;
unsigned char UramXAddr[30];

static unsigned int SPKeeper;
static unsigned int DeviceStatus = 0;
static unsigned int InterfaceStatus = 0;
static unsigned int EndPoint1OUTStatus = 0;
static unsigned int EndPoint1INStatus = 0;

#define PROGRESS_IDLE             0
#define PROGRESS_ADDRESS          3

#ifdef NOPE
void D11GetIRQ(void)
{
    if (Irq & USB_EP_CONTROL_READ)
    {
        if (CtlTransferInProgress == PROGRESS_ADDRESS)
        {
            D11CmdDataWrite(D11_SET_ADDRESS_ENABLE,&USBDeviceAddress,1);
            D11CmdDataRead(D11_READ_LAST_TRANSACTION + D11_ENDPOINT_EP0_IN, Buffer, 1);

            IOPORT_Set( USB_DEVADDR_REG, USB_DEVADDR_ENABLE + USBDeviceAddress );
            CtlTransferInProgress = PROGRESS_IDLE;
        }
        else
        {
            D11CmdDataRead(D11_READ_LAST_TRANSACTION + D11_ENDPOINT_EP0_IN, Buffer, 1);
            WriteBufferToEP0();
        }
    }

    if (Irq & USB_EP_ENDPOINT1_OUT)
    {
        D11CmdDataRead(D11_READ_LAST_TRANSACTION + D11_ENDPOINT_EP1_OUT, Buffer, 1);
        bytes = D11ReadEndpoint(D11_ENDPOINT_EP1_OUT, Buffer);
        for (count = 0; count < bytes; count++)
        {
            circularbuffer[inpointer++] = Buffer[count];
            if (inpointer >= MAX_BUFFER_SIZE)
                inpointer = 0;
        }
        loadfromcircularbuffer(); //Kick Start
    }

    if (Irq & USB_EP_ENDPOINT1_IN)
    {
        D11CmdDataRead(D11_READ_LAST_TRANSACTION + D11_ENDPOINT_EP1_IN, Buffer, 1);
        loadfromcircularbuffer();
    }

}
#endif


void ConfigureStall_EP1_OUT( void )
{
#asm
ConfigureStall_EP1_OUT:
    ld      bc,01bfh                ; Stall EP1_OUT
    call    SetEp1OutMode           ; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
    xor     a
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a,64
    out     (USB_EPI_CNTR_LO_REG),a ;Stall

    jp ConfigureStall_EP1_OUT_end

;----------------------------------------------------------------------
; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
SetEp1OutMode:
    ld      a,USB_EPI_ENDPOINT1_OUT
    out     (USB_EPI_REG),a         ; EPI=EP1_OUT
    ld      a,b
    out     (USB_EPI_MODE_REG),a
    ld      a,c
    out     (USB_EPI_MPS_REG),a
    xor     a
    out     (USB_EPI_START_ADDR_HI_REG),a
    out     (USB_EPI_START_ADDR_LO_REG),a
    ld      a,USB_EP_ENDPOINT1_OUT
    out     (USB_EP_STATUS_REG),a
    ret

ConfigureStall_EP1_OUT_end:
#endasm
}


void ConfigureStall_EP1_IN( void )
{
#asm
ConfigureStall_EP1_IN:
    ld      bc,01bfh                ; Stall EP1_IN
    call    SetEp1InMode            ; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
    xor     a
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a,64
    out     (USB_EPI_CNTR_LO_REG),a  ; Stall

    jp      ConfigureStall_EP1_IN_end

;----------------------------------------------------------------------
; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
SetEp1InMode:
    ld      a,USB_EPI_ENDPOINT1_IN
    out     (USB_EPI_REG),a         ; EPI=EP1_IN
    ld      a,b                     ; Stall EP1_OUT
    out     (USB_EPI_MODE_REG),a
    ld      a,c
    out     (USB_EPI_MPS_REG),a
    xor     a
    out     (USB_EPI_START_ADDR_HI_REG),a
    out     (USB_EPI_START_ADDR_LO_REG),a
    ld      a,USB_EP_ENDPOINT1_IN
    out     (USB_EP_STATUS_REG),a
    ret

ConfigureStall_EP1_IN_end:
#endasm
}

void USBResetISR( void )
{
#asm
;----------------------------------------------------------------------
; USB Reset interrupt service routine
    xor     a
    ld      (_ACK_Request_Sense_command),a
    ld      (_First_inquiry_command_flag),a
    ld      (_ConfigValue),a
    ld      (_AlternateSetting),a

    ld      hl,0
    ld      (_DeviceStatus),hl
    ld      (_InterfaceStatus),hl
    ld      (_EndPoint1OUTStatus),hl
    ld      (_EndPoint1INStatus),hl

    ld      a,USB_DEVADDR_ENABLE        ; enable USB SIE with address 0
    out     (USB_DEVADDR_REG),a

USBResetISR_ClearBR:
    ld      a, USB_EPI_CONTROL_READ
    out     (USB_EPI_REG),a             ; EPI=Control_read
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_CONTROL_WRITE
    out     (USB_EPI_REG),a             ; EPI=Control_write
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_ENDPOINT1_IN
    out     (USB_EPI_REG),a             ; EPI=EP1_IN
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_ENDPOINT1_OUT
    out     (USB_EPI_REG),a             ; EPI=EP1_OUT
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_ENDPOINT2_IN
    out     (USB_EPI_REG),a             ; EPI=EP2_IN
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_ENDPOINT2_OUT
    out     (USB_EPI_REG),a             ; EPI=EP2_OUT
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_ENDPOINT3_IN
    out     (USB_EPI_REG),a             ; EPI=EP3_IN
    out     (USB_EPI_CNTR_HI_REG),a
    ld      a, USB_EPI_ENDPOINT3_OUT
    out     (USB_EPI_REG),a             ; EPI=EP3_OUT
    out     (USB_EPI_CNTR_HI_REG),a

    in      a,(USB_EPI_EPSBR_REG)
    cp      0
    jr      nz, USBResetISR_ClearBR

    ld      a,0xff                      ; Clear all pending interrupts
    out     (USB_INT_STATUS_REG),a
    out     (USB_EP_STATUS_REG),a
    out     (USB_EPI_EPSNS_REG),a
    out     (USB_EPI_EPSST_REG),a
#endasm
}

void USBConnectISR( void )
{
#asm
    in      a, (USB_STATUS_CONTROL_REG)
    bit     6, a                         ; USB_STATUS_POWER
    jr      nz, USBConnectISR_Connected
    xor     a
    ld      (_USBPowerConnected),a
    jp      USBConnectISR_Exit

USBConnectISR_Connected:
    ld      a,0x01
    ld      (_USBPowerConnected),a
USBConnectISR_Exit:
#endasm
}

void USB_ISREP_ControlRead( void )
{


irqrcvd = 0x04;

#ifdef crap
    if (CtlTransferInProgress == PROGRESS_ADDRESS)
    {
#asm
        ld      a,(_USBDeviceAddress)
        or      USB_DEVADDR_ENABLE
        out     (USB_DEVADDR_REG),a     ; Enable device with address
#endasm
/*        IOPORT_Set( USB_DEVADDR_REG, USB_DEVADDR_ENABLE + USBDeviceAddress );*/
        CtlTransferInProgress = PROGRESS_IDLE;
    }
    else
    {
        WriteBufferToEP0();
    }
#endif
}

void USB_ISR( void )
{
#asm
    in      a,(INTERNAL_MROM_SRAM_PAGE_REG)
    ld      (_IPM_IDM_FB_Keeper),a
    ld      (_SPKeeper),sp

    in      a,(USB_INT_STATUS_REG)

USB_ISR_Reset:
    bit     7,a                         ;USB_INT_BUS_RESET
    jp      z, USB_ISR_EP0Setup
    call    _USBResetISR
    ld      a,USB_INT_BUS_RESET
    out     (USB_INT_STATUS_REG),a
    jp      USB_ISR_End

USB_ISR_EP0Setup:
    bit     5,a                         ;USB_INT_EP0_SETUP
    jp      z, USB_ISR_Connect
    call    _EP0SETUPInterrupt
    ld      a,USB_INT_EP0_SETUP
    out     (USB_INT_STATUS_REG),a
    jp      USB_ISR_End

USB_ISR_Connect:
    bit     6,a                         ;USB_INT_BUS_CON_DISC
    jp      z, USB_ISR_Wakeup
    call    _USBConnectISR
    in     a,(USB_INT_STATUS_REG)
    or      USB_INT_BUS_CON_DISC
    out     (USB_INT_STATUS_REG),a
    jp      USB_ISR_End

USB_ISR_Wakeup:
    bit     4,a                         ;USB_INT_WAKEUP_IRQ
    jp      z, USB_ISR_EndPoint
    ld      a,USB_INT_WAKEUP_IRQ        ; Clear the interrupt
    out     (USB_INT_STATUS_REG),a
    jp      USB_ISR_End

USB_ISR_EndPoint:
    in      a,(USB_EP_STATUS_REG)

    bit     0,a                         ; USB_EP_CONTROL_READ
    jp      z, USB_ISR_EndPoint3
    call    _USB_ISREP_ControlRead
    jp      USB_ISR_End

USB_ISR_EndPoint3:
;    in      a,(USB_EP_STATUS_REG)
;   bit     3,a                         ;USB_EP_ENDPOINT1_OUT
;   jp      nz, EP1_OUT_ISR

;    ld      a,0ffh                      ; All Irqs
;    out     (USB_EP_STATUS_REG),a

USB_ISR_End:
    ld      sp,(_SPKeeper)
    ld      a,(_IPM_IDM_FB_Keeper)
    out     (INTERNAL_MROM_SRAM_PAGE_REG),a

    ld      a,0ffh                      ; All Irqs
    out     (USB_EP_STATUS_REG),a
	ld	a, 0xff
	out	(USB_INT_STATUS_REG), a
	in	a, (USB_IRQSTATUS_REG)
	out	(USB_IRQSTATUS_REG), a
#endasm
}

void EP0StandardDeviceRequest( void )
{
    unsigned char ucEP0DataReg1;
    unsigned char ucEP0DataReg2;
    unsigned char Buffer[2];

    ucEP0DataReg1 = IOPORT_Read( USB_SETUP_DATA1_REG );
    ucEP0DataReg2 = IOPORT_Read( USB_SETUP_DATA2_REG );

    switch (ucEP0DataReg1)
    {
        case GET_STATUS:
            /* Get Status Request to Device should return */
            /* Remote Wakeup and Self Powered Status */
            Buffer[0] = 0x01;
            Buffer[1] = 0x00;
            WriteEP0( Buffer,2 );
            break;

        case CLEAR_FEATURE:
        case SET_FEATURE:
            /* We don't support DEVICE_REMOTE_WAKEUP or TEST_MODE */
            ErrorStallControlEndPoint();
            break;

        case SET_ADDRESS:
            USBDeviceAddress = ucEP0DataReg2;
            WriteEP0( NULL, 0 );
            CtlTransferInProgress = PROGRESS_ADDRESS;
            break;

        case GET_DESCRIPTOR:
            GetDescriptor();
            break;

        case GET_CONFIGURATION:
            WriteEP0( &DeviceConfigured, 1 );
            break;

        case SET_CONFIGURATION:
            DeviceConfigured = ucEP0DataReg2;
            WriteEP0( NULL, 0 );
            break;

        case SET_DESCRIPTOR:
        default:
            /* Unsupported - Request Error - Stall */
            ErrorStallControlEndPoint();
            break;

    }
}

void EP0StandardInterfaceRequest( void )
{
    unsigned char ucEP0DataReg1;
    unsigned char ucEP0DataReg2;
    unsigned char ucEP0DataReg4;
    unsigned char dummy_variable_for_stack_alignment;
    unsigned char Buffer[2];

    ucEP0DataReg1 = IOPORT_Read( USB_SETUP_DATA1_REG );
    ucEP0DataReg2 = IOPORT_Read( USB_SETUP_DATA2_REG );
    ucEP0DataReg4 = IOPORT_Read( USB_SETUP_DATA4_REG );

    switch (ucEP0DataReg1)
    {
        case GET_STATUS:
            /* Get Status Request to Interface should return */
            /* Zero, Zero (Reserved for future use) */
            Buffer[0] = 0x00;
            Buffer[1] = 0x00;
            WriteEP0( Buffer, 2 );
            break;
        case SET_INTERFACE:
            /* Device Only supports default setting, Stall may be */
            /* returned in the status stage of the request */
            if (ucEP0DataReg2 == 0 && ucEP0DataReg4 == 0)
            {
                /* Interface Zero, Alternative Setting = 0 */
                WriteEP0( NULL, 0 );
            }
            else
            {
                ErrorStallControlEndPoint();
            }
            break;
        case GET_INTERFACE:
            if (ucEP0DataReg4 == 0)
            {   /* Interface Zero */
                Buffer[0] = 0; /* Alternative Setting */
                WriteEP0( Buffer, 1 );
                break;
            } /* else fall through as RequestError */
        case CLEAR_FEATURE:
        case SET_FEATURE:
            /* Interface has no defined features. Return RequestError */
        default:
            ErrorStallControlEndPoint();
            break;
    }
}

void EP0StandardEndpointRequest( void )
{
    unsigned char ucEP0DataReg1;
    unsigned char ucEP0DataReg2;
    unsigned char ucEP0DataReg4;
    unsigned char ucEP0DataReg5;
    unsigned char dummy_variable_for_stack_alignment;
    unsigned char Buffer[2];

    ucEP0DataReg1 = IOPORT_Read( USB_SETUP_DATA1_REG );
    ucEP0DataReg2 = IOPORT_Read( USB_SETUP_DATA2_REG );

    ucEP0DataReg4 = IOPORT_Read( USB_SETUP_DATA4_REG );
    ucEP0DataReg5 = IOPORT_Read( USB_SETUP_DATA5_REG );

    switch (ucEP0DataReg1)
    {
        case CLEAR_FEATURE:
        case SET_FEATURE:
            /* Halt(Stall) feature required to be implemented on all Interrupt and */
            /* Bulk Endpoints. It is not required nor recommended on the Default Pipe */

            if (ucEP0DataReg2 == ENDPOINT_HALT)
            {
                if (ucEP0DataReg1 == CLEAR_FEATURE)
                {
                    Buffer[0] = 0x00;
                }
                else
                {
                    Buffer[0] = 0x01;
                }
                switch (ucEP0DataReg4)
                {
                    case 0x01 :
                        EndPoint1OUTStatus = 0x01; /* Enabled */
                        ConfigureStall_EP1_OUT();
                        break;
                    case 0x81 :
                        EndPoint1INStatus = 0x01; /* Enabled */
                        ConfigureStall_EP1_IN();
                        break;
                    default   :
                        /* Invalid Endpoint - RequestError */
                        ErrorStallControlEndPoint();
                        break;
                }

                WriteEP0( NULL, 0);
            }
            else
            {
                /* No other Features for Endpoint - Request Error */
                ErrorStallControlEndPoint();
            }
            break;

        case GET_STATUS:
            /* Get Status Request to Endpoint should return */
            /* Halt Status in D0 for Interrupt and Bulk */
            switch (ucEP0DataReg4)
            {
                case 0x01 :
                    Buffer[0] = EndPoint1OUTStatus;
                    break;
                case 0x81 :
                    Buffer[0] = EndPoint1INStatus;
                    break;
                default   :
                    /* Invalid Endpoint - RequestError */
                    ErrorStallControlEndPoint();
                    break;
            }

            Buffer[1] = 0x00;
            WriteEP0( Buffer, 2);
            break;

        default:
            /* Unsupported - Request Error - Stall */
            ErrorStallControlEndPoint();
            break;
    }
}


void EP0SETUPInterrupt( void )
{

    irqrcvd = 0x02;
/*    unsigned char dummy_variable_for_stack_alignment;
    unsigned char Buffer[2];
    unsigned char ucEP0DataReg0;*/

/*    ucEP0DataReg0 = IOPORT_Read( USB_SETUP_DATA0_REG );
*/
/*    switch (ucEP0DataReg0&0x7F)*/
/*#ifdef crap*/
    switch (0x01)
    {
        case STANDARD_DEVICE_REQUEST:
            irqrcvd |= 0x01;
            EP0StandardDeviceRequest();
            break;
        case STANDARD_INTERFACE_REQUEST:
            irqrcvd |= 0x02;
            EP0StandardInterfaceRequest(); 
            break;
        case STANDARD_ENDPOINT_REQUEST:
            irqrcvd |= 0x04;
            EP0StandardEndpointRequest();
            break;
        default:
            irqrcvd |= 0x08;
            ErrorStallControlEndPoint();
            break;
    }
/*    #endif*/
}

void GetDescriptor( void )
{
    unsigned char ucEP0DataReg2;
    unsigned char ucEP0DataReg3;
    unsigned char ucEP0DataReg6;

    ucEP0DataReg2 = IOPORT_Read( USB_SETUP_DATA2_REG );
    ucEP0DataReg3 = IOPORT_Read( USB_SETUP_DATA3_REG );
    ucEP0DataReg6 = IOPORT_Read( USB_SETUP_DATA6_REG );

    switch(ucEP0DataReg3)
    {
        case TYPE_DEVICE_DESCRIPTOR:
/*            pSendBuffer = (unsigned char *)&DeviceDescriptor;*/
            pSendBuffer = DeviceDescriptor;
            BytesToSend = DeviceDescriptor.bLength;
            if (BytesToSend > ucEP0DataReg6)
                BytesToSend = ucEP0DataReg6;
            WriteBufferToEP0();
            break;

        case TYPE_CONFIGURATION_DESCRIPTOR:
            pSendBuffer = ConfigurationDescriptor;
            BytesToSend = sizeof(ConfigurationDescriptor);
            if (BytesToSend > ucEP0DataReg6)
                BytesToSend = ucEP0DataReg6;
            WriteBufferToEP0();
            break;

        case TYPE_STRING_DESCRIPTOR:
            switch (ucEP0DataReg2)
            {
                case 0 :
                    /* pSendBuffer = (unsigned char*)&LANGID_Descriptor;*/
                    pSendBuffer = LANGID_Descriptor;
                    BytesToSend = sizeof(LANGID_Descriptor);
                    break;

                case 1 :
                    /* pSendBuffer = (unsigned char *)&ManufacturerDescriptor; */
                    pSendBuffer = ManufacturerDescriptor;
                    BytesToSend = sizeof(ManufacturerDescriptor);
                    break;

                default : pSendBuffer = NULL;
                          BytesToSend = 0;
            }
            if (BytesToSend > ucEP0DataReg6)
                BytesToSend = ucEP0DataReg6;
            WriteBufferToEP0();
            break;
       default:
            ErrorStallControlEndPoint();
            break;
    }
}

void ErrorStallControlEndPoint(void)
{
#asm
    ld      b, USB_EPI_MODE_STALL
    ld      c, 0xc7                    ; data = 8 | USB_EPI_MPS_FORCE_TOGGLE | USB_EPI_MPS_CURRENT_TOGGLE
    call    SetEp0WrMode            ; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
    xor     a
    out     (USB_EPI_CNTR_LO_REG),a

    jp      end_ErrorStallControlEndPoint

;----------------------------------------------------------------------
; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
SetEp0WrMode:
    ld      a,USB_EPI_CONTROL_WRITE
    out     (USB_EPI_REG),a             ; EPI=Control-write
    ld      a,b
    out     (USB_EPI_MODE_REG),a        ; STALL IN/OUT
    ld      a,c
    out     (USB_EPI_MPS_REG),a
    xor     a
    out     (USB_EPI_START_ADDR_HI_REG),a
    out     (USB_EPI_START_ADDR_LO_REG),a
    out     (USB_EPI_CNTR_HI_REG),a
    ret

end_ErrorStallControlEndPoint:
#endasm
}

void WriteEP0( unsigned char *Buffer, unsigned char Bytes )
{
/*
    Buffer = 0x1234;
    Bytes = 2;

;Buffer = 0x1234;
	LINE	710
	ld	hl,4	;const
	add	hl,sp
	ld	de,4660	;const
	ex	de,hl
	call	l_pint
;Bytes = 2;
	LINE	711
	ld	hl,2	;const
	add	hl,sp
	ld	(hl),#(2 % 256 % 256)
	ld	l,(hl)
	ld	h,0
*/	
#asm
; a = Bytes
	ld	hl,2	;const
	add	hl,sp
	ld	a,(hl)

; hl = Buffer
	ld	hl,4	;const
	add	hl,sp
	ld  d, (hl)
	dec hl
	ld  e, (hl)
	ex	de,hl	

;----------------------------------------------------------------------
; Perform control read operation
; hl: start position
; a:  size of the data should be returned
;----------------------------------------------------------------------
control_read:
    call    get_descriptor_length

    ld      c,a
    ld      b,0
    ld      a,0f7h
    out     (INTERNAL_MROM_SRAM_PAGE_REG),a
    in      a,(B1_2_MEMMAP_REG)
    or      B1_2_MEMMAP_B1_B2
    out     (B1_2_MEMMAP_REG),a
    ld      de,_UramXAddr
    ldir

    in      a,(B1_2_MEMMAP_REG)
    and     0xcf
    or      B1_2_MEMMAP_B2
    out     (B1_2_MEMMAP_REG),a

;   ld      bc,03c7h            ; complete=1,stall=1
    ld      b, USB_EPI_MODE_COMPLETE | USB_EPI_MODE_STALL 
	; MPS = 8 | USB_EPI_MPS_FORCE_TOGGLE | USB_EPI_MPS_CURRENT_TOGGLE
    ld      c, USB_EPI_MPS_FORCE_TOGGLE | USB_EPI_MPS_CURRENT_TOGGLE | 7
    call    sSet_Ep0_Rd_Mode    ; b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)

    ld      a,(_EP0DataCount)
    call    sWait_Ep0_Send_Out

    jr      lsControlReadRet
lsPremature_Terminate:
lsControlReadRet:
    jp      ControlRead_end


;*******************************************************************************
;*     Subroutine
;*     b->(USB_EPI_MODE_REG), c->(USB_EPI_MPS_REG)
;*******************************************************************************
sSet_Ep0_Rd_Mode:
            xor     a                   ; a = USB_EPI_CONTROL_READ
            out     (USB_EPI_REG),a     ; EPI=Control-read
            ld      a,b
            out     (USB_EPI_MODE_REG),a
            ld      a,c
            out     (USB_EPI_MPS_REG),a
            xor     a
            out     (USB_EPI_START_ADDR_HI_REG),a
            out     (USB_EPI_START_ADDR_LO_REG),a
            out     (USB_EPI_CNTR_HI_REG),a
            ret

;----------------------------------------------------------------------
get_descriptor_length:
            ld      (_EP0DataCount),a
            ld      b,a
            in      a,(USB_SETUP_DATA7_REG)
            or      a
            jr      nz,use_actual_length
            in      a,(USB_SETUP_DATA6_REG)
            or      a
            jr      z,use_actual_length
            cp      b
            jr      nc,use_actual_length
            ld      (_EP0DataCount),a
use_actual_length:
            ld      a,(_EP0DataCount)
            ret

;----------------------------------------------------------------------
sWait_Ep0_Send_Out:
            out     (USB_EPI_CNTR_LO_REG),a
Check_Control_read_BR_Set:
            in      a,(USB_EPI_EPSBR_REG)
            bit     0,a                             ; USB_EPI_EPSBR_CTL_READ
            jr      z,Check_Control_read_BR_Set
Check_Control_read_BR_Clear:
            in      a,(USB_EPI_EPSBR_REG)
            bit     0,a                             ; USB_EPI_EPSBR_CTL_READ
            jr      nz,Check_Control_read_BR_Clear
            ld      a,USB_EP_CONTROL_READ
            out     (USB_EP_STATUS_REG),a
            ret

ControlRead_end:
#endasm
}

/*
void WriteEP1( unsigned char *Buffer, unsigned char Bytes )
{
}
*/

void WriteBufferToEP0( void )
{
    if (BytesToSend == 0) {
        /* If BytesToSend is Zero and we get called again, assume buffer is smaller */
        /* than Setup Request Size and indicate end by sending Zero Length packet */
        WriteEP0( NULL, 0);
    } else if (BytesToSend >= 8) {
        /* Write another 8 Bytes to buffer and send */
        WriteEP0( pSendBuffer, 8);
        pSendBuffer += 8;
        BytesToSend -= 8;
    } else {
        /* Buffer must have less than 8 bytes left */
        WriteEP0( pSendBuffer, BytesToSend);
        BytesToSend = 0;
    }
}

#ifdef crap
void loadfromcircularbuffer(void)
{
   unsigned char Buffer[10];
   unsigned char count;

   /* Read Buffer Full Status */
/*   D11CmdDataRead(D11_ENDPOINT_EP1_IN, Buffer, 1);*/
   if (Buffer[0] == 0)
   {
        /* Buffer Empty */
        if (inpointer != outpointer)
        {
            /* We have bytes to send */
            count = 0;
            do
            {
                Buffer[count++] = circularbuffer[outpointer++];
                if (outpointer >= MAX_BUFFER_SIZE)
                    outpointer = 0;
                if (outpointer == inpointer)
                    break; /* No more data */
            } while (count < 8); /* Maximum Buffer Size */
            /* Now load it into EP1_In */
            WriteEP1IN( Buffer, count);
        }
    }
}

#endif

