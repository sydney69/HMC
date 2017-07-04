INCLUDE "acornconstants.asm"
INCLUDE "macros.asm"

ORG $2000
 

.start
	jsr setup_256_screen
	jsr cyan_background
	
	.loop
		jsr vsync
		
		PLOTSPRITE pig
		
;		lda #<pig
;		sta $70
;		lda #>pig
;		sta $71
;		jsr PlotSprite
		jsr checkkeys
		
		
		
		
	jmp loop	
rts

INCLUDE "keyboard.asm"
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
