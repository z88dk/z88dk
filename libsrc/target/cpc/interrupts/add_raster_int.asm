
		SECTION		code_clib
		PUBLIC		add_raster_int
		PUBLIC		_add_raster_int

		EXTERN		cpc_add_vsync_isr

		defc		add_raster_int = cpc_add_vsync_isr
		defc		_add_raster_int = cpc_add_vsync_isr
