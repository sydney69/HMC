\\ Sprite routine from retrosoftware.com.uk

;Main Sprite plot routine, in mode 1
 
; MEMORY USED
; &72 - &7A  directly
; &9F in Times8 Macro
                                                   
;on entry &70,&71 point to a sprite object structure.
; This is the properties on the sprite, such as which one, x,y etc.
; it does not contain actual sprtie data, that is worked out from the
; sprite id Structure is
 
;offset   meaning
;00       SpriteID ; so supports 128 different sprites (0-127)
;01       X Pos    ; it's only 128 as we use this value * 2 to index into the sprite
;02       Y Pos    ; data structure pointer table
                                    
; Sprite ID's. These index into a look up table of  memory locations
; that points to the Sprite graphic data structure.
 
;Sprite Graphic Structure 
; 
 
	;offset       meaning
	;00           width
	;01           height
	;02->to end   graphic data 

	
;definitions for this file
SpriteObjectStructure = &70
SpriteGraphicStructure = &72
XOrd = &74
YOrd = &75
Width = &76
Height = &77
YScreenAddress = &78 ; and 79
SpritePixel = &7A    
XStartOffset = &7B ; remember X offset start, which needs to be the same at start of every new column
ScreenStartHighByte = &40
 

 
.PlotSprite
	; work out screen address that sprite starts at from xy ords
	ldy #0
	sty YScreenAddress ; just ensure is 0
	lda #ScreenStartHighByte
	sta YScreenAddress+1
	lda(SpriteObjectStructure ),Y  ; sprite ID
	asl a; get start of sprite graphics, this gets the address of it
	tax ; so got the index into the data
	clc
	lda GameSprites,x
	adc #<GameSprites
	sta SpriteGraphicStructure
	inx 
	lda GameSprites,x   
	adc #>GameSprites
	sta SpriteGraphicStructure+1            ; so now point to sprite graphic data  
	lda (SpriteGraphicStructure),Y 			; width
	sta Width
	iny
	lda(SpriteObjectStructure ),Y   		; X
	sta XOrd
	lda(SpriteGraphicStructure),Y   		; height 
	sta Height
	iny
	lda(SpriteObjectStructure),Y  			; YOrd   
	sec
	sbc #1
	clc
	adc Height  							; but only to nearest character row start
	sta YOrd
	and #7     								; put low order bits in X  for index addressing
	tax     
	sta XStartOffset 						; preserve this for use later
	lda YOrd      							; then store the other bits 3-7 in YOrd to get screen address of nearest character start row
	and #248
	sta YOrd
	jsr ScreenStartAddress                 
	
	; now we've got the screen start address, and address of alien, lets plot it
	lda YScreenAddress 						; put address in code below
	sta ScreenPixelAddress+1      
	lda YScreenAddress+1        
	sta ScreenPixelAddress+2     
	clc
	lda SpriteGraphicStructure     			; move to start of actual graphics data
	adc #2 									; to move past width and height
	sta SpritePixelAddress+1
	lda SpriteGraphicStructure+1
	adc #0
	sta SpritePixelAddress+2
	
	;ok the main plot bit
   
	.PlotXLoop
		ldy Height 
		dey  
		.PlotLoop   
		.SpritePixelAddress
		lda &FFFF,Y     ;dummy address, will be filled in by code
		.ScreenPixelAddress
		sta &FFFF,X     ; dummy address, will be filled in by code
		; are we at a boundary?
		dex                  
		bpl NotAtRowBoundary   				;   no, so carry on
			;yes we moved to another character row, so we really want this to be the start of next screen row
			sec                     ; we do this by adding &200 to value to get to next row
			
;=============================================================================================
			\\ removed by sydney as we simply add &02 to the high byte on a 256 pixel screen		
			;lda ScreenPixelAddress+1
			;sbc #&80
			;sta ScreenPixelAddress+1
;===============================================================================================			
			lda ScreenPixelAddress+2
			sbc #2
			sta ScreenPixelAddress+2   
			ldx #7 ; reset X to 7 (bottom of this character row)
		.NotAtRowBoundary
		dey
		bpl PlotLoop    ; have we finished a full column, go to plot loop if not
		dec Width
		beq EndPlotSprite   ; no more to plot, exit routine
		; 	move to next column
		clc
		lda SpritePixelAddress+1
		adc Height
		sta SpritePixelAddress+1
		lda SpritePixelAddress+2
		adc #0  
		sta SpritePixelAddress+2      
		lda YScreenAddress
		clc
		adc #8
		sta YScreenAddress
		sta ScreenPixelAddress+1  
		lda YScreenAddress+1
		adc #0                     
		sta YScreenAddress+1
		sta ScreenPixelAddress+2 
		ldx XStartOffset  
	jmp PlotXLoop ;never zero so always branches
.EndPlotSprite
 
rts

	
 
.ScreenStartAddress
	; calculates the screen start address for a mode 1 or 2 screen given an X,Y address
	; if X or Y go beyond screen limits then returns 0 else the address
	; on entry &74=X, &75=Y, returns result in &78,&79
	
	; We use a 640 multiplication look up table
	; to speed things up. The Y ord is actually in pixels but due to the way the
	; screen is made up by the 6850 we only need the multiplication for character
	; rows (every 9th row, i.e. 8 rows per character)
	; so divide Y by 8 to get character rows  but as there stored as two byte per entry in multiplication table
	; each we only need to divide by 4 to get our index into the table
	
	lda YOrd
	and #248   ; FIRST REMOVE THE 0 TO 7 VALUE that we don't need to resolve, as screen
				; goes down from 0 to 7 ok, just for rest of bits we need to calc 640
	lsr a
	lsr a
	lsr a						\\ added by sydney
	tay
	lda lookup512,Y				\\ changed by sydney	
	clc
;===============================================================================	
	\\removed by sydney as the low byte in a 256 pixel screen is ALWAYS 0
	;adc YScreenAddress ; lo byte value of the 640 look up
	;sta YScreenAddress
	;iny
	;lda lookup640,Y  ;accumulator now has hi byte
;===============================================================================
	adc YScreenAddress+1
	sta YScreenAddress+1  ; so should have base row for Y
	; now we have the character row that the sprite is going to plot at
	; we need to refine this to a actual row. all we need do is add on
	; the lower 3 bits of the Y address that we shifted out with lsr a few lines ago
	; and due to the way the address is, we will never get a carry so only a normal
	; 8 bit addition
	; no need to clc as still clear from earlier
	lda YOrd
	and #7 ; remove unwanted high order bits leaving us with just the lower 3 bits
	clc
	adc YScreenAddress  ; don't need to add n carry to hi byteas will never occur as
	sta YScreenAddress  ; the max of 7 added to the start of a character row will never go ovr 255
	; right we've now got the Y component of the address, now we've to add in the
	; X component. For every X pixel we need to add 8 bytes, for this we won't use
	; a look of table as it's quite easy and quickish to multiply by 8. 
	; It is true that it would be quicker with a look uo table but it would take
	; about 320 bytes for only a small gain
	TIMES8 XOrd, YScreenAddress
	rts
	; end ScreenStartAddress
 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

 
\\512 times table for plot address routine			
.lookup512
	EQUB &00,$02,&04,&06,&08,&0A,&0C,&0E
	EQUB &10,$12,&14,&16,&18,&1A,&1C,&1E
	EQUB &20,&22,&24,&26,&28,&2A,&2C,&2E
	EQUB &30,$32,&34,&36,&38,&3A,&3C,&3E
