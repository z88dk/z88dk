/* constant.c */
extern int constant(LVALUE *lval);
extern int fnumber(int32_t *val);
extern int stash_double_str(char *start,char *end);
extern int32_t searchdub(unsigned char *num);
extern int number(int32_t *val);
extern int hex(char c);
extern void address(SYMBOL *ptr);
extern int pstr(int32_t *val);
extern int tstr(int32_t *val);
extern int storeq(int length, unsigned char *queue,int32_t *val);
extern int qstr(int32_t *val);
extern void stowlit(int value, int size);
extern unsigned char litchar(void);
extern void size_of(LVALUE *lval);
extern int GetMembSize(TAG_SYMBOL *ptr);
