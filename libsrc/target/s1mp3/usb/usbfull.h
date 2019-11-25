
/*  Example Source Code for USB Enumeration using a PDIUSBD11 connected to a PIC16F87x	*/
/*  Copyright 2001 Craig Peacock, Craig.Peacock@beyondlogic.org			            */
/*  31th December 2001 http://www.beyondlogic.org            				      */

typedef struct {
	unsigned char bmRequestType;
	unsigned char bRequest;
	unsigned short wValue;
	unsigned short wIndex;
	unsigned short wLength;
} USB_SETUP_REQUEST;

#define USB_DEVICE_DESCRIPTOR_SIZE 18
typedef struct USB_DEVICE_DESCRIPTOR_TYPE {
		unsigned char bLength;
		unsigned char bDescriptorType;
		unsigned short bcdUSB;
		unsigned char bDeviceClass;
		unsigned char bDeviceSubClass;
		unsigned char bDeviceProtocol;
		unsigned char bMaxPacketSize0;
		unsigned short idVendor;
		unsigned short idProduct;
		unsigned short bcdDevice;
		unsigned char iManufacturer;
		unsigned char iProduct;
		unsigned char iSerialNumber;
		unsigned char bNumConfigurations;
} USB_DEVICE_DESCRIPTOR;

#define USB_ENDPOINT_DESCRIPTOR_SIZE 7
typedef struct {
		unsigned char bLength;
		unsigned char bDescriptorType;
		unsigned char bEndpointAddress;
		unsigned char bmAttributes;
		unsigned short wMaxPacketSize;
		unsigned char bInterval;
} USB_ENDPOINT_DESCRIPTOR;

#define USB_CONFIGURATION_DESCRIPTOR_SIZE 9
typedef struct {
		unsigned char bLength;
		unsigned char bDescriptorType;
		unsigned int  wTotalLength;
		unsigned char bNumInterfaces;
		unsigned char bConfigurationValue;
		unsigned char iConfiguration;
		unsigned char bmAttributes;
		unsigned char MaxPower;
} USB_CONFIGURATION_DESCRIPTOR;

#define USB_INTERFACE_DESCRIPTOR_SIZE 9
typedef struct {
		unsigned char bLength;
		unsigned char bDescriptorType;
		unsigned char bInterfaceNumber;
		unsigned char bAlternateSetting;
		unsigned char bNumEndpoints;
		unsigned char bInterfaceClass;
		unsigned char bInterfaceSubClass;
		unsigned char bInterfaceProtocol;
		unsigned char iInterface;
} USB_INTERFACE_DESCRIPTOR;

#define USB_HID_DESCRIPTOR_SIZE 9
typedef struct {
		unsigned char bLength;
		unsigned char bDescriptorType;
		unsigned short wHIDClassSpecComp;
		unsigned char bCountry;
		unsigned char bNumDescriptors;
		unsigned char b1stDescType;
		unsigned short w1stDescLength;
} USB_HID_DESCRIPTOR;

/*#define USB_CONFIG_DATA_SIZE (USB_CONFIGURATION_DESCRIPTOR_SIZE+USB_INTERFACE_DESCRIPTOR_SIZE+USB_ENDPOINT_DESCRIPTOR_SIZE+USB_ENDPOINT_DESCRIPTOR_SIZE)*/
#define USB_CONFIG_DATA_SIZE 32
typedef struct {
	USB_CONFIGURATION_DESCRIPTOR ConfigDescriptor;
	USB_INTERFACE_DESCRIPTOR InterfaceDescriptor;
  	USB_ENDPOINT_DESCRIPTOR EndpointDescriptor0;
	USB_ENDPOINT_DESCRIPTOR EndpointDescriptor1;
} USB_CONFIG_DATA;

#define MANUFACTURER_DESCRIPTOR_SIZE  26
typedef struct {
	    unsigned char bLength;
     	unsigned char bDescriptorType;
      	unsigned char     bString[24];
} MANUFACTURER_DESCRIPTOR;

#define LANGID_DESCRIPTOR_SIZE 4
typedef struct {
	    unsigned char bLength;
      	unsigned char bDescriptorType;
      	unsigned short wLANGID0;
} LANGID_DESCRIPTOR;

void USB_Init(void);
void USB_Disconnect(void);
unsigned char ReadEndpoint(unsigned char Endpoint, unsigned char *Buffer);
void loadfromcircularbuffer(void);
void GetDescriptor(void);
void GetIRQ(void);
void InitUART(void);
void putch(unsigned char byte);
void puthex(unsigned char byte);
void Process_EP0_OUT_Interrupt(void);

void ErrorStallControlEndPoint(void);

void WriteEP0( unsigned char *Buffer, unsigned char Bytes );
void WriteBufferToEP0(void);


#define D11_SET_HUB_ADDRESS 		0xD0
#define D11_SET_ADDRESS_ENABLE		0xD1
#define D11_SET_ENDPOINT_ENABLE  	0xD8
#define D11_SET_MODE			0xF3
#define D11_READ_INTERRUPT_REGISTER 	0xF4
#define D11_READ_LAST_TRANSACTION	0x40
#define D11_SET_ENDPOINT_STATUS		0x40
#define D11_READ_ENDPOINT_STATUS	0x80
#define D11_READ_BUFFER			0xF0
#define D11_WRITE_BUFFER		0xF0
#define D11_CLEAR_BUFFER		0xF2
#define D11_VALIDATE_BUFFER		0xFA
#define D11_ACK_SETUP			0xF1

#define D11_ENDPOINT_EP0_OUT 		0x02
#define D11_ENDPOINT_EP0_IN 		0x03
#define D11_ENDPOINT_EP1_OUT 		0x05
#define D11_ENDPOINT_EP1_IN 		0x04
#define D11_ENDPOINT_EP2_OUT 		0x06
#define D11_ENDPOINT_EP2_IN 		0x07
#define D11_ENDPOINT_EP3_OUT 		0x08
#define D11_ENDPOINT_EP3_IN 		0x09

#define D11_CMD_ADDR	  	   	0x36
#define D11_DATA_ADDR_WRITE		0x34
#define D11_DATA_ADDR_READ		0x35

#define D11_INT_BUS_RESET		0x4000
#define D11_INT_EP0_OUT			0x0004
#define D11_INT_EP0_IN			0x0008
#define D11_INT_EP1_OUT			0x0020
#define D11_INT_EP1_IN			0x0010
#define D11_INT_EP2_OUT			0x0040
#define D11_INT_EP2_IN			0x0080
#define D11_INT_EP3_OUT			0x0100
#define D11_INT_EP3_IN			0x0200

#define D11_LAST_TRAN_SETUP		        0x20

#define STANDARD_DEVICE_REQUEST		    0x00
#define STANDARD_INTERFACE_REQUEST	    0x01
#define STANDARD_ENDPOINT_REQUEST	    0x02
#define VENDOR_DEVICE_REQUEST		    0x40
#define VENDOR_ENDPOINT_REQUEST		    0x42

#define GET_STATUS  			        0x00
#define CLEAR_FEATURE     		        0x01
#define SET_FEATURE                     0x03
#define SET_ADDRESS                     0x05
#define GET_DESCRIPTOR                  0x06
#define SET_DESCRIPTOR                  0x07
#define GET_CONFIGURATION               0x08
#define SET_CONFIGURATION               0x09
#define GET_INTERFACE                   0x0a
#define SET_INTERFACE                   0x0b
#define SYNCH_FRAME                     0x0c

#define VENDOR_GET_ANALOG_VALUE		    0x01
#define VENDOR_SET_RB_HIGH_NIBBLE	    0x02

#define	ENDPOINT_HALT			        0x00

#define TYPE_DEVICE_DESCRIPTOR          0x01
#define TYPE_CONFIGURATION_DESCRIPTOR   0x02
#define TYPE_STRING_DESCRIPTOR          0x03
#define TYPE_INTERFACE_DESCRIPTOR       0x04
#define TYPE_ENDPOINT_DESCRIPTOR        0x05
#define TYPE_HID_DESCRIPTOR		        0x21

#define USB_ENDPOINT_TYPE_CONTROL	    0x00
#define USB_ENDPOINT_TYPE_ISOCHRONOUS	0x01
#define USB_ENDPOINT_TYPE_BULK		    0x02
#define USB_ENDPOINT_TYPE_INTERRUPT	    0x03


