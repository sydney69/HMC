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
		jsr rand				;get random number in Accumilator
		cmp #3				
		bcs chickendoesntturn	;if random no is 4 or less turn - 256/4 = every 64 frames the chicken will turn   
			sta chicken_direction
		.chickendoesntturn
		
		lda chicken_direction
		bne not_moving_up
			;moving up
			lda chickeny
			cmp #2
			bne chicken_not_at_top
				;chicken at top
				inc chicken_direction 	;turn right
				jmp not_moving_up
			.chicken_not_at_top
			dec chickeny
			jmp finished_chicken
	
		.not_moving_up
		cmp #1
		bne not_moving_right
			;moving right
			lda chickenx
			cmp #59
			bne chicken_not_at_right
				;chicken at right
				inc chicken_direction	;turn down
				jmp not_moving_right
			.chicken_not_at_right
			inc chickenx
			jmp finished_chicken
			
		.not_moving_right
		cmp #2
		bne not_moving_down
			;moving down
			lda chickeny
			cmp #240
			bne chicken_not_at_bottom
				;chicken at bottom
				inc chicken_direction		; turn left
				jmp not_moving_down
			.chicken_not_at_bottom
			inc chickeny
			jmp finished_chicken
			
		.not_moving_down
			;moving left
			lda chickenx
			cmp #0
			bne chicken_not_at_left
				inc chicken_direction		;turn up
				jmp finished_chicken
			.chicken_not_at_left
			dec chickenx
			
			
			
		 .finished_chicken
			
		
		;move chicks
			
		
		
		PLOTSPRITE chicken
		;chick plot loop
			PLOTSPRITE chick
		;loop back to chicks
		PLOTSPRITE egg
		PLOTSPRITE pig
		
		
	jmp loop	
rts


INCLUDE "keyboard.asm"
INCLUDE "screen.asm"
INCLUDE "plotsprite.asm"

.rand
	LDA seed
	ASL A
	ASL A
	CLC
	ADC seed
	CLC
	ADC #&45
	STA seed
RTS



.GameSprites
	INCBIN "sprites.bin"
	
.pig
	equb 0 			; sprite number - 0 facing left, 1 facing right
.pigx	
	equb 20			; x co-ordinate
.pigy
	equb 128		; y co-ordinate
.pig_h_count 
	equb 0 			; horizontal count
.pig_active
	equb 0			; pig active
	
.chicken
	equb 2			; sprite number - 2 facing left, 3 facing right
.chickenx	
	equb 40			; x co-ordinate
.chickeny 
	equb 200		; y co-ordinate
.chicken_h_count 
	equb 0			; horizontal count
.chicken_direction 
	equb 0 			; direction of movement - 0 up,1 right,2 down,3 left
.chicken_active
	equb 0			; chicken active


	
.chick
	equb 5,34,200,0 ; id of sprite, X nd Y Pos,horizontal count
.egg
	equb 6,20,64	; id of sprite, X nd Y Pos

.seed
	equb 3			; seed for random number generator
.end
SAVE "MAIN",start,end
