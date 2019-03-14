

		*=$2000 "Paddle"
	.import binary "paddle.spr", 3 //import paddle sprite, skip first 3 bytes

	
BasicUpstart2(start)

	*=$080f "Main Code"
	#import "music_player.asm"
	#import "input_handling.asm"
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


set_sprt:
	lda #$80
	sta $07f8 //sprite is $80 * $64 bytes away from address 0
	
	lda #$01
	sta $d01c //Enable multi-color mode on sprite 1
	sta $d017 //Enable y-expansion of sprite 1
	sta $d015 //enable first sprite

	lda #$30
	sta $043a // Load 0 into screen ram
	lda #$31
	sta $043c // Load 1 into screen ram

	lda #$30
	sta $d000 // x-coord
	lda #$01 
	sta $d010 // 9th bit x-coord
	lda #$80
	sta $d001 // y-coord
	rts

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


	

