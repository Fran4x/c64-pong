
handle_input:
	.var pra = $dc00 //CIA#1 Port Register A
	.var prb = $dc01 //CIA#1 Port Register B
	.var ddra = $dc02 // CIA#1 (Data Direction Register A)
	.var ddrb = $dc03 // CIA#1 (Data Direction Register B)

	lda #$FF
	sta ddra // set data register a to output

	lda #$00
	sta ddrb // set data register b to input

	lda #%11111101
	sta pra // select third keyboard row
	lda prb // load column info
	and #%00000010 // check if 'w' was pressed
	beq move_up

	lda #%11111101
	sta pra // select third keyboard row
	lda prb // load column info
	and #%00100000
	beq move_down
	
	rts
	
move_up:
	lda $d001
	cmp #$33
	bcs move_up_dec // if position >= $33, then branch
	rts
	
move_up_dec:
	dec $d001 //decrease sprite 1 y-coord
	rts

move_down:
	lda #$cf
	cmp $d001
	bcs move_down_dec // if position <= $cf, branch
	rts

move_down_dec:
	inc $d001 //decrease sprite 1 y-coord
	rts
