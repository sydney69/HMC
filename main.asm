INCLUDE "acornconstants.asm"
INCLUDE "macros.asm"

ORG $2000
 

.start
	;title screen
	;mode 2
	;load screen
	;play music - doop doopy doop doop, doopy doopy doop doop
	;wait until space pressed
	
	jsr setup_256_screen
	jsr cyan_background
	
	.loop
		jsr vsync
		
		;move pig
		jsr checkkeys		
		;collision check 
			;pig hits chicken
			;pig hits chick
			;pig hits egg
		;move chicken
		;move chicks
			
		
		
		PLOTSPRITE chicken
		;chick plot loop
			PLOTSPRITE chick
		;loop back to chicks
		;PLOTSPRITE egg
		PLOTSPRITE pig
		
		
	jmp loop	
rts


INCLUDE "keyboard.asm"
INCLUDE "screen.asm"
INCLUDE "plotsprite.asm"


.GameSprites
	INCBIN "sprites.bin"
.pig
	equb 0 			; sprite number
.pigx	
	equb 20			; x co-ordinate
.pigy
	equb 128		; y co-ordinate
.pig_h_count 
	equb 0 			; horizontal count
.pig_active
	equb 0			; pig active
	
.chicken
	equb 2,40,200,0 ; id of sprite, X nd Y Pos,horizontal count
.chick
	equb 5,34,200,0 ; id of sprite, X nd Y Pos,horizontal count


;.step
;	equb 1

.end
SAVE "MAIN",start,end
