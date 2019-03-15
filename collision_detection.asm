/* This file handles collision detection. It
does NOT work in the following circumstances:
Sprites very big (Should not happen)
Sprites very close to x=255
*/
#import "data_exchange.asm"

	.var spr9th = $d010
	.var spr0_x = $d000
	.var spr0_y = $d001
	.var spr1_x = $d002
	.var spr1_y = $d003
	.var spr2_x = $d004
	.var spr2_y = $d005
	
	
	.var paddle_height = 21*2 //paddle height is multiplied by 2
	.var paddle_half_height = 21
	.var paddle_width = 6
	.var paddle_half_width = 3
	.var ball_height = 7
	.var ball_half_height = 3
	.var ball_width = 10
	.var ball_half_width = 5

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
	
	
	jsr clear_vars
	jsr detect_ball_lpad
	lda r1
	and #%00000010
	sta r2
	lda collisions
	ora r2
	sta collisions //sets bit in collision if necessary
	
	
	jsr clear_vars
	sta x92
	jsr detect_ball_rpad
	lda r1
	and #%00000001
	sta r2
	lda collisions
	ora r2
	sta collisions //sets bit in collision if necessary

	jsr clear_vars
	jsr detect_ball_upper_border
	lda r1
	and #%00000100
	sta r2
	lda collisions
	ora r2
	sta collisions
	
	
	rts


detect_ball_upper_border: //detects if the ball has collided with the upper border
	lda #00
	sta r1
	lda #$33
	cmp spr2_y
	bcs d_b_u_b_1 // if position <= $33, branch
	rts
d_b_u_b_1:
	lda #$FF
	sta r1
	rts

detect_ball_lpad:
	
	lda spr1_x
	clc
	adc #paddle_half_width // add half the width, to find center of object
	sta x1
	lda x91
	adc #$00 //add the carry of the last operation to 9th bit in case it overflowed
	sta x91
	

	lda spr9th
	clc
	ror
	and #$01 //Isolate 9th bit
	clc //need to clear, as ror might have set carry
  	adc x91 
	sta x91



	lda #paddle_width
	sta d1

	jsr load_ball_x

	
	jsr detect_dimension_collision //Detect if x-coordinate collides

	lda r1
	sta r2
	
	

	lda spr1_y
	clc
	adc #paddle_half_height
	sta x1
	

	lda #$00
	sta x91

	lda #paddle_height
	sta d1

	jsr load_ball_y

	
	jsr detect_dimension_collision

	lda r1

	and r2 // if both results were $FF, then a will contain $FF
	

	sta r1

		
	rts
	
detect_ball_rpad:	//checks whether a collision exists between the ball and right paddle, sets r1 to $FF if true
	lda spr0_x
	clc
	adc #paddle_half_width // add half the width, to find center of object
	sta x1
	lda x91
	adc #$00 //add the carry of the last operation to 9th bit in case it overflowed
	sta x91
	

	lda spr9th
	and #$01 //Isolate 9th bit
  	adc x91
	sta x91



	lda #paddle_width
	sta d1

	jsr load_ball_x

	jsr detect_dimension_collision //Detect if x-coordinate collides

	lda r1
	sta r2
	
	

	lda spr0_y
	clc
	adc #paddle_half_height
	sta x1
	

	lda #$00
	sta x91

	lda #paddle_height
	sta d1

	jsr load_ball_y


	jsr detect_dimension_collision

	lda r1

	and r2 // if both results were $FF, then a will contain $FF


	sta r1

	
	rts


load_ball_x:
	
	lda spr2_x
	clc
	adc #ball_half_width
	sta x2
	lda x92
	adc #$00
	sta x92

	lda spr9th
	clc
	ror
	clc
	ror
	and #$01 //Isolate 9th bit of ball only
  	adc x92
	sta x92

	lda #ball_width
	sta d2
	
	rts

load_ball_y:
	lda spr2_y
	adc #ball_half_height
	sta x2

	lda #$00
	sta x92

	lda #ball_height
	sta d2

	rts
	

detect_dimension_collision: // finds if 9th bit is the same, if so continue
//TODO: Make collision work even if 9th bit is different on each sprite
	lda x91
	cmp x92
	beq detect_dimension_collision_2
	rts
	
detect_dimension_collision_2:	//finds whether it is possible for the objects to collide in the given dimension, must be given paramenters, returns $FF in A register if true
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
	lda x1
	sec
	sbc x2
	lda x91
	sbc x92
	bcc swap_d //x1<x2, swap numbers
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

clear_vars:
	lda #$00
	sta x1
	sta x2
	sta x91
	sta x92
	sta d1
	sta d2
	sta r1
	sta r2
	rts
