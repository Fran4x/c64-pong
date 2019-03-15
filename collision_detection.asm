	.var spr9th = $d010
	.var spr0_x = $d000
	.var spr0_y = $d001
	.var spr1_x = $d002
	.var spr1_y = $d003
	.var spr2_x = $d004
	.var spr2_y = $d005
	

	.var paddle_height = 21*2 //paddle height is multiplied by 2
	.var paddle_width = 6
	.var ball_height = 7
	.var ball_width = 10

coll_func_vars: .fill 9, 0
	.var x1 = coll_func_vars //position of segment 1
	.var x2 = coll_func_vars + 1 //pos of segment 2
	.var x91 = coll_func_vars + 2 //9th bit of pos segment 1
	.var x92 = coll_func_vars + 3 //9th bit of pos segment 2
	.var d1 = coll_func_vars + 4 //dimension 1
	.var d2 = coll_func_vars + 5 //dimension 2
	.var r1 = coll_func_vars + 6 //result
	.var r2 = coll_func_vars + 7 //result 2
	.var tmp = coll_func_vars + 8 //working variable
	
detect_collisions:
	jsr detect_ball_rpad
	
	rts

detect_ball_rpad:	//checks whether a collision exists between the ball and right paddle, sets r1 to $FF if true
	lda spr0_x
	sta x1
	lda spr2_x
	sta x2

	lda spr9th
	and #$01 //Isolate 9th bit
	sta x91

	lda spr9th
	clc
	ror
	clc
	ror
	and #$01 //Isolate 9th bit of ball only
	sta x92

	lda #paddle_width
	sta d1
	lda #ball_width
	sta d2
	
	jsr detect_dimension_collision //Detect if x-coordinate collides

	lda r1
	sta r2
	
	

	lda spr0_y
	sta x1
	lda spr2_y
	sta x2

	lda #$00
	sta x91
	sta x92

	lda #paddle_height
	sta d1
	lda #ball_height
	sta d2

	jsr detect_dimension_collision

	lda r1

	cmp #$FF

	sta r1

	//TODO: Fix collisions
	
	rts

detect_dimension_collision:	//finds whether it is possible for the objects to collide in the given dimension, must be given paramenters, returns $FF in A register if true
	lda #$00
	sta r1 //load preliminary result
	
	jsr ensure_dimension
	sec
	lda x1
	sbc x2 //subtract x2 from x1, getting distance between points
	
	clc
	sta tmp
	adc tmp // multiply a by 2
	bcc d_d_1 //continue
	rts //carry was set, number too large to possibly be close enough
	
d_d_1:	tay
	lda d1
	clc
	adc d2 //add both dimension sizes
	
	sty tmp //store distance*2 in tmp

	cmp tmp
	bcs d_d_2 //distance*2 < width1+width2, return true
	rts
	
d_d_2:	lda #$FF
	sta r1
	rts

ensure_dimension:	//Makes sure the first dimension is greater than the second
	
	
	clc
	lda x92
	cmp x91 //Check if x92>=x91
	beq en_d_2 //9th bit equal, check rest of bits
	bcs swap_d //x92>x91, swap numbers
	rts //x91 greater, end
en_d_2:	
	clc
	lda x2
	cmp x1 //check if x2>=x1
	bcs swap_d //x2>x1, swap numbers
	rts

swap_d:
	lda x1
	ldx x2
	sta x2
	txa
	sta x1 //swap x1 and x2
	
	lda x91
	ldx x92
	sta x92
	txa
	sta x91 //swap x91 and x92

	lda d1
	ldx d2
	sta d2
	txa
	sta d1 //swap d1 and d2
	
	clc
	
	rts
	





