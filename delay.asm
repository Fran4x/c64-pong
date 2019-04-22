
	///subroutine to handle fixed time delay (busy wait)
	///times ball speed in main loop
delay:
		//cycles formula = 5ab+5a (total cycles)
	ldy#3 //a=10 (original value, but 3 is better)
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
