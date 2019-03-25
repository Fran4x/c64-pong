set_sprt:
	lda #$80
	sta $07f8 //sprite is $80 * $64 bytes away from address 0
	sta $07f9 //set sprite 1 to same sprite
	lda #$81
	sta $07fa //give sprite 2 ball sprite
	
	lda #$FF
	sta $d01c //Enable multi-color mode on all sprites
	
	lda #%00000011
	sta $d017 //Enable y-expansion of sprite 0 and 1

	lda #%00000111
	sta $d015 //enable sprites 0-2

	lda #$30
	sta $043a // Load 0 into screen ram
	lda #$30
	sta $043c // Load 1 into screen ram

	lda #$30
	sta $d000 // x-coord sprite 0
	lda #$01 
	sta $d010 // 9th bit x-coord sprite 0
	lda #$80
	sta $d001 // y-coord sprite 0
	
	
	sta $d003 // y-coord sprite 1
	lda #$3C
	sta $d002 // x-coord sprite 1
	
	lda #$af
	sta $d004 //x-coord sprite 2
	lda #$90
	sta $d005
	rts

	*=$2000 "Paddle"
	.import binary "paddle.spr", 3 //import paddle sprite, skip first 3 bytes
