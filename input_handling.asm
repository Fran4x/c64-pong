
handle_input:
	.var pra = $dc00 //CIA#1 Port Register A
	.var prb = $dc01 //CIA#1 Port Register B
	.var ddra = $dc02 // CIA#1 (Data Direction Register A)
	.var ddrb = $dc03 // CIA#1 (Data Direction Register B)

	lda #$FF
	sta ddra // set data register a to output

	lda #$00
	sta ddrb // set data register b to input

	jsr check_up
	jsr check_down
	rts

check_s_o:

	lda #%11101101
	sta pra // select second and fifth keyboard rows

	lda prb //check 's' and 'o'
	and #%01100000
	beq move_s_o
	
check_w_l:

	lda #%11011101
	sta pra // select third keyboard row

	lda prb // load column info
	and #%00000110 //check if 'w' and 'l' is pressed
	beq move_w_l

check_down:	
        lda #%11011101
	sta pra // select third keyboard row



	lda prb // load column info
	and #%00100100 //check if 's' and 'l' is pressed
	beq move_down_2

	lda prb // load column info
	and #%00000100 //check if 's' is pressed
	beq move_down

	lda prb // load column info
	and #%00100000 //check if 'l' is pressed
	beq move_down_l
	rts

	//check up

check_up:
	lda #%11101101
	sta pra // select second and fifth keyboard rows



	lda prb // load column info
	and #%01000010 // check if 'w' and 'o'  was pressed
	beq move_up_2

	lda prb // load column info
	and #%00000010 // check if 'w' was pressed
	beq move_up_l

	lda prb // load column info
	and #%01000000 // check if 'o' was pressed
	beq move_up
	rts

	//check down
	

	
	//lda #%11011101
	//sta pra // select third keyboard row

	//lda prb // load column info
	//and #%01100000 //check if 's' and 'o' is pressed
	//beq move_up_2

move_w_l:
	jsr move_up_l
	jsr move_down
	rts
	
move_up:
	lda $d001
	cmp #$33
	bcs move_up_dec // if position >= $33, then branch
	rts

move_s_o:
	jsr move_up_dec
	jsr move_down_dec_l
	rts

move_up_2:

	jsr move_up
	jsr move_up_l
	rts

move_up_l:
	lda $d003
	cmp #$33
	bcs move_up_dec_l // if position >= $33, then branch
	rts
	
move_up_dec:
	dec $d001 //decrease sprite 1 y-coord
	dec $d001
	rts

move_up_dec_l:
	dec $d003 //decrease sprite 1 y-coord
	dec $d003
	rts

move_down:
	lda #$cf
	cmp $d001
	bcs move_down_dec // if position <= $cf, branch
	rts

move_down_l:
	lda #$cf
	cmp $d003
	bcs move_down_dec_l // if position <= $cf, branch
	rts

move_down_dec:
	inc $d001 //decrease sprite 1 y-coord
	inc $d001
	rts

move_down_dec_l:
	inc $d003 //decrease sprite 1 y-coord
	inc $d003
	rts

move_down_2:
	jsr move_down
	jsr move_down_l
	rts
