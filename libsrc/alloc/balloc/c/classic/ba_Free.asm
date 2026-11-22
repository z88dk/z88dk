
MODULE  ba_Free
SECTION  code_alloc_balloc
PUBLIC   ba_Free
PUBLIC   _ba_Free
EXTERN   balloc_free


defc ba_Free = balloc_free
defc _ba_Free = balloc_free

