#ifndef _SORT_H
#define _SORT_H

extern int sort_type(struct type *a, struct type *b);
extern int find_type(char *extension, struct type *a);

extern int sort_option(struct opt *a, struct opt *b);
extern int find_option(unsigned char *name, struct opt *a);

#endif
