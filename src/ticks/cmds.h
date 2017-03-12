
#ifndef CMDS_H
#define CMDS_H


/* All routines, c = error, nc = not error, if error, a = error */

#define CMD_EXIT       0    /**< Exit, hl holds return value */
#define CMD_PRINTCHAR  1    /**< Print character, hl holds character to print */
#define CMD_READKEY    2    /**< Read console, hl holds the pressed key */

#define CMD_OPENF      3    /**< Open file on disc, hl = filename, de = mode, ret hl = handle */
#define CMD_CLOSEF     4    /**< Close file (b=handle) */
#define CMD_WRITEBYTE  5    /**< Write byte, b=handle, l = byte to write */
#define CMD_READBYTE   6    /**< Read byte, b= handle, Ret hl = byte */
#define CMD_WRITEBLOCK 7    /**< Write a block, b=handle, de=address, hl=length, ret hl=bytes written */
#define CMD_READBLOCK  8    /**< Read a block, b=handle, de=address, hl=length, ret hl=bytes read */
#define CMD_SEEK       9    /**< Seek in a file, b=handle, dehl=offset, c=whence, ret dehl=position */
#define CMD_STAT       10   /**< Stat a file (hl=filename, de=stat buffer) */

 /* Directory handling */ 
#define CMD_MKDIR      40   /**< Make a directory (hl=directory name) */
#define CMD_RMDIR      41   /**< Remove a directory (hl=directory name) */

/* Opendir, closedir etc */

#define CMD_REMOVE     20    /**< Remove file, hl=filename */
#define CMD_RENAME     21   /**< Rename file, hl=source, de=dest */

#define CMD_GETTIME       30    /*< Get unix time (ret=dehl = 32 bit seconds)  */

#define CMD_DBG       255  /**< Debugger build */

#endif
