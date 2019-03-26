var_start:	.fill 1,0
	.var start_game = var_start
	


wait_for_key:
	sei //deactivate system interrupts

        lda #%11111111 // CIA#1
        sta $dc02             

        lda #%00000000 // CIA#2
        sta $dc03            

        lda #%11110111
        sta $dc00
            
repeat_2:
	lda $dc01
        and #%00100000
        bne repeat_2 // wait for key "H"
	
	lda #1
	sta var_start
	
        cli	// set interrupts
	rts	// return
