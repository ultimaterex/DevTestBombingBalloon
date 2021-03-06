-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--
-- balloon and bomb 
-- Written by Selby Rex
--
-----------------------------------------------------------------------------------------


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
--composer.gotoScene( "menu" )



-- Start the physics engine
local physics = require( "physics" )
physics.start()

-- Calculate half the screen width and height
halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5

-- Set the background
local bkg = display.newImage( "assets/night_sky.png", halfW, halfH )

-- Score
score = 0
scoreText = display.newText(score, 270, 10)

--declare sounds
local soundTable = {
   balloonSound = audio.loadSound( "sounds/balloonPop.ogg" ),
   bombSound = audio.loadSound( "sounds/bombPop.ogg" ),
}

--live system
--add life value
life = 3
lifeText = display.newText(life, 50, 10)


--Add background music
-- Define music variables
local gameMusic = audio.loadStream( "sounds/gamemusic.mp3" )
 
-- Play the music
local gameMusicChannel = audio.play( gameMusic, { loops = -1 } )

-- Called when the balloon is tapped by the player
-- Increase score by 1
local function balloonTouched(event)
	if ( event.phase == "began" ) then
		Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
		score = score + 1
		scoreText.text = score
		audio.play( soundTable["balloonSound"] )
    end
end


-- Called when the bomb is tapped by the player
-- Half the score as a penalty
local function bombTouched(event)
	if ( event.phase == "began" ) then
		Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
		life = life - 1
		lifeText.text = life
		audio.play( soundTable["bombSound"] )
    end
end
----------------------------------------



-- Delete objects which has fallen off the bottom of the screen
local function offscreen(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	end
end

-- Add a new falling balloon or bomb
local function addNewBalloonOrBomb()
	-- You can find red_ballon.png and bomb.png in the GitHub repo
	local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	if(math.random(1,5)==1) then
		-- BOMB!
		local bomb = display.newImage( "assets/bomb.png", startX, -300)
		physics.addBody( bomb )
		bomb.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", bomb )
		bomb:addEventListener( "touch", bombTouched )
	else
		-- Balloon
		local balloon = display.newImage( "assets/red_balloon.png", startX, -300)
		physics.addBody( balloon )
		balloon.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", balloon )
		balloon:addEventListener( "touch", balloonTouched )
	end
end

--add losing method
--local function gameOver(event)
--	if (life = 0) then
	
--end







-- Add a new balloon or bomb now
addNewBalloonOrBomb()



-- Keep adding a new balloon or bomb every 0.5 seconds
timer.performWithDelay( 500, addNewBalloonOrBomb, 0 )


