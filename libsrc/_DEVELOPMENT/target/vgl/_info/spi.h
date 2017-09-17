/*

SPI for the V-Tech Genius LEADER using my DIY "BusFicker" external latch/register

2017-03-05 Bernhard "HotKey" Slawik

https://de.wikipedia.org/wiki/Serial_Peripheral_Interface

*/

#define byte unsigned char
#define word unsigned short

#ifndef EXT_DO
	// Where is the BusFicker at
	#define EXT_DO 0xa000
	#define EXT_DI 0xa000
	extern byte ext_DO			@ (EXT_DO);
	extern byte ext_DI			@ (EXT_DI);
#endif


// Where should we keep the variables? You can #define this prior to including this header to overwrite its default
#ifndef VAR_START_SPI
	// Default: 0xc000 and up
	#define VAR_START_SPI 0xc080
#endif


//#define SPI_DEBUG


// SPI modes: 0=CPOL0,CPHA0	1=CPOL0,CPHA1	2=CPOL1,CPHA0	3=CPOL1,CPHA1
#define SPI_CPOL0
//#define SPI_CPOL1

//#define SPI_CPHA0
#define SPI_CPHA1


#define SPI_MASK_CLK 1	// DO0
#define SPI_MASK_MOSI 2	// DO1
#define SPI_MASK_MISO 1	// DI 0
#define SPI_MASK_SS1	0*4 + 1*8 + 1*16	// DO2
#define SPI_MASK_SS2	1*4 + 0*8 + 1*16	// DO3
#define SPI_MASK_SS3	1*4 + 1*8 + 0*16	// DO4
#define SPI_SELECT_NONE	1*4 + 1*8 + 1*16	// all SSx HIGH = all disabled
#define SPI_SELECT_ALL	0*4 + 0*8 + 0*16	// all SSx LOW = all enabled

#ifdef SPI_CPOL0
	// Set clock line to be active HIGH (CPOL=0) or active low (CPOL=1)
	#define SPI_CLOCK_IDLE 0*SPI_MASK_CLK
	#define SPI_CLOCK_ACTIVE 1*SPI_MASK_CLK
#else
	#define SPI_CLOCK_IDLE 0*SPI_MASK_CLK
	#define SPI_CLOCK_ACTIVE 1*SPI_MASK_CLK
#endif

extern byte spi_c			@ (VAR_START_MIDI + 0);
extern byte spi_d			@ (VAR_START_MIDI + 1);
extern byte spi_e			@ (VAR_START_MIDI + 2);
extern byte spi_i			@ (VAR_START_MIDI + 3);

#define VAR_SIZE_SPI 4

void spi_out(byte c) {
	#ifdef SPI_DEBUG
		put_hex8(c);
	#endif
	ext_DO = c;
}
byte spi_in() {
	return ext_DI;
}

void spi_init() {
	
	//p_midi_on_data = onData;
	
	// Switch some high address lines high to activate the BUSFICKER function decoder
	#asm
		push af
		ld a, 81h
		out	(3h), a
		pop af
	#endasm
	
	spi_out(SPI_SELECT_NONE + SPI_CLOCK_IDLE);
}

void spi_delay() {
	#asm
		push	hl
		push	af
		
		ld	hl, 0x0005
		
		xor	h
		ld a, 0x5
		ld l, a
		
		_spi_delay_loop:
			dec	hl
			ld	a,h
			or	l
			jr	nz, _spi_delay_loop
		pop	af
		pop	hl
	#endasm
}

byte spi_do(byte c) {
	
	// Set bit mask for nSS (not Slave Select)
	spi_c = SPI_SELECT_ALL;
	
	spi_e = 0;
	// Send and receive 8 bits
	for (spi_i = 0; spi_i < 8; spi_i++) {
		
		// Construct the bitmask for current payload bit
		if ((c & 1) > 0)
			spi_d = spi_c + 1*SPI_MASK_MOSI;
		else
			spi_d = spi_c + 0*SPI_MASK_MOSI;
		
		// Set select and data, but clock is still idle
		spi_out(spi_d + SPI_CLOCK_IDLE);
		
		spi_delay();
		
		// Clock active
		spi_out(spi_d + SPI_CLOCK_ACTIVE);
		
		#ifdef SPI_CPHA0
		// Read data after 1st edge of CLK (CPHA=0)
		spi_e = (spi_e << 1) + (((spi_in() & SPI_MASK_MISO) > 1) ? 1 : 0);
		#endif
		
		spi_delay();
		
		// Clock idle again
		//spi_out(spi_d + SPI_CLOCK_IDLE);
		
		#ifdef SPI_CPHA1
		// Read data after 2nd edge of CLK (CPHA=1)
		spi_e = (spi_e << 1) + (((spi_in() & SPI_MASK_MISO) > 1) ? 1 : 0);
		#endif
		
		c = c >> 1;
	}
	
	spi_out(SPI_SELECT_NONE + SPI_CLOCK_IDLE);
	
	//spi_delay();
	
	return spi_e;
}

