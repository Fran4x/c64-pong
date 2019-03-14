



	
BasicUpstart2(start)

	*=$080f "Main Code"
	#import "music_player.asm"
	#import "input_handling.asm"
	#import "sprite_config.asm"
start:	jsr $e544 //clears screen, built in sub-routine at this location

	// Sset colors of screen
	lda #BLACK
	sta $d021

	lda #BLUE
	sta $d020
	//

	jsr init_music
	jsr set_sprt
	jsr set_irq

	
loop:	jmp loop



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

	lda $d011
	and #$7f
	sta $d011 // turn off 9th bit of raster line to generate irq at
	cli // turn irq on
	rts

irq:	dec $d019 // acknowledge IRQ
	jsr play
	jsr handle_input
	jmp $ea81 // return to kernel IRQ routine


	

