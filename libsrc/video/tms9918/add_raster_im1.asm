
		SECTION		code_video_vdp
		PUBLIC		add_raster_int
		PUBLIC		_add_raster_int

		EXTERN		im1_install_isr

		defc		add_raster_int = im1_install_isr
		defc		_add_raster_int = im1_install_isr
