.var music = LoadSid("Kalinka.sid") //Load music file from system and save as variable for assembler.
	
init_music:

	lda #$01
	sta $d020
	
	ldx #$00 //set registers to 0
	ldy #$00
	lda #music.startSong-1
        jsr music.init //jump to initialization subroutine
	
	rts
        
play:	

	// Algorithm to create the margin bar effect
	lda #WHITE
	sta $d020
	//
	
	jsr music.play //jump to play subroutine
	lda #PURPLE
	sta $d020

	rts


 *=music.location "Music" //Fill c64 mem with music data
 .fill music.size, music.getData(i)
