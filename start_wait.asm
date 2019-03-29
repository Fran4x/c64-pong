var_start:	.fill 1,0
	.var start_game = var_start
start_text:
	.text "press h to start"
ins_text:
	.text "  keys: w a o l   "
	


wait_for_key:
	sei //deactivate system interrupts

        lda #%11111111 // CIA#1
        sta $dc02             

        lda #%00000000 // CIA#2
        sta $dc03            

        lda #%11110111
        sta $dc00



	ldy #16		//length of text
load_start_msg:
	dey
	php			//push status registers onto the stack

	lda start_text,y 	//this loop transfers the contents of 
	sta $07A4,y		//the start_text text into the screen ram
	
	plp			//pull status registers, in order to get whether dey
				//was equal to zero
	bne load_start_msg

	
            
repeat_2:
	lda $dc01
        and #%00100000
        bne repeat_2 // wait for key "H"
	
	lda #1
	sta var_start

	ldy #16		//length of text
	jsr load_ins_msg
	
        cli	// set interrupts
	rts	// return


	
load_ins_msg: //see load_start_msg above
	dey
	php
	
	lda ins_text,y
	sta $07A4,y
	
	plp
	bne load_ins_msg
	rts
