#ifndef ARCH_NABU_RETRONET_H
#define ARCH_NABU_RETRONET_H

#include <stdint.h>

// **************************************************************************
// RetroNET
// ------------
// 
// These are methods specific to RetroNet and therefore require the IA 
// (internet adapter) to be connected to the NABU.
// 
// The Internet Adapter will hold the data and the NABU can request it. The
// data is stored in the IA under specified Request Store IDs. That way, a
// program can have many requests stored in the IA as resources. The program
// can store items from the web on the IA, such as images, music arrangements,
// or even code. Code can be copied from the IA request store and written
// to RAM to be executed.
// 
// This allows a NABU program the ability to have a practically unlimited 
// amount of RAM or storage by using the cloud and Internet Adapter.
// 
// **************************************************************************

/// <summary>
/// These are options for the rn_fileOpen() fileFlag function
/// </summary>
#define OPEN_FILE_FLAG_READONLY 0b00000000
#define OPEN_FILE_FLAG_READWRITE 0b00000001

/// <summary>
/// These are options for the rn_fileHandleCopy() and rn_fileHandleMove()
/// </summary>
#define COPY_MOVE_FLAG_NO_REPLACE 0b00000000
#define COPY_MOVE_FLAG_YES_REPLACE 0b00000001

/// <summary>
/// These are options for the rn_fileList()
/// </summary>
#define FILE_LIST_FLAG_INCLUDE_FILES 0b00000001 
#define FILE_LIST_FLAG_INCLUDE_DIRECTORIES 0b00000010 

/// <summary>
/// These are options for the rn_fileHandleSeed()
/// SEEK_SET seek from the beginning of the file
/// SEEK_CUR offset from the current position
/// SEEK_END offset from the end of the file
/// </summary>
#define RN_SEEK_SET 1
#define RN_SEEK_CUR 2
#define RN_SEEK_END 3


/// <summary>
/// The details of each file
/// </summary>
typedef struct {

  int32_t FileSize;

  uint16_t CreatedYear;
  uint8_t CreatedMonth;
  uint8_t CreatedDay;
  uint8_t CreatedHour;
  uint8_t CreatedMinute;
  uint8_t CreatedSecond;

  uint16_t ModifiedYear;
  uint8_t ModifiedMonth;
  uint8_t ModifiedDay;
  uint8_t ModifiedHour;
  uint8_t ModifiedMinute;
  uint8_t ModifiedSecond;

  uint8_t FilenameLen;
  uint8_t Filename[64];

  uint8_t IsFile;
  uint8_t Exists;

} FileDetailsStruct;

/// <summary>
/// Opens the file and returns a file handle that will be used for all file functions.
/// Files are stored in the RetroNET Storage folder that is defined in the Internet Adapter settings. 
/// 
/// The fileFlag is managed on the IA and if set for readonly, any write commands will
/// be ignored. This ensures the nabulib has not been tampered with to accidentally
/// overwrite readonly files.
/// 
/// *Note: that FTP, HTTP, and HTTPS write functions are not persistent. If a WRITE function is 
/// called on a file handle of one of these file types, the file will be altered, but the changes
/// will not be persistent the next time the URL is requested. This because we cannot change files
/// on remote servers - they won't give us the key to unlock the universe, yet.
/// 
/// Multiple file types are available...
/// 
/// - FTP:   ftp://<host>/<path>/<file>
///          (i.e. ftp://ftp.cdrom.com/pub/filelist.txt)
/// 
/// - HTTP:  http://<host>/<path>/<file>?<url parameters>
///          (Example: http://cloud.nabu.ca/httpGetQueryResponse.txt?someparam=somevalue)
/// 
/// - HTTPS: https://<host>/<path>/<file>
///          (Example: https://cloud.nabu.ca/httpGetQueryResponse.txt)
/// 
/// - File:
///          The "File" type has many options. Directory seperator is backslash (\)
/// 
/// 1) Specify a filename with no drive or directory. For example...
///    uint8_t fileHandle = rn_requestStoreOpenFile(10, "myFile.txt", OPEN_FILE_FLAG_READWRITE, 0xff);
///   
/// 2) Specify a filename with drive or directory. For example...
///    uint8_t fileHandle = rn_requestStoreOpenFile(22, "a:\\personal\\myFile.txt", OPEN_FILE_FLAG_READWRITE, 0xff);
/// 
/// 3) Specify a filename with directory. For example...
///    uint8_t fileHandle = rn_requestStoreOpenFile(20, "personal\\myFile.txt", OPEN_FILE_FLAG_READWRITE, 0xff);
/// 
/// *Note: If the file does not exist, it is created with 0 bytes.
/// 
/// When you are done with the file, you must Close the file to release the handle with with rn_requestStoreCloseFile();
/// If the NABU is reset and the program therefore cannot close the file, the Internet Adapter will close all files
/// when an INIT command is received.
/// 
/// - filenameLen is the length of the filename to open
/// - filename is a pointer to the filename
/// - fileFlag is one of #define OPEN_FILE_FLAG_* types
/// - fileHandle can be a file handle that you specify or 0xff (255) for the
///   server to assign one for you
/// 
/// Returns a handle to the file for other file functions. If fileHandle is 255 (0xff), a file handle is
/// automatically returned to you. Otherwise, this function will return the fileHandle parameter that you
/// passed to it. If the fileHandle that you passed is already in use, a new file handle will be assigned
/// to you and returned. 
/// </summary>
extern uint8_t __LIB__ rn_fileOpen(uint8_t filenameLen, char *filename, uint16_t fileFlag, uint8_t fileHandle) __smallc;

/// <summary>
/// Closes and releases the file with the specified fileHandle. The handle can be used again for another
/// file once it has been released.
/// 
/// When you are done with the file, you must Close the file to release the handle with with rn_requestStoreCloseFile();
/// If the NABU is reset and the program therefore cannot close the file, the Internet Adapter will close all files
/// when an INIT command is received.
/// </summary>
extern void __LIB__ rn_fileHandleClose(uint8_t fileHandle) __smallc;

/// <summary>
/// Get the file size of the specified file, or returns -1 if file does not exist.
/// This is different than using rn_fileHandleSize() because that will create an empty file when
/// a file handle is assigned. If you want to see if a file exists without creating it first, this
/// is the function you would use. 
/// </summary>
extern int32_t __LIB__ rn_fileSize(uint8_t filenameLen, char *filename) __smallc;

/// <summary>
/// Get the file size of the specified file handle.
/// A file (not url) that is opened with rn_FileOpen() will always have 0 length because the file is
/// created with 0 bytes when rn_fileOpen() is called. To check if a file exists, use the rn_fileSize()
/// function, as it expects a filename (not a file handle) and therefore does not create the file.
/// 
/// If a URL is used and the URL was not downloaded, the file size will be -1. You will only ever get
/// a -1 from a URL, not a file.
/// </summary>
extern int32_t __LIB__ rn_fileHandleSize(uint8_t fileHandle) __smallc;

/// <summary>
/// Get the file details by filename.
/// 
/// The FileDetailStruct is populated with details about the file. If the file does not exist,
/// the FileDetailStruct->Exists will reflect that.
/// </summary>
extern void __LIB__ rn_fileDetails(uint8_t filenameLen, char *filename, FileDetailsStruct* s) __smallc;

/// <summary>
/// Get the file details by file handle.
/// 
/// The FileDetailStruct is populated with details about the file. If the file does not exist,
/// the FileDetailStruct->Exists will reflect that.
/// </summary>
extern void __LIB__ rn_fileHandleDetails(int8_t fileHandle, FileDetailsStruct* s) __smallc;

/// <summary>
/// Read data from the specified filename.
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// - buffer is a pointer to a buffer that the data will be written to.
/// - bufferOffset is the offset within the buffer where the data will be written. Use 0 if you're
///   writing to the beginning of the buffer, for example.
/// - readOffset is the offset of the file that you will be reading from. 
/// - readLength is the amount of data that you will be reading.
/// 
/// Returns the number of bytes read or 0 if there was an error or reached EOF
/// </summary>
extern uint16_t __LIB__ rn_fileHandleRead(uint8_t fileHandle, uint8_t* buffer, uint16_t bufferOffset, uint32_t readOffset, uint16_t readLength) __smallc;

/// <summary>
/// Append data to the end of the specified file in the filestore. If the file does not exist, 
/// the file is created. Files are stored in the RetroNET Storage folder that is defined in 
/// the Internet Adapter settings. 
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// - dataOffset is the offset of the data that will be written
/// - dataLen is the length of data that will be written 
/// - data is a pointer to the data
/// </summary>
extern void __LIB__ rn_fileHandleAppend(uint8_t fileHandle, uint16_t dataOffset, uint16_t dataLen, void *data) __smallc;

/// <summary>
/// Insert data in the file at the specified offset. This function will shift all data following the
/// fileOffset to insert the data.
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// - fileOffset is the offset of the file where the data will be inserted
/// - dataOffset is the offset of the data that will be written
/// - dataLen is the length of data that will be written 
/// - data is a pointer to the data
/// </summary>
extern void __LIB__ rn_fileHandleInsert(uint8_t fileHandle, uint32_t fileOffset, uint16_t dataOffset, uint16_t dataLen, void *data) __smallc;

/// <summary>
/// Delete range of bytes from within file handle
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// - fileOffset is the offset of the file where the data will be removed
/// - deleteLen is the length of data that will be removed
/// </summary>
extern void __LIB__ rn_fileHandleDeleteRange(uint8_t fileHandle, uint32_t fileOffset, uint16_t deleteLen) __smallc;

/// <summary>
/// Delete all the content of the file and leave the file as a 0 byte length
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// </summary>
extern void __LIB__ rn_fileHandleEmptyFile(uint8_t fileHandle) __smallc;

/// <summary>
/// Replace data in a file by overwriting bytes with the data
/// Files are stored in the RetroNET Storage folder that is defined in the Internet Adapter settings. 
/// The file can contain slashes (\) or (/) to specify directory and drive (i.e. A:)
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// - fileOffset is the offset of the file where the data will be overwritten
/// - dataOffset is the offset of the data that will be written
/// - dataLen is the length of data that will be written 
/// - data is a pointer to the data
/// </summary>
extern void __LIB__ rn_fileHandleReplace(uint8_t fileHandle, uint32_t fileOffset, uint16_t dataOffset, uint16_t dataLen, void *data) __smallc;

/// <summary>
/// Delete the physical file from the store. If the file has a handle, it is closed
/// 
/// - filenameLen is the length of the filename
/// - filename is the filename string
/// </summary>
extern void __LIB__ rn_fileDelete(uint8_t filenameLen, char *filename) __smallc;

/// <summary>
/// Copy the src file to the dest file. The source file can be of any type (http, ftp, file) but the
/// dest file must be a regular file. This allows copying files from the cloud to the local
/// file store.
/// 
/// - srcFilenameLen is the length of the source file to copy
/// - srcFilename is a pointer to the filename of the source file
/// - destFilenameLen is the length of the destination filename
/// - destFilename is a pointer to the filename of the destionation file
/// - copyMoveFlag is one of #define COPY_MOVE_FLAG_* 
/// </summary>
extern void __LIB__ rn_fileHandleCopy(uint8_t srcFilenameLen, uint8_t* srcFilename, uint8_t destFilenameLen, uint8_t* destFilename, uint8_t copyMoveFlag) __smallc;

/// <summary>
/// Move the src file to the dest file.
/// 
/// *Note: if the source file has an open file handle, it is not closed and will continue
///        working with the old filename. It's expected that a friendly
///        programmer would close the file first before moving/renaming it. 
/// 
/// - srcFilenameLen is the length of the source file to move
/// - srcFilename is a pointer to the filename of the source file
/// - destFilenameLen is the length of the destination filename
/// - destFilename is a pointer to the filename of the destionation file
/// - copyMoveFlag is one of #define COPY_MOVE_FLAG_* 
/// </summary>
extern void __LIB__ rn_fileHandleMove(uint8_t srcFilenameLen, uint8_t* srcFilename, uint8_t destFilenameLen, uint8_t* destFilename, uint8_t copyMoveFlag) __smallc;

/// <summary>
/// Returns the number of files within the path, including wildcards.
/// 
/// To get the details of a file, you must do this...
/// 
/// 1) rn_fileList() will give you the number of files that matches the search criteria. 
///  
/// 2) Finally, call rn_fileListItem() to get the details of the file 
///    (including size, created, modified, and filename)
/// 
/// Examples
/// - uint16_t fileCnt =  rn_fileList(1, "\\",  1, "*", FILE_LIST_FLAG_INCLUDE_FILES | FILE_LIST_FLAG_INCLUDE_DIRECTORIES);
/// - uint16_t fileCnt =  rn_fileList(1, "\\", 3, "*.*");
/// - uint16_t fileCnt =  rn_fileList(8, "c:\\myApp", 3, "*.*");
/// - uint16_t fileCnt =  rn_fileList(6, "a:\\cpm", 7, "zo*.cmd");
/// 
/// - pathLen is the length of the path string
/// - path is a pointer to the path string
/// - wildcardLen is the length of the wildcard string
/// - wildcard is a pointer to the wildcard string
/// - fileListFlags is one or many values of #define FILE_LIST_FLAG_*
/// 
/// Returns the number of matching files. Call rn_fileListItem() from 0 to N
/// </summary>
extern uint16_t __LIB__ rn_fileList(uint8_t pathLen, char *path, uint8_t wildcardLen, char *wildcard, uint8_t fileListFlags) __smallc;

/// <summary>
/// Populates buffer with the size, created datetime, modified datetime, 
/// filename length, and filename of the file at the fileItemIndex.
/// </summary>
extern void __LIB__ rn_fileListItem(uint16_t fileItemIndex, FileDetailsStruct* s) __smallc;

/// <summary>
/// Sequentially read data from the specified filename. That means continue reading from the
/// last position of the file. The file position can be changed programatically with
/// rn_fileHandleSeek() as well.
/// 
/// - fileHandle is the obtained by rn_fileOpen()
/// - buffer is a pointer to a buffer that the data will be written to.
/// - bufferOffset is the offset within the buffer where the data will be written. Use 0 if you're
///   writing to the beginning of the buffer, for example.
/// - readOffset is the offset of the file that you will be reading from. 
/// - readLength is the amount of data that you will be reading.
/// 
/// Returns the number of bytes read. If this number differs from the readLength parameter, then 
/// either an error had occurred or the End Of File was reached. 0 will be returned if the end of
/// the file has been reached
/// </summary>
extern uint16_t __LIB__ rn_fileHandleReadSeq(uint8_t fileHandle, uint8_t* buffer, uint16_t bufferOffset, uint16_t readLength) __smallc;

/// <summary>
/// Sets the sequential read position within the file for using rn_fileHandleReadSeq()
/// 
/// - fileHandle is obtained by rn_fileOpen()
/// - offset is the positive or negative position to move to. If using SEEK_SET,
///          only positive values are relevant. If using SEEK_CUR, a positive or 
///          negative value can be used to move forward or backward from the current
///          position. If using SEEK_END, only a negatie number can be used because it
///          will be the offset from the end of the file.
/// - seekOption is the option to seek. One of these...
///              SEEK_SET seek from the beginning of the file
///              SEEK_CUR offset from the current position
///              SEEK_END offset from the end of the file
/// 
/// Returns the new position of the file. If the seek is set past the end of the file, the
/// end of the file position is returned. The seek function will not let you seek past
/// the end of a file, or before a file. That is why we give you this value so you can be sure
/// the pointer is always within the file.
/// </summary>
extern uint32_t __LIB__ rn_fileHandleSeek(uint8_t fileHandle, int32_t offset, uint8_t seekOption) __smallc;


// Internal codes for the transport
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


#endif
