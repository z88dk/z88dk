/* decl.c */
extern int dodeclare(int storage, TAG_SYMBOL *mtag, int is_struct);
extern TAG_SYMBOL *defstruct(char *sname, int storage, int is_struct);
extern int get_ident(void);
extern int dummy_idx(int typ, TAG_SYMBOL *otag);
extern void declglb(int typ, int storage, TAG_SYMBOL *mtag, TAG_SYMBOL *otag, int is_struct, char sign, char zfar);
extern void declloc(int typ, TAG_SYMBOL *otag, char sign, char locstatic, char zfar);
extern unsigned char CalcArgValue(char type, char ident, char flags);
extern char *ExpandArgValue(unsigned char value, char *buffer, char tagidx);
extern void ptrerror(int ident);
extern int needsub(void);
extern TAG_SYMBOL *GetVarID(struct varid *var,char storage);
extern void BitFieldSwallow(void);
extern char *ExpandType(int type, char **sign, char tagidx);
extern int get_type_size(int type, TAG_SYMBOL *otag);
