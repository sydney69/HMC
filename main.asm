INCLUDE "acornconstants.asm"
INCLUDE "macros.asm"

ORG $2000
 

.start
	jsr setup_256_screen
	;set background to colour 6 -vdu 18,133
	lda #18
	jsr oswrch
	lda #0
	jsr oswrch
	lda #134
	jsr oswrch
	;clg
	lda #16
	jsr oswrch
	
	.loop
		jsr vsync
		lda #<pig
		sta $70
		lda #>pig
		sta $71
		jsr PlotSprite
		jsr checkkeys
		
		
		
		
	jmp loop	
rts

INCLUDE "keyboad.asm"
INCLUDE "screen.asm"
INCLUDE "plotsprite.asm"






.GameSprites
	INCBIN "sprites.bin"
.pig
	equb 0,20,128,0 ; id of sprite, X nd Y Pos,horizontal count

.step
	equb 1
	.end
SAVE "MAIN",start,end
