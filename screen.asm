.setup_256_screen
	MODE 2
	
	\\ custom screenmode 64bytes (256 mode 1 pixels,128 mode 2 pixels) wide
	lda #1 
	sta crtcr
	lda #64
	sta crtcd
	
	\\ centre screen
	lda #2
	sta crtcr
	lda #90
	sta crtcd
	
	\\ change screen start address to &4000
	lda #12
	sta crtcr
	lda #&08
	sta crtcd
	
	lda #13
	sta crtcr
	lda #&00
	sta crtcd
rts