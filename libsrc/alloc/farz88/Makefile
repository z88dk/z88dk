
include ../../Make.config

all: $(OUTPUT_DIRECTORY)/farz88.lib


$(OUTPUT_DIRECTORY)/farz88.lib:
	@$(MAKE) -C strings
	@$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/farz88 @farz88.lst

clean:
	$(RM) *.o *~
	$(MAKE) -C strings clean
