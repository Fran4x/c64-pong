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

	*=$2000 "Paddle"
	.import binary "paddle.spr", 3 //import paddle sprite, skip first 3 bytes
