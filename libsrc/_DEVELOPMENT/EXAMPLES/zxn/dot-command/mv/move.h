#ifndef _MOVE_H
#define _MOVE_H

#define MOVE_TYPE_FILE_TO_FILE  0
#define MOVE_TYPE_FILE_TO_DIR   1
#define MOVE_TYPE_DIR_TO_FILE   2
#define MOVE_TYPE_DIR_TO_DIR    3
#define MOVE_TYPE_ERROR         4

extern unsigned char move_classify(unsigned char src_type, unsigned char dst_type);

extern unsigned char move_file_to_file(void);
extern unsigned char move_file_to_dir(void);
extern unsigned char move_dir_to_dir(void);

#endif
