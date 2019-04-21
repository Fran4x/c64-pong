/* This file handles collision detection. It
does NOT work in the following circumstances:
Sprites very big (Should not happen)
Sprites very close to x=255
*/
#import "data_exchange.asm"

	.var spr9th = $d010 //00000000
	.var spr0_x = $d000 //spr0 is right paddle
	.var spr0_y = $d001
	.var spr1_x = $d002 //spr1 is left
	.var spr1_y = $d003
	.var spr2_x = $d004 //spr2 is ball
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
	
	
	jsr clear_vars //set all variable to 0
	jsr detect_ball_lpad //jump to subroutine to detect collision between ball and left paddle
	lda r1 // load result into A register
	and #%00000010 // isolate 2nd bit
	sta r2 // store A register into r2
	lda collisions // load collisions variable into A register
	ora r2 // bitwise OR in order to mark new collision as on without affecting other bits
	sta collisions //sets bit in collision if necessary
	
	
	jsr clear_vars //set all variable to 0
	sta x92 // set x92 to 0
	jsr detect_ball_rpad //jump to subroutine to detect collision between ball and right paddle
	lda r1 // load result into A register
	and #%00000001 // isolate 1st bit
	sta r2 // store A register into r2
	lda collisions // load collisions variable into A register
	ora r2 // bitwise OR in order to mark new collision as on without affecting other bits
	sta collisions //sets bit in collision if necessary

	jsr clear_vars //set all variable to 0
	jsr detect_ball_upper_border // jump to subroutine to detect collision between ball and upper border
	lda r1 // load result into A register
	and #%00000100 // isolate 3rd bit
	sta r2 // store A register into r2
	lda collisions // load collisions variable into A register
	ora r2 // bitwise OR in order to mark new collision as on without affecting other bits
	sta collisions //sets bit in collision if necessary
	
	jsr clear_vars //set all variable to 0
	jsr detect_ball_lower_border // jump to subroutine to detect collision between ball and lower border
	lda r1 // load result into A register
	and #%00001000 // isolate 4th bit
	sta r2 // store A register into r2
	lda collisions // load collisions variable into A register
	ora r2 // bitwise OR in order to mark new collision as on without affecting other bits
	sta collisions //sets bit in collision if necessary

	jsr clear_vars //set all variable to 0
	jsr detect_ball_left_border // jump to subroutine to detect collision between ball and left border
	lda r1 // load result into A register
	and #%00100000 // isolate 6th bit
	sta r2 // store A register into r2
	lda collisions // load collisions variable into A register
	ora r2 // bitwise OR in order to mark new collision as on without affecting other bits
	sta collisions //sets bit in collision if necessary

	jsr clear_vars //set all variable to 0
	jsr detect_ball_right_border // jump to subroutine to detect collision between ball and lower border
	lda r1 // load result into A register
	and #%00010000 // isolate 5th bit
	sta r2 // store A register into r2
	lda collisions // load collisions variable into A register
	ora r2 // bitwise OR in order to mark new collision as on without affecting other bits
	sta collisions //sets bit in collision if necessary

	
	rts // returns from subroutine


detect_ball_right_border: //detects if ball has collided with the right border
	lda #%00000100
	and spr9th
	bne d_b_r_b_1 //if 9th bit is 1, branch
	rts
d_b_r_b_1:
	lda spr2_x
	cmp #$4e
	bcs d_b_r_b_2 //if $4e <= position, branch
	rts
d_b_r_b_2:
	lda #$FF
	sta r1
	rts
	
	rts
detect_ball_left_border: //detects if the ball has collided with the left border of the screen
	
	lda #%00000100
	and spr9th
	beq d_b_le_b_1 //if 9th bit of ball is 0, branch
	rts
d_b_le_b_1:
	lda #$18
	cmp spr2_x
	bcs d_b_le_b_2 // if position <= $18, branch
	rts
d_b_le_b_2:
	lda #$FF
	sta r1
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

detect_ball_lower_border:	//detects if ball has collided with lower border
	lda #00
	sta r1
	lda spr2_y
	cmp #$f3
	bcs d_b_l_b_1 // if $f3 <= position, branch
	rts
d_b_l_b_1:
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
	lda spr0_x // load x coordinate of sprite 0 into A register
	clc // clear carry flag
	adc #paddle_half_width // add half the width, to find center of object
	sta x1 // store A register into x1 variable
	lda x91 // load contents of x91 variable into A register 
	adc #$00 //add the carry of the last operation to 9th bit in case it overflowed
	sta x91 // store A register into x91 variable
	

	lda spr9th // load spr9th into A register, where the 9th bit of the sprites' x-coordinates are stored
	and #$01 //Isolate 9th bit
  	adc x91 // add x91 unto A register and store in A register
	sta x91 // store A register into x91



	lda #paddle_width // load paddle width constant into A register
	sta d1 // store A register in first dimension variable

	jsr load_ball_x // jump to subroutine that loads ball's (sprite 2) x variables

	jsr detect_dimension_collision //Jump to subroutine that detects whether there is a collision in the x dimension

	lda r1 // load collision detection result into A register
	sta r2 // load A register into r2
	
	

	lda spr0_y // load sprite 0 y coordinate into A register
	clc // clear carry flag
	adc #paddle_half_height // add paddle half height constant, to get coordinate of center of the paddle
	sta x1 // store result into x1
	

	lda #$00 // load 0 into A register
	sta x91 // store A register into x91

	lda #paddle_height // load paddle height constant into A register
	sta d1 // store A register into dimension 1 variable

	jsr load_ball_y //jump into subroutine to load variables for ball (sprite 2) y coordinates


	jsr detect_dimension_collision // detect collision in the y dimension

	lda r1 // load y dimension collision test result

	and r2 // bitwise AND with previous result, if both results were $FF, then a will contain $FF


	sta r1 // store final result into r1

	
	rts // return from subroutine

load_ball_x:
	
	lda spr2_x // load sprite 2 x coordinate into A register
	clc // clear carry flag
	adc #ball_half_width //add half width constant, in order to get center coordinate of ball
	sta x2 //store into x2 variable
	lda x92 //load x92 into A register
	adc #$00 // If there was an overflow, add 1 to A register
	sta x92 // Store A register into x92

	lda spr9th // load spr9th into A register
	clc // clear carry flag
	ror // Bitwise shift right of A register
	clc // clear carry flag
	ror // bitwise shift right
	and #$01 //Isolate 9th bit of ball only
  	adc x92 // set 9th bit of sprite 2 in x92 variable
	sta x92 // store A in x92

	lda #ball_width // load ball width constant into A register
	sta d2 // store A register into dimension 2 variable
	
	rts

detect_dimension_collision: // finds if 9th bit is the same, if so continue
//TODO: Make collision work even if 9th bit is different on each sprite
	lda x91 // load x91 into A register
	cmp x92 // compare x92 with A register
	beq detect_dimension_collision_2 //if first sprite 9th bit is equal to second sprite 9th bit, jump to label
	rts
	
detect_dimension_collision_2:	//finds whether it is possible for the objects to collide in the given dimension, must be given paramenters, returns $FF in A register if true
	lda #$00 // load 0 into A
	sta r1 //load preliminary result
	
	jsr ensure_dimension // jump to subroutine to make sure the first dimension is greater than the second
	sec // set carry flag
	lda x1 // load x1 into A register
	sbc x2 //subtract x2 from x1, getting distance between points
	
	clc // clear carry flag
	sta tmp // store A register into tmp
	adc tmp // multiply a by 2, by adding it unto itself
	bcc d_d_1 // if no overflow was found, jump to label
	rts //carry was set, number too large to possibly be close enough, as there was an overflow
	
d_d_1:	tay // transfer A register into Y register
	lda d1 // load d1 into A register
	clc // clear carry flag
	adc d2 //add both dimension sizes together
	
	sty tmp //store distance*2 in tmp
 
	cmp tmp // compare distance*2 with width1+width2
	bcs d_d_2 //if distance*2 < width1+width2, jump to label
	rts // return from subroutine
	
d_d_2:	lda #$FF // load 255 into A register
	sta r1 // store A register into r1, meaning the dimension does collide
	rts //return from subroutine


load_ball_y:
	lda spr2_y
	adc #ball_half_height
	sta x2

	lda #$00
	sta x92

	lda #ball_height
	sta d2

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
