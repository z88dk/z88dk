#ifndef _SORT_H
#define _SORT_H

typedef int (*cmpfilfunc_t)(struct file_record_ptr *a, struct file_record_ptr *b);

#ifndef NONONO

extern int sort_cmp_file_by_name(struct file_record_ptr *a, struct file_record_ptr *b);
extern int sort_cmp_file_by_time(struct file_record_ptr *a, struct file_record_ptr *b);
extern int sort_cmp_file_by_size(struct file_record_ptr *a, struct file_record_ptr *b);
extern int sort_cmp_file_by_extension(struct file_record_ptr *a, struct file_record_ptr *b);

extern int sort_cmp_option(struct opt *a, struct opt *b);
extern int sort_opt_search(unsigned char *name, struct opt *a);

#endif

#endif
