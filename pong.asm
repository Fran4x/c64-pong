BasicUpstart2(start)

	*=$080f "Main Code"

	#import "input_handling.asm"
	#import "collision_detection.asm"
	#import "ball_direction_2.asm"
	#import "ball_move.asm"
	#import "delay.asm"
	#import "start_wait.asm"

	

start:	jsr $e544 //clears screen, built in sub-routine at this location

	// set colors of screen
	lda #BLACK
	sta $d021
	
	lda #BLUE
	sta $d020
	//
	
	lda collision_data

	jsr set_sprt

	jsr wait_for_key

pre_loop:
	lda start_game
	bne start_music
	
	jmp pre_loop

start_music:	
	
	jsr init_music

	jsr set_irq


loop:



	jsr delay
	jsr detect_collisions
	jsr set_directions
	jsr move_ball

	
	jmp loop






	



set_irq:
	sei // turn off irq
	
	ldy #$7f    // $7f = %01111111
        sty $dc0d   // Turn off CIAs Timer interrupts
        sty $dd0d   // Turn off CIAs Timer interrupts
        lda $dc0d   // cancel all CIA-IRQs in queue/unprocessed
        lda $dd0d   // cancel all CIA-IRQs in queue/unprocessed

	lda #$01
	sta $d01a // request rasterbeam irq
	
	lda #<irq
	ldx #>irq
	sta $314
	stx $315 //store pointer to custom irq routine

	lda #$85
	sta $d012 // set first 7 bits of raster line to generate irq at
	
	lda $d011
	and #$7f
	sta $d011 // turn off 9th bit of raster line to generate irq at
	cli // turn irq on
	rts

irq:	dec $d019 // acknowledge IRQ
	jsr play
	jsr handle_input
	jmp $ea81 // return to kernel IRQ routine


	
	//must be imported last, as they create a memory block
	#import "music_player.asm"	
	#import "sprite_config.asm"
