
#ifndef CMDS_H
#define CMDS_H


/* All routines, c = error, nc = not error, if error, a = error */

#define CMD_EXIT       0    /**< Exit, hl holds return value */
#define CMD_PRINTCHAR  1    /**< Print character, hl holds character to print */
#define CMD_READKEY    2    /**< Read console, hl holds the pressed key */
#define CMD_POLLKEY    3    /**< Poll console, hl holds the pressed key or -1 */

#define CMD_OPENF      4    /**< Open file on disc, hl = filename, de = mode, ret hl = handle */
#define CMD_CLOSEF     5    /**< Close file (b=handle) */
#define CMD_WRITEBYTE  6    /**< Write byte, b=handle, l = byte to write */
#define CMD_READBYTE   7    /**< Read byte, b= handle, Ret hl = byte */
#define CMD_WRITEBLOCK 8    /**< Write a block, b=handle, de=address, hl=length, ret hl=bytes written */
#define CMD_READBLOCK  9    /**< Read a block, b=handle, de=address, hl=length, ret hl=bytes read */
#define CMD_SEEK       10   /**< Seek in a file, b=handle, dehl=offset, c=whence, ret dehl=position */
#define CMD_STAT       11   /**< Stat a file (hl=filename, de=stat buffer) */


/* Opendir, closedir etc */

#define CMD_REMOVE     20   /**< Remove file, hl=filename */
#define CMD_RENAME     21   /**< Rename file, hl=source, de=dest */

 /* Directory handling */ 
#define CMD_MKDIR      25   /**< Make a directory (hl=directory name) */
#define CMD_RMDIR      26   /**< Remove a directory (hl=directory name) */

#define CMD_GETTIME    30   /*< Get unix time (ret=dehl = 32 bit seconds)  */
#define CMD_GETCLOCK   31   /*< Get millis since some time (ret=dehl = 32 bit milliseconds)  */

#define CMD_IDE_SELECT 40   /**< Select unit (l) */
#define CMD_IDE_ID     41   /**< Get number of logical blocks -> dehl  */
#define CMD_IDE_READ   42   /**< Read bchl=lba to de=address */
#define CMD_IDE_WRITE  43   /**< Write bchl=lba from de=address */

#define CMD_DBG       255   /**< Debugger build */

#endif
