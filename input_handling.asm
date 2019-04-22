
handle_input:
	.var pra = $dc00 //CIA#1 Port Register A
	.var prb = $dc01 //CIA#1 Port Register B
	.var ddra = $dc02 // CIA#1 (Data Direction Register A)
	.var ddrb = $dc03 // CIA#1 (Data Direction Register B)

	lda #$FF
	sta ddra // set data register a to output

	lda #$00
	sta ddrb // set data register b to input

	///keyboard matrix scan

	jsr check_up_keys //check for up key ('w' and 'o' combinations)
	jsr check_down_keys //check for down key ('s' and 'l') combinations
	rts

check_down_keys:	
        lda #%11011101
	sta pra // select third keyboard row


	
	lda prb // load column info
	and #%00100100 //check if 's' and 'l' is pressed
	beq try_move_down_both

	lda prb // load column info
	and #%00000100 //check if 's' is pressed
	beq try_move_down_r

	lda prb // load column info
	and #%00100000 //check if 'l' is pressed
	beq try_move_down_l
	rts


check_up_keys:
	lda #%11101101
	sta pra // select second and fifth keyboard rows



	lda prb // load column info
	and #%01000010 // check if 'w' and 'o'  was pressed
	beq try_move_up_both

	lda prb // load column info
	and #%00000010 // check if 'w' was pressed
	beq try_move_up_l //l is for left

	lda prb // load column info
	and #%01000000 // check if 'o' was pressed
	beq try_move_up_r
	rts
	
try_move_up_r: //try to move, if no border collision
	lda $d001
	cmp #$33
	bcs move_up_r // if position >= $33, then move
	rts

try_move_up_both:

	jsr try_move_up_r
	jsr try_move_up_l
	rts

try_move_up_l:
	lda $d003
	cmp #$33
	bcs move_up_l // if position >= $33, then move
	rts
	
move_up_r:
	dec $d001 //decrease sprite 1 y-coord
	dec $d001
	dec $d001
	rts

move_up_l:
	dec $d003 //decrease sprite 1 y-coord
	dec $d003
	dec $d003
	rts

try_move_down_r:
	lda #$cf
	cmp $d001
	bcs move_down_r // if position <= $cf, branch
	rts

try_move_down_l:
	lda #$cf
	cmp $d003
	bcs move_down_l // if position <= $cf, branch
	rts

move_down_r:
	inc $d001 //decrease sprite 1 y-coord
	inc $d001
	inc $d001
	rts
try_move_down_both:
	jsr try_move_down_r
	jsr try_move_down_l
	rts

move_down_l:
	inc $d003 //decrease sprite 1 y-coord
	inc $d003
	inc $d003
	rts


