
move_ball:



	jsr vertical_movement
	jsr horizontal_movement

	

	rts

horizontal_movement:
	lda dir_right //check if going right
	bne move_ball_right //if not false (zero), move right
	beq move_ball_left //if false, move left
	rts

vertical_movement:
	lda dir_up //check if going up
	beq move_ball_down //if not false, move down
	bne move_ball_up //if false, move up
	rts
	
move_ball_right: //move right, taking into account 9th position bit stored in spr9th
	lda spr2_x
	clc
	adc #1
	sta spr2_x

	lda #0
	adc #0 //if carry flag on previous operation set, result is 1

	asl //arithmetic shift left
	asl

	ora spr9th //if 1, change spr9th value
	sta spr9th
	
	rts

move_ball_left:

	dec spr2_x
	lda spr9th


	lsr
	lsr

	and #%00000001
		

	adc spr2_x

	beq set_spr2x_to_255

	
	
	rts
	
move_ball_up:
	dec spr2_y //decrease since y-coords are inverted
	rts
	
move_ball_down:
	inc spr2_y //increase y-value because of inverted screen coords
	rts

set_spr2x_to_255:	
	lda #255
	sta spr2_x

	lda #%11111011
	and spr9th
	sta spr9th
	rts
