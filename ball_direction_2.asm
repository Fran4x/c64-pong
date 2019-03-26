#importonce
	
var_up:	.fill 1,0
	.var dir_up = var_up

var_right: .fill 1,0
	.var dir_right = var_right

var_ball_spawn_dir: .fill 1,0
	.var dir_ball_spawn = var_ball_spawn_dir
	

set_directions:
	jsr check_right
	jsr check_left
	jsr check_border_right
	jsr check_border_left
	jsr check_border_up
	jsr check_border_down

	jsr clear_collisions

	rts

check_border_up:
	lda #%00000100
	and collisions

	lsr
	lsr

	bne go_down
	rts

go_down:
	lda #0
	sta var_up
	rts

check_border_down:
	lda #%00001000
	and collisions
	
	lsr
	lsr
	lsr

	bne go_up
	rts

go_up:
	lda #1
	sta var_up
	rts

check_border_left:
	lda #%00100000
	and collisions

	lsr
	lsr
	lsr
	lsr
	lsr

	bne score_left
	
	rts

score_left:
	inc $043c
	jsr reset_ball
	rts

check_border_right:
	lda #%00010000
	and collisions

	lsr
	lsr
	lsr
	lsr

	bne score_right

	rts

score_right:
	inc $043a
	jsr reset_ball
	rts
	

check_right:	
	///right paddle collision

	lda #%00000001
	and collisions

	bne go_left
	
	rts

go_left:
	lda #0
	sta dir_right
	rts

check_left:

	///left paddle collision

	lda #%00000010
	and collisions

	bne go_right
	rts

go_right:
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
	
clear_collisions:
	lda #0
	sta collision_data
	rts
