\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\			keyboard input
\\\\\\\\	check keys and adjust pig x/y coordinates
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
.checkkeys
	;key pressed = 'x', then id = 1,if x<58 then x=x+1
	LDX #&bd
	JSR inkey
	BEQ xnotpressed
	
	;xpressed code in here
	lda #1
	sta pig
	lda pig+1
	cmp #58
	beq xnotpressed
	inc pig+3
	lda pig+3
	ror A
	bcs xnotpressed
	inc pig+1

	.xnotpressed
	;key pressed = 'z', then id = 0,if x>0 then x=x-1
	LDX #&9e
	JSR inkey
	BEQ znotpressed
	
	;zpressed code in here
	lda #0
	sta pig
	lda pig+1
	beq znotpressed ;x=0
	dec pig+3
	lda pig+3	
	ror A
	bcs znotpressed
	dec pig+1
	
		
	.znotpressed
	;key pressed = '*' , then id doesn't change, if y>0 then y=y-1
	LDX #&b7
	JSR inkey
	BEQ starnotpressed
	
	;starpressed code in here
	lda pig+2
	beq starnotpressed
	dec pig+2
	
			
	.starnotpressed
	;key pressed = '?' , then id doesn't change, if y<215 then y=y+1
	LDX #&97
	JSR inkey
	BEQ qmnotpressed
		
	;qmpressed code in here
	lda pig+2
	cmp #215
	beq qmnotpressed
	inc pig+2
	
	
	.qmnotpressed
rts		
	



\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\						inkey
\\\\\\\\	;use osbyte to get keyboard input
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.inkey							
	PHA
	TYA
	PHA
	LDY #&ff
	LDA #&81
	JSR osbyte
	PLA
	TAY
	PLA
	CPX #&00
RTS
