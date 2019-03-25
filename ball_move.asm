
move_ball:



	jsr sub_1
	jsr sub_2

	

	rts

sub_2:
	lda dir_right
	bne move_ball_right_dd
	beq move_ball_left_dd
	rts

sub_1:
	lda dir_up
	beq move_ball_down_dd
	bne move_ball_up_dd
	rts
	
move_ball_right_dd:
	lda spr2_x
	clc
	adc #1
	sta spr2_x

	lda #0
	adc #0

	asl
	asl

	ora spr9th
	sta spr9th
	
	rts

move_ball_left_dd:

	//spr9th: 00000001/0
	//spr2_x: 00000001
	

//
	dec spr2_x
	lda spr9th //00000x00


	lsr
	lsr

	and #%00000001  //00000001/0
		

	adc spr2_x

	beq set_255

	
	
	rts
	
move_ball_up_dd:
	dec spr2_y //decrease since y-coords are inverted
	rts
	
move_ball_down_dd:
	inc spr2_y
	rts

set_255:
	lda #255
	sta spr2_x

	lda #%11111011
	and spr9th
	sta spr9th
	rts
