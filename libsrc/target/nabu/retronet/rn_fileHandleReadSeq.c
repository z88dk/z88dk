
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>


uint16_t rn_fileHandleReadSeq(uint8_t fileHandle, uint8_t* buffer, uint16_t bufferOffset, uint16_t readLength) {

    // 0xb5
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_READ_SEQ);
    hcca_writeByte(fileHandle);

    hcca_writeUInt16(readLength);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    uint16_t toRead = hcca_readUInt16();

    for (uint16_t i = 0; i < toRead; i++)
        buffer[i + bufferOffset] = hcca_readByte();

    return toRead;
}

