#importonce
	
var_up:	.fill 1,0
	.var dir_up = var_up

var_right: .fill 1,0
	.var dir_right = var_right
	
set_directions:
	jsr check_right
	jsr check_left
	jsr check_border_right
	jsr check_border_left
	jsr check_border_up
	jsr check_border_down

	jsr clear_collisions

	rts

check_border_up: //check if ball collided with upper border
	lda #%00000100
	and collisions

	lsr
	lsr

	bne go_down //if so, set to move down
	rts

go_down: //change var_up to false
	lda #0
	sta var_up
	rts

check_border_down: //chack if collsion with lower border
	lda #%00001000
	and collisions
	
	lsr
	lsr
	lsr

	bne go_up //if so, set to move up
	rts

go_up: //change var_up to true
	lda #1
	sta var_up
	rts

check_border_left: //check if left border collision
	lda #%00100000
	and collisions

	lsr
	lsr
	lsr
	lsr
	lsr

	bne score_left //if so, change score
	
	rts

score_left: //increase left score and reset ball
	inc $043c
	jsr reset_ball
	rts

check_border_right: //check if right border collision
	lda #%00010000
	and collisions

	lsr
	lsr
	lsr
	lsr

	bne score_right //if so, score_right

	rts

score_right: //increase score by one and reset ball
	inc $043a
	jsr reset_ball
	rts
	

check_right:	
	//check for right paddle collision

	lda #%00000001
	and collisions

	bne go_left //if so, set to move left
	
	rts

go_left: //dir_right to false
	lda #0
	sta dir_right
	rts

check_left:

	//check for left paddle collision

	lda #%00000010
	and collisions

	bne go_right
	rts

go_right: //dir_right to true
	lda #1
	sta dir_right
	rts

reset_ball: //reset ball position
	
	lda #$af //reset ball x
	sta spr2_x
	lda #$90 //reset ball y
	sta spr2_y

	lda #%11111011 //and to turn off second bit of spr9th
	and spr9th
	sta spr9th //save to spr9th

	
	lda dir_right //invert direction on point scored
	and #%00000001
	eor #%00000001
	sta dir_right

	
	rts
	
clear_collisions: //wipe collision data var
	lda #0
	sta collision_data
	rts
