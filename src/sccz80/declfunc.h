/* declfunc.c */

extern int AddNewFunc(char *sname, int type, enum storage_type storage, char zfar, char sign, TAG_SYMBOL *otag, enum ident_type ident, int32_t *addr, int decl_only);
extern void newfunc(void);
extern int CheckANSI(void);
extern SYMBOL *getarg(int typ, enum ident_type ident, TAG_SYMBOL *otag, int deftype, SYMBOL *prevarg, char issigned, char zfar, char proto);
extern void check_trailing_modifiers(SYMBOL *currfn);
