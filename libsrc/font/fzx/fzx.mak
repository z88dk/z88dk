FZX_GLOBS := "font/fzx/c/sccz80/*.asm" "font/fzx/z80/*.asm" "font/fzx/fonts/**/*.asm" "font/fzx/zx/z80/*.asm"
FZX_GLOBS_ex := font/fzx/c/sccz80/*.asm font/fzx/z80/*.asm font/fzx/fonts/*/*/*.asm font/fzx/fonts/*/*.asm font/fzx/zx/z80/*.asm

FZX_TARGETS := font/fzx/obj/newlib-z80-font-fzx font/fzx/obj/newlib-z80n-font-fzx 


OBJS += $(FZX_TARGETS)
CLEAN += fzx-clean

fzx: $(FZX_TARGETS)

.PHONY: fzx fzx-clean

$(eval $(call buildnew,font/fzx,z80,-mz80 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,r2ka,-mr2ka -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,r4k,-mr4k -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,z80n,-mz80n -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,ixiy,-mz80 -IXIY -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,8080,-m8080 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,8085,-m8085 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,gbz80,-mgbz80 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,z180,-mz180 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,ez80_z80,-mez80_z80 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,font/fzx,kc160,-mkc160 -I$(Z88DK_LIBSRC),$(FZX_GLOBS),$(FZX_GLOBS_ex)))


fzx-clean:
	$(RM) -fr font/fzx/obj
