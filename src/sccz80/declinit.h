extern int initials(char *sname, int type, int ident, int dim, int more, TAG_SYMBOL *tag, char zfar);
extern int str_init(TAG_SYMBOL *tag);
extern void agg_init(int size, int type, int ident, int *dim, int more, TAG_SYMBOL *tag);
extern void init(int size, int ident, int *dim, int more, int dump, int is_struct);
extern int getstsize(SYMBOL *ptr,char real);
