local function main()

------------------------ forward preferences: ----------------------

-- coordinates
local centerX = display.contentCenterX -- the center of the screen by X coordinate
local centerY = display.contentCenterY-- the center of the screen by Y coordinate

-- game variables
local score = 0 -- Player's score
local rnX -- random number for x coordinate
local rnY -- random number for y coordinate
local rns -- random number for scale
local Timer -- the Timer of the game
local fitwMode -- fast in the west mode
local highscore = 0 -- high score

--Graphics:
local background -- the background of the game
local gbt -- enemy picture
local title -- starting title of the game
local fastInTheWest -- the legendary portrait of THE FAST!!!! INNNN THE WESTTTTTTTTTT!!!!!

--Texts
local scoreTxt -- score label
local scoreEnd -- ending score label
local tryAgain -- try again label
local msgText -- string
local msg -- message label
local endTxt -- 'you score is'
local highScore -- high score text
local GBTtext -- all rights belong to GBT

--functions
local createscreen -- function to create the screen for the first time
local showTitle -- function to show the title
local startGame -- function to lunch the game
local spawnGBT -- function to spawn gbt
local spawn -- kill gbt and spawn new
local endGame -- end the game
local showMsg -- show the player a massage based on his score
local tryAgainMsg -- function to show the try again message
local reset -- function to restart the game

--Sounds

local foo = audio.loadSound ("foo.mp3") -- sound of saito reSpawn
local hit = audio.loadSound ("hit.mp3") -- sound when titles hit the ground 
local bgMusic = audio.loadSound ( "bg.mp3" ) -- background music

---------------------------------------------------------------------
 -- functions:

function createscreen()
	score=0
	fitwMode=0
	background = display.newImage("bg.png")
	background.scale = "letterbox"
	background.alpha = 0;
	scoreTxt = display.newText( "Score: 0", 0, 0, "Helvetica", 22 )
	scoreTxt.x = centerX
	scoreTxt.y = 30
	scoreTxt.alpha = 0.8
	highScore = display.newText( "High Score:".. highscore , 0, 0, "Helvetica", 10 )
	highScore.y = display.contentHeight-50
	GBTtext = display.newText("® GBT Production™ ", 0, 0, "Helvetica", 10)
	GBTtext.x = display.contentWidth-55
	GBTtext.y = display.contentHeight-50
	transition.to( background, { time=2000, alpha=1, onComplete=showTitle } ) 
end

function showTitle()
	title = display.newImage("text.png")
	title:scale(4,4)
	audio.play(foo)
	transition.to(title, { time = 200, xScale = 1, yScale = 1})
	title:addEventListener ( "tap", startGame )


end

function startGame(event)
	audio.play (bgMusic)
	--------------Start Timer! 30 seconds-------------------
	Timer = display.newImage("time.png")
	Timer.y = display.contentHeight
	transition.to(Timer, {time = 40000, xScale=0, onComplete=endGame})
	-------------------------------------------------------
	local obj = event.target
	display.remove( obj )
	spawnGBT()
	return true



end

function spawnGBT()
	gbt = display.newImage("gbt.png")
	rnX = math.random(50, display.contentWidth-50)
	rnY = math.random(50, display.contentHeight-50)
	rns = math.random(20,99)
	gbt.x = rnX
	gbt.y = rnY
	gbt:scale(rns/100,rns/100)
	gbt:addEventListener ("tap", spawn)

end

function spawn(event)
	audio.play(hit)
	local obj = event.target

	display.remove(obj)
	--------- update score -----------
	score = score + math.random(6,8)
	scoreTxt.text = "Score: " .. score
	-----------------------------------
	spawnGBT() -- spawn another
	return true
end

function endGame()
	audio.stop()
	display.remove(gbt)
	display.remove(scoreTxt)
	display.remove(Timer)
	display.remove(background)
	background = display.newImage("bg2.png")
	---- Score Analyzing:-----------
	if score<200 then
		msgText = "WEAK!"
		fitwMode = 1
	else
		if score<400 then
			msgText = "So slow!!!"
			fitwMode = 2
		else
			if score<600 then
				msgText = "Not fast enough..."
				fitwMode = 3
			else
				if score<800 then
					fitwMode = 4
					msgText = "you are NOT the fast in the west"
				else
					if score<1000 then
						fitwMode = 5
						msgText = "I respect you"
					else
						fitwMode = 6
						msgText = "YOU ARE THE FAST IN THE WEST"
					end
				end
			end
		end
	end
	--------------------------------
	------fitw------
	fastInTheWest = display.newImage("fitw"..fitwMode..".png")
	fastInTheWest.x = display.contentWidth-50
	fastInTheWest.alpha = .6
	fastInTheWest.y = 170
	-----------------
	
	endTxt = display.newText("Your Score Is:", 0, 0, "Helvetica", 40)
	endTxt.x = display.contentWidth / 2
	endTxt.y = display.contentHeight / 3
	endTxt:scale(4,4)
	audio.play(foo)
	transition.to(endTxt, { time=200, xScale=1, yScale=1})
	scoreEnd = display.newText(""..score,0,0,"Helvetica",40)
	scoreEnd.x = display.contentWidth/2
	scoreEnd.y = display.contentHeight / 3 + 50
	scoreEnd.alpha=0
	transition.to(scoreEnd, {time=400, alpha=1,onComplete=showMsg})
end

function showMsg() -- show messege based on the player's score
	msg = display.newText(msgText, 0, 0, "Helvetica", 35)
	msg.x = display.contentWidth / 2
	msg.y = display.contentHeight / 3 + 150
	msg:scale(4,4)
	audio.play(foo)
	if score > highscore then
		display.remove(highScore)
		highscore = score
		highScore.text = "High Score: " .. highscore
	end
	transition.to(msg, { time=200, xScale=1, yScale=1, onComplete=tryAgainMsg })
end

function tryAgainMsg()
	if fitwMode<4 then
		tryAgain=display.newText("Try Again Loser!", 0, 0, "Helvetica", 40)
	else
		tryAgain=display.newText("Try Again...", 0, 0, "Helvetica", 40)
	end
	tryAgain.x = display.contentWidth / 2
	tryAgain.y = display.contentHeight - 80
	tryAgain:scale(4,4)
	audio.play(foo)
	transition.to(tryAgain, { time=200, xScale=1, yScale=1})
	tryAgain:addEventListener("tap", reset)
end

function reset(event)
	display.remove(endTxt)
	display.remove(background)
	display.remove(tryAgain)
	display.remove(scoreEnd)
	display.remove(msg)
	display.remove(fastInTheWest)
	
	createscreen()
	return true
end

createscreen()

end
main()
