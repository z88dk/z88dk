
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

// TODO: Use interrupt read to location
uint16_t rn_fileHandleRead(uint8_t fileHandle, uint8_t* buffer, uint16_t bufferOffset, uint32_t readOffset, uint16_t readLength) {

    //0xa5
    hcca_reset_write();
    hcca_writeByte(RETRONET_CMD_FH_READ);

    hcca_writeByte(fileHandle);

    hcca_writeUInt32(readOffset);

    hcca_writeUInt16(readLength);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);


    uint16_t toRead = hcca_readUInt16();

    for (uint16_t i = 0; i < toRead; i++)
        buffer[i + bufferOffset] = hcca_readByte();

    return toRead;
}
