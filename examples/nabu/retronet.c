

//#define FONT_AMIGA
//#define FONT_SET1
//#define FONT_STANDARD
#define LM80C

#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <arch/nabu/retronet.h>

#define LOCAL_TMP_FILE "/tmp/testing.txt"
#define LOCAL_TMP_FILE_LEN 16

  // We use this for displaying file information and directory information later on
FileDetailsStruct fs;

#define BUFFERSIZE 4
uint8_t _buffer[BUFFERSIZE];


/// <summary>
/// Tests
/// - rn_fileOpen() local file readwrite
/// - rn_fileHandleInsert()
/// - rn_fileHandleReplace()
/// - rn_fileHandleClose()
/// </summary>
void doAlterLocalFile() {

  uint8_t writeFileHandle = rn_fileOpen(LOCAL_TMP_FILE_LEN, LOCAL_TMP_FILE, OPEN_FILE_FLAG_READWRITE, 0xff);

  printf("Altering the local file...\n");

  // For fun, let's insert some text at the beginning of the file that we just creaed
  // ------------------------------------------------------------------------------------------------
  rn_fileHandleInsert(writeFileHandle, 0, 0, 18, "This is new text. ");

  printf("Replacing some text ...\n");
  // Oh, now let's replace some text in the file
  // ------------------------------------------------------------------------------------------------
  rn_fileHandleReplace(writeFileHandle, 20, 0, 12, "I MADE THIS!");

  rn_fileHandleClose(writeFileHandle);
}


/// <summary>
/// Tests
/// - rn_fileOpen() readonly local file
/// - rn_fileHandleSize()
/// - rn_fileHandleSeek()
/// - rn_fileHandleReadSeq()
/// - rn_fileHandleClose
/// </summary>
void doReadSequential() {

  uint8_t readFileHandle = rn_fileOpen(LOCAL_TMP_FILE_LEN, LOCAL_TMP_FILE, OPEN_FILE_FLAG_READONLY, 0xff);

  // Display the handle of the file we're going to write to
  printf("read file handle: %u\n",readFileHandle);

  printf("Displaying local file non-seq read...\n");

  // Get the size of the file that we created and wrote to
  uint32_t size = rn_fileHandleSize(readFileHandle);

  // Display the size of the file
  printf("our file length: %lu\n",size);
 
  printf("Skipping first 3 characters with seek\n");
  uint32_t newPos = rn_fileHandleSeek(readFileHandle, 3, SEEK_SET);

  printf("read position is: %ld\n",newPos);

  while (1) {

    // read data from the http file that we downloaded in BUFFERSIZE (4 byte) parts
    uint16_t read = rn_fileHandleReadSeq(readFileHandle, _buffer, 0, BUFFERSIZE);

    // reached end of file so break out of loop
    if (read == 0)
      break;

    // display the data that we read onto the screen
    printf("%.*s", read, _buffer);

    msleep(100);
  }

  rn_fileHandleClose(readFileHandle);

  printf("\n\n");
}


/// <summary>
/// Tests
/// - rn_fileOpen() with http file
/// - rn_fileHandleSize()
/// - rn_fileHandleEmptyFile()
/// - rn_fileHandleRead()
/// - rn_fileHandleAppend()
/// - rn_fileHandleClose()
/// </summary>
void doReadHTTPWriteLocal() {

  // Instruct the IA to get a file and let the server return a file handle id
  uint8_t httpFileHandle = rn_fileOpen(46, "https://cloud.nabu.ca/httpGetQueryResponse.txt", OPEN_FILE_FLAG_READONLY, 0xff);

  // Display the status if the file was received
  printf("http file Handle: %u\n",httpFileHandle);

  // Get the size of the file that was received
  uint32_t size = rn_fileHandleSize(httpFileHandle);

  // Display the size of the file
  printf("read response length: %ld\n",size);

  uint8_t writeFileHandle = rn_fileOpen(LOCAL_TMP_FILE_LEN, LOCAL_TMP_FILE, OPEN_FILE_FLAG_READWRITE, 0xff);

  // Display the handle of the file we're going to write to
  printf("write file handle: %u\n",writeFileHandle);

  // If the file that we're going to write to has data in it, let's clear the data.
  // This is because we don't want data from the last time we ran it. We want a new
  // fresh empty file to populate.
  uint32_t testSize = rn_fileHandleSize(writeFileHandle);

  if (testSize > 0) {

    printf("File already exists and is %ld bytes\n",testSize);

    printf("Emptying the file!\n");

    rn_fileHandleEmptyFile(writeFileHandle);
  }

  // Display the file contents of the http file with a non-sequential read
  // 
  // These next few lines will use the buffer to read from the IA each part of the file
  // 
  // We will also write the contents to a new file 
  //
  // As the file is requested by the NABU, the text is displayed 
  // on the screen. 
  // ------------------------------------------------------------------------------------------------

  printf("Displaying from the http file...\n");

  uint32_t readPos = 0;
  while (1) {

    // read data from the http file that we downloaded in BUFFERSIZE (4 byte) parts
    uint16_t read = rn_fileHandleRead(httpFileHandle, _buffer, 0, readPos, BUFFERSIZE);

    // reached end of file so break out of loop
    if (read == 0)
      break;

    readPos += read;

    // write the data we read out to the file
    rn_fileHandleAppend(writeFileHandle, 0, read, _buffer);

    // display the data that we read onto the screen
    printf("%.*s", read, _buffer);

    msleep(100);
  }

  rn_fileHandleClose(httpFileHandle);
  rn_fileHandleClose(writeFileHandle);

}


/// <summary>
/// Tests
/// - rn_fileOpen() local file read only
/// - rn_fileHandleDetails()
/// - rn_fileHandleClose()
/// </summary>
void doShowFileDetails() {

  // Display addition details about the file we just wrote to
  // ------------------------------------------------------------------------------------------------

  uint8_t readFileHandle = rn_fileOpen(LOCAL_TMP_FILE_LEN, LOCAL_TMP_FILE, OPEN_FILE_FLAG_READONLY, 0xff);

  rn_fileHandleDetails(readFileHandle, &fs);

  rn_fileHandleClose(readFileHandle);

  printf("Filename: %.*s\n",fs.FilenameLen, fs.Filename);

  printf("File Size: %ld\n",fs.FileSize);

  printf("Created: %d-%d-%d %d:%d:%d\n",fs.CreatedYear, fs.CreatedMonth, fs.CreatedDay, fs.CreatedHour, fs.CreatedMinute, fs.CreatedSecond);
  printf("Modified: %d-%d-%d %d:%d:%d\n",fs.ModifiedYear, fs.ModifiedMonth, fs.ModifiedDay, fs.ModifiedHour, fs.ModifiedMinute, fs.ModifiedSecond);
}


/// <summary>
/// Tests 
/// - rn_fileList() include files & directories
/// - rn_fileListItem()
/// </summary>
void doDirectoryListing() {

  uint16_t fileCnt = rn_fileList(17, "z:\\test\\directory", 1, "*", FILE_LIST_FLAG_INCLUDE_FILES | FILE_LIST_FLAG_INCLUDE_DIRECTORIES);

  printf("Files in z:\\test\\directory: %d\n",fileCnt);

  for (uint16_t i = 0; i < fileCnt; i++) {

    rn_fileListItem(i, &fs);

    if (fs.IsFile) {
      printf("Filename: %.*s\n",fs.FilenameLen, fs.Filename);
      printf("File Size: %ld\n",fs.FileSize);
    } else {
      printf("Directory Name: %.*s\n", fs.FilenameLen, fs.Filename);
    }

    printf("Created: %d-%d-%d %d:%d:%d\n",fs.CreatedYear,
		fs.CreatedMonth,
		fs.CreatedDay,
		fs.CreatedHour,
		fs.CreatedMinute,
		fs.CreatedSecond);

    printf("Modified: %d-%d-%d %d:%d:%d\n",fs.ModifiedYear,
		fs.ModifiedMonth,
		fs.ModifiedDay,
		fs.ModifiedHour,
		fs.ModifiedMinute,
		fs.ModifiedSecond);
  }

}

void main() {

  int mode = 2;

  console_ioctl(IOCTL_GENCON_SET_MODE, &mode);

  // Put the graphics into text mode with the text color 0x01 and background color 0x03
  printf("Starting HTTP Write Local\n");
  doReadHTTPWriteLocal();

  printf("Alter local file\n");
  doAlterLocalFile();

  doReadSequential();

  doShowFileDetails();

  doDirectoryListing();

  printf("Done");

  while (1) {}
}

