; open modes

defc ENV_OPEN_EXIST       = 0x00  ; open if exists else error
defc ENV_OPEN_NOEXIST     = 0x04  ; create if no exist else error
defc ENV_OPEN_CREAT       = 0x08  ; open if exists or create
defc ENV_OPEN_CREAT_TRUNC = 0x0c  ; create or replace existing file

; open rw

defc ENV_OPEN_W = 0x01
defc ENV_OPEN_R = 0x02
