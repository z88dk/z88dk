#ifndef ARCH_NABU_HCCA_H
#define ARCH_NABU_HCCA_H

#include <stdint.h>
#include <sys/compiler.h>


#define HCCA_MODE_RB    255
#define HCCA_MODE_HDR   0
#define HCCA_MODE_BLOCK 1

extern void hcca_reset_write(void);
extern void hcca_start_write(uint8_t mode, void *buf, size_t buflen);
extern void hcca_start_read(uint8_t mode, void *buf, size_t buflen);

// **************************************************************************
// HCCA Receive
// ------------
// 
// Receive bytes from the HCCA port. This uses an interrupt, so you will need
// to initialize the interrupt before the method can be used. That means you
// will need to call hcca_EnableReceiveBufferInterrupt() at the beginning of
// your program. From that point on, use the Buffer specific functions for
// receiving, such as hcca_readFromBuffer()
// 
// Also, make sure you call hcca_IsRxBufferAvailable() before hcca_readFromBuffer()
// to ensure there is actually data available.
// 
// **************************************************************************

/// <summary>
/// Returns how much data is currently in the RX buffer
/// </summary>
uint8_t hcca_getSizeOfDataInBuffer();

/// <summary>
/// Read a byte from the buffer.
/// Check the hcca_ISRxBufferAvailable() first or this blocks.
/// </summary>
uint8_t hcca_readByte();

/// <summary>
/// Read an unsigned 16-bit integer from the HCCA
/// *Note: You must first check if a byte is available with hcca_IsDataAvailble() first or you get garbage.
/// </summary>
uint16_t hcca_readUInt16();

/// <summary>
/// Read an signed 16-bit integer from the HCCA
/// *Note: You must first check if a byte is available with hcca_IsDataAvailble() first or you get garbage.
/// </summary>
int16_t hcca_readInt16();

/// <summary>
/// Read an unsigned 32-bit integer from the HCCA
/// *Note: You must first check if a byte is available with hcca_IsDataAvailble() first or you get garbage.
/// </summary>
uint32_t hcca_readUInt32();

/// <summary>
/// Read an signed 32-bit integer from the HCCA
/// *Note: You must first check if a byte is available with hcca_IsDataAvailble() first or you get garbage.
/// </summary>
int32_t hcca_readInt32();

/// <summary>
/// Read bufferLen into buffer, starting at the offset
/// </summary>
void hcca_readBytes(uint8_t offset, uint8_t bufferLen, void *buffer);




// **************************************************************************
// HCCA Transmit
// -------------
// 
// These are transmit methods for the HCCA port
// 
// **************************************************************************

/// <summary>
/// Write a byte to the HCCA
/// </summary>
void hcca_writeByte(uint8_t c);

/// <summary>
/// Write the unsigned 32-bit integer to the HCCA.
/// This is LSB First
/// </summary>
void hcca_writeUInt32(uint32_t val);

/// <summary>
/// Write the signed 32-bit integer to the HCCA.
/// This is LSB First
/// </summary>
void hcca_writeInt32(int32_t val);

/// <summary>
/// Write the unsigned 16-bit integer to the HCCA.
/// This is LSB First
/// </summary>
void hcca_writeUInt16(uint16_t val);

/// <summary>
/// Write the signed 16-bit integer to the HCCA.
/// This is LSB First
/// </summary>
void hcca_writeInt16(int16_t val);

/// <summary>
/// Write null terminated string to the HCCA
/// </summary>
void hcca_writeString(uint8_t* str);

/// <summary>
/// Write to the HCCA
/// </summary>
void hcca_writeBytes(uint16_t offset, uint16_t length, void *bytes);



#endif
