function gameLoad()
	--variabl
	y = 360
	jump = 0
	floor = 360
	alive = true
	playing = true
	spawnTime = 200
	score = 0
	animPos = 1
	--object
	anim = {}
	anim.new = function(fram1,fram2)
		local self = {}
		self.fram1 = fram1
		self.fram2 = fram2
		animPos = fram1
		self.timer = 20

		self.update = function() 
			self.timer = self.timer - 1
			if self.timer == 0 then
				if animPos == self.fram2 then
					animPos = self.fram1
				else
					animPos = animPos + 1
				end
				self.timer = 20
			end
		end

		self.draw = function()
			l.setColor(color[0], color[1], color[2])
	    	l.draw(image[animPos],100 - imgWidth[fram1],y - imgWidth[fram1],0,0.5,0.5)
		end

		return self
	end
	animWalk = anim.new(1,2)


	gameObj = {}
	pillar = {}
	pillar.new = function(hight, width, id)
		local self = {}
		--varibles
		self.width = width
		self.hight = hight
		self.id = id
		self.x = 900
		spawnTime = love.math.random(width/5, 100)
		
		self.draw = function()
			l.setColor(0, 0, 0)
    		l.rectangle( "fill",self.x, 430 - self.hight , self.width, self.hight)
		end

		self.update = function()
			if self.x + self.width + 50 < 0 then gameObj[id] = "llamas" end
			self.x = self.x - 10

			if self.x < 161 and self.x + self.width > 100 and floor >= 360 - self.hight then
				floor = 360 - self.hight
			elseif self.x + self.width ==  100 - imgWidth[2] then
				floor = 360
			end
		end

		return self
	end
end

function spawner()
	local self = {}
	if spawnTime == 0 then
		for i = 1,#gameObj + 1 do
			if spawnTime == 0 then
				if i == #gameObj + 1 then
					gameObj[i] = pillar.new(love.math.random(3, 14)*10,love.math.random(3, 30)*10,i)
				elseif gameObj[i] == "llamas" then
					gameObj[i] = pillar.new(love.math.random(3, 14)*10,love.math.random(3, 30)*10,i)
					i = #gameObj
				else
					i = i + 1
				end
			end
		end
	else spawnTime = spawnTime - 1 end
	return self
end

function gameEnd()
	if score > Highscore then
		Highscore = score
		love.filesystem.write(filename, Highscore.." "..color[0].." "..color[1].." "..color[2].." "..jumpCunte.." "..text)
	end
end

function gameDraw()
	--score/hight
	l.setColor(color[0],color[1],color[2])
	l.print("Score: " .. score .. "	HighScore: " .. Highscore,0,0,0,2,2)
	if alive then
		--object
		for i = 1,#gameObj do
			if gameObj[i] ~= "llamas" then
				gameObj[i].draw()
			end
		end	
		--grond
    	l.setColor(0, 0, 0)
	    l.rectangle( "fill",0,430, 800, 450)
	    --character
	    if y == floor then
	    	animWalk.draw()
	    else
	    	l.setColor(color[0], color[1], color[2])
	    	l.draw(image[animPos],100 - imgHeight[animPos],y - imgWidth[animPos],0,0.5,0.5)
	    end
	else
		--dead
		l.setColor(color[0], color[1], color[2])
		l.print("you are dead!!!!!",200,200,0,5)
		l.print("press r to restart",200,300,0,5)
	end
end

function gameUpdate(dt)
	if playing then
		--spawner + score
		spawner()
		score = score + 1
		-- if dead
		if y > floor then 
			alive = false
			playing = false
			gameEnd()
		end
		--objects
		if y == floor then
	    	animWalk.update()
	    end
		for i = 1,#gameObj do
			if gameObj[i] ~= "llamas" then
				gameObj[i].update()
			end
		end	
		--jump + gravity
		if (love.keyboard.isDown("w","up") or love.mouse.isDown( 1 )) and jump == 0 and y == floor and score > 20 then
			if not love.keyboard.isDown("s","down") then
				jumpCunte = jumpCunte + 1
			end
			jump = 20
		elseif jump == 0 and y < floor then
			y = y + 10
		elseif jump ~= 0 then
			jump = jump - 1
			y = y - 10
		end
		if (love.keyboard.isDown("s","down") or love.mouse.isDown( "r" )) and y ~= floor then
			jump = 0
			y = y + 10
		end
	end
	-- restart
   	if love.keyboard.isDown("r") or love.mouse.isDown("l") and not alive then
   		if score > Highscore then
   			Highscore = score
   		end
   		gameEnd()
   		gameLoad()
   	end
end

function gameKeypressed()
	--pause
	if love.keyboard.isDown("p"," ") and alive then
    	if playing then
    		playing = false
    	else
    		playing = true
    	end
   	end
end