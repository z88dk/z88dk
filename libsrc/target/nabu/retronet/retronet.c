// ****************************************************************************************
// NABU-LIB C Library
// DJ Sures (c) 2023
// https://nabu.ca
// 
// Read the NABU-LIB.h file for details of each function in this file.
// 
// *Note: Some TMS9918 graphic functions were from: https://github.com/michalin/TMS9918_Arduino/tree/main/examples
//        Modified by DJ Sures 2022 for NABU PC
//
// **********************************************************************************************


#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>






#define RETRONET_CMD_FILE_OPEN  0xa3
#define RETRONET_CMD_FH_SIZE 0xa4
#define RETRONET_CMD_FH_READ 0xa5
#define RETRONET_CMD_FH_CLOSE 0xa7
#define RETRONET_CMD_FILE_SIZE  0xa8
#define RETRONET_CMD_FH_WRITE_APPEND 0xa9
#define RETRONET_CMD_FH_WRITE_INSERT 0xaa
#define RETRONET_CMD_FH_DELETE_RANGE 0xab
#define RETRONET_CMD_FH_REPLACE_RANGE 0xac
#define RETRONET_CMD_FILE_DELETE       0xad
#define RETRONET_CMD_FILE_COPY         0xae
#define RETRONET_CMD_FILE_MOVE         0xaf
#define RETRONET_CMD_FH_TRUNCATE        0xb0
#define RETRONET_CMD_FILE_LIST         0xb1
#define RETRONET_CMD_FILEIDX_STAT      0xb2

#define RETRONET_CMD_FILE_STAT         0xb3
#define RETRONET_CMD_FH_DETAILS        0xb4
#define RETRONET_CMD_FILE_READ_SEQ     0xb5
#define RETRONET_CMD_FH_SEEK         0xb6

// **************************************************************************
// RetroNET
// ------------
// **************************************************************************

uint8_t rn_fileOpen(uint8_t filenameLen, uint8_t* filename, uint16_t fileFlag, uint8_t fileHandle) {

    //0xa3
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_OPEN);
    hcca_writeByte(filenameLen);
    hcca_writeBytes(0, filenameLen, filename);
    hcca_writeUInt16(fileFlag);
    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readByte();
}

void rn_fileHandleClose(uint8_t fileHandle) 
{
    //0xa7
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_CLOSE);

    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

int32_t rn_fileSize(uint8_t filenameLen, uint8_t* filename) {

    //0xa8
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_SIZE);
    hcca_writeByte(filenameLen);
    hcca_writeBytes(0, filenameLen, filename);

    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readInt32();
}

int32_t rn_fileHandleSize(uint8_t fileHandle) {

    //0xa4
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_SIZE);

    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readInt32();
}


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

void rn_fileHandleAppend(uint8_t fileHandle, uint16_t dataOffset, uint16_t dataLen, uint8_t* data) {

    //0xa9
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);

    hcca_writeByte(RETRONET_CMD_FH_WRITE_APPEND);
    hcca_writeByte(fileHandle);
    hcca_writeUInt16(dataLen);
    hcca_writeBytes(dataOffset, dataLen, data);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

void rn_fileHandleInsert(uint8_t fileHandle, uint32_t fileOffset, uint16_t dataOffset, uint16_t dataLen, uint8_t* data) {

    //0xaa
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);

    hcca_writeByte(RETRONET_CMD_FH_WRITE_INSERT);

    hcca_writeByte(fileHandle);

    hcca_writeUInt32(fileOffset);

    hcca_writeUInt16(dataLen);

    hcca_start_write(HCCA_MODE_HDR, data + dataOffset, dataLen);
}

void rn_fileHandleDeleteRange(uint8_t fileHandle, uint32_t fileOffset, uint16_t deleteLen) {

    // 0xab

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);

    hcca_writeByte(RETRONET_CMD_FH_DELETE_RANGE);

    hcca_writeByte(fileHandle);

    hcca_writeUInt32(fileOffset);

    hcca_writeUInt16(deleteLen);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

}

void rn_fileHandleEmptyFile(uint8_t fileHandle) {

    // 0xb0
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_TRUNCATE);

    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

void rn_fileHandleReplace(uint8_t fileHandle, uint32_t fileOffset, uint16_t dataOffset, uint16_t dataLen, uint8_t* data) {

    // 0xac

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);

    hcca_writeByte(RETRONET_CMD_FH_REPLACE_RANGE);

    hcca_writeByte(fileHandle);

    hcca_writeUInt32(fileOffset);

    hcca_writeUInt16(dataLen);

    hcca_writeBytes(dataOffset, dataLen, data);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

void rn_fileDelete(uint8_t filenameLen, uint8_t* filename) {

  // 0xad

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_DELETE);

    hcca_writeByte(filenameLen);

    hcca_writeBytes(0, filenameLen, filename);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

void rn_fileHandleCopy(uint8_t srcFilenameLen, uint8_t* srcFilename, uint8_t destFilenameLen, uint8_t* destFilename, uint8_t copyMoveFlag) {

    // 0xae

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_COPY);

    hcca_writeByte(srcFilenameLen);

    hcca_writeBytes(0, srcFilenameLen, srcFilename);

    hcca_writeByte(destFilenameLen);

    hcca_writeBytes(0, destFilenameLen, destFilename);

    hcca_writeByte(copyMoveFlag);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

void rn_fileHandleMove(uint8_t srcFilenameLen, uint8_t* srcFilename, uint8_t destFilenameLen, uint8_t* destFilename, uint8_t copyMoveFlag) {

    // 0xaf
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_MOVE);
    hcca_writeByte(srcFilenameLen);

    hcca_writeBytes(0, srcFilenameLen, srcFilename);

    hcca_writeByte(destFilenameLen);

    hcca_writeBytes(0, destFilenameLen, destFilename);

    hcca_writeByte(copyMoveFlag);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
}

uint16_t rn_fileList(uint8_t pathLen, uint8_t* path, uint8_t wildcardLen, uint8_t* wildcard, uint8_t fileListFlags) {

    // 0xb1

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_LIST);

    hcca_writeByte(pathLen);

    hcca_writeBytes(0, pathLen, path);

    hcca_writeByte(wildcardLen);

    hcca_writeBytes(0, wildcardLen, wildcard);

    hcca_writeByte(fileListFlags);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readUInt16();
}

void rn_fileListItem(uint16_t fileItemIndex, FileDetailsStruct* s) {

    // 0xb2
    // 
    // The response is 83 bytes and structured like so...
    // 
    // Bytes       Type      Description
    // ----------  --------  ------------------------------------
    // 0, 1, 2, 3  int32_t   Filesize (or -1 for a folder)
    // 4, 5        uint16_t  Created Year
    // 6           uint8_t   Created Month
    // 7           uint8_t   Created Day
    // 8           uint8_t   Created Hour (24 hour)
    // 9           uint8_t   Created Minute
    // 10          uint8_t   Created Second
    // 11, 12      uint16_t  Modified Year
    // 13          uint8_t   Modified Month
    // 14          uint8_t   Modified Day
    // 15          uint8_t   Modified Hour (24 hour)
    // 16          uint8_t   Modified Minute
    // 17          uint8_t   Modified Second
    // 18          uint8_t   Length of filename (max 64)
    // 19..82                The remaining bytes is the filename

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILEIDX_STAT);

    hcca_writeUInt16(fileItemIndex);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    s->FileSize = hcca_readInt32(); // 0, 1, 2, 3

    s->CreatedYear = hcca_readUInt16(); // 4, 5
    s->CreatedMonth = hcca_readByte(); // 6
    s->CreatedDay = hcca_readByte(); // 7
    s->CreatedHour = hcca_readByte(); // 8
    s->CreatedMinute = hcca_readByte(); // 9
    s->CreatedSecond = hcca_readByte(); // 10

    s->ModifiedYear = hcca_readUInt16(); // 11, 12
    s->ModifiedMonth = hcca_readByte(); // 13
    s->ModifiedDay = hcca_readByte(); // 14
    s->ModifiedHour = hcca_readByte(); // 15
    s->ModifiedMinute = hcca_readByte(); // 16
    s->ModifiedSecond = hcca_readByte(); // 17

    s->FilenameLen = hcca_readByte(); // 18

    hcca_readBytes(0, 64, (uint8_t*)s->Filename); // 19-64

    s->IsFile = (s->FileSize >= 0);
    s->Exists = (s->FileSize != -2);
}

void rn_fileDetails(uint8_t filenameLen, uint8_t* filename, FileDetailsStruct* s) {

    // 0xb3
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_STAT);

    hcca_writeByte(filenameLen);

    hcca_writeBytes(0, filenameLen, filename);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);


    s->FileSize = hcca_readInt32(); // 0, 1, 2, 3

    s->CreatedYear = hcca_readUInt16(); // 4, 5
    s->CreatedMonth = hcca_readByte(); // 6
    s->CreatedDay = hcca_readByte(); // 7
    s->CreatedHour = hcca_readByte(); // 8
    s->CreatedMinute = hcca_readByte(); // 9
    s->CreatedSecond = hcca_readByte(); // 10

    s->ModifiedYear = hcca_readUInt16(); // 11, 12
    s->ModifiedMonth = hcca_readByte(); // 13
    s->ModifiedDay = hcca_readByte(); // 14
    s->ModifiedHour = hcca_readByte(); // 15
    s->ModifiedMinute = hcca_readByte(); // 16
    s->ModifiedSecond = hcca_readByte(); // 17

    s->FilenameLen = hcca_readByte(); // 18

    hcca_readBytes(0, 64, (uint8_t*)s->Filename); // 19-64

    s->IsFile = (s->FileSize >= 0);
    s->Exists = (s->FileSize != -2);
}

void rn_fileHandleDetails(int8_t fileHandle, FileDetailsStruct* s) {

    // 0xb4

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_DETAILS);
    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    s->FileSize = hcca_readInt32(); // 0, 1, 2, 3

    s->CreatedYear = hcca_readUInt16(); // 4, 5
    s->CreatedMonth = hcca_readByte(); // 6
    s->CreatedDay = hcca_readByte(); // 7
    s->CreatedHour = hcca_readByte(); // 8
    s->CreatedMinute = hcca_readByte(); // 9
    s->CreatedSecond = hcca_readByte(); // 10

    s->ModifiedYear = hcca_readUInt16(); // 11, 12
    s->ModifiedMonth = hcca_readByte(); // 13
    s->ModifiedDay = hcca_readByte(); // 14
    s->ModifiedHour = hcca_readByte(); // 15
    s->ModifiedMinute = hcca_readByte(); // 16
    s->ModifiedSecond = hcca_readByte(); // 17

    s->FilenameLen = hcca_readByte(); // 18

    hcca_readBytes(0, 64, (uint8_t*)s->Filename); // 19-64

    s->IsFile = (s->FileSize >= 0);
    s->Exists = (s->FileSize != -2);
}

uint16_t rn_fileHandleReadSeq(uint8_t fileHandle, uint8_t* buffer, uint16_t bufferOffset, uint16_t readLength) {

    // 0xb5
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_READ_SEQ);
    hcca_writeByte(fileHandle);

    hcca_writeUInt16(readLength);

    uint16_t toRead = hcca_readUInt16();

    for (uint16_t i = 0; i < toRead; i++)
    buffer[i + bufferOffset] = hcca_readByte();

    return toRead;
}

uint32_t rn_fileHandleSeek(uint8_t fileHandle, int32_t offset, uint8_t seekOption) {

    // 0xb6

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_SEEK);

    hcca_writeByte(fileHandle);

    hcca_writeInt32(offset);

    hcca_writeByte(seekOption);

    return hcca_readUInt32();
}


