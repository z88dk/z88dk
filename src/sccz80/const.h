/* constant.c */
extern int constant(LVALUE *lval);
extern int fnumber(long *val);
extern int searchdub(char *num);
extern int number(long *val);
extern int hex(char c);
extern void address(SYMBOL *ptr);
extern int pstr(long *val);
extern int tstr(long *val);
extern int storeq(int length, unsigned char *queue,long *val);
extern int qstr(long *val);
extern void stowlit(int value, int size);
extern char litchar(void);
extern void size_of(LVALUE *lval);
