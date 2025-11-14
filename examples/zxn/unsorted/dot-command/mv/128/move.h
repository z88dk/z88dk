#ifndef _MOVE_H
#define _MOVE_H

#define MOVE_TYPE_FILE_TO_FILE  0
#define MOVE_TYPE_FILE_TO_DIR   1
#define MOVE_TYPE_DIR_TO_FILE   2
#define MOVE_TYPE_DIR_TO_DIR    3
#define MOVE_TYPE_ERROR         4

extern unsigned char move_classify(unsigned char src_type, unsigned char dst_type);

#define MOVE_ERROR_FILE_EXISTS         0xff
#define MOVE_ERROR_BUFFER_UNAVAILABLE  0xfe
#define MOVE_ERROR_SELF_COPY           0xfd
#define MOVE_ERROR_FILE_IS_DIR         0xfc
#define MOVE_ERROR_CANNOT_REMOVE       0xfb

#ifndef NONONO
extern unsigned char move_file_to_file(struct file_info *src, struct file_info *dst);
extern unsigned char move_file_to_dir(struct file_info *src, struct file_info *dst);
extern unsigned char move_dir_to_dir(struct file_info *src, struct file_info *dst);
#endif

#endif
