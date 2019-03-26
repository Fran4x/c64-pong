delay:
		//cycles formula = 5ab+5a
	ldy#3 //a=10 (original value)
	ldx#119 //b=119
repeat:
	
	//nop //2 cyc
repeat2:
	dex //2 cyc
	//nop //2 cyc
	bne repeat2 //3 cyc
	
	dey //2 cyc
	
	bne repeat //3 cyc
	
	rts
