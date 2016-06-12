function charLoad()
	--varibles
	scrollY = 10
	setFullscreen = false
	--objects
	seting = {}
	seting.new = function(x, y, text, id,width,hight)
		local self = {}
		--varibles
		self.x = x
		self.y = y
		self.text = text
		self.id = id
		self.hight = hight 
		self.width = width 

		self.draw = function(x,y)
			if x >= self.x * scaleX and x <= (self.x + self.width) * scaleX and y >= self.y * scaleY and y <= (self.y + self.hight) * scaleY then 
				l.setColor(0, 0, 0)
				l.rectangle( "fill", self.x - 1, self.y - 1, self.width + 2, self.hight + 2)
			end
			l.setColor(color[0], color[1], color[2])
			l.rectangle( "fill", self.x, self.y, self.width, self.hight)
			l.setColor(0, 0, 0)
			l.printf(self.text,self.x,self.y+10,self.width,"center")
		end

		self.update = function(x,y)
			if x >= self.x * scaleX and x <= (self.x + self.width) * scaleX and y >= self.y * scaleY and y <= (self.y + self.hight) * scaleY and  love.mouse.isDown("l") then 
				loadstring(optList[self.id])()
			end
		end
		return self
	end

	achivment = {}
	achivment.new = function(id, name, text,r, g, b)
		local self = {}
		--varibles
		self.requ = acivList[id]
		self.x = 340
		self.y = id * 100 + 50
		self.color = {}
		self.color[0] = r
		self.color[1] = g
		self.color[2] = b
		self.name = name
		self.text = text
		self.hight = 60
		self.width = 225

		self.unlock = function()
			if acivUnlock[id] then
				l.setColor(r, g, b)
				l.rectangle( "fill", 600, 0, 200, 60)
				l.setColor(0, 0, 0)
				l.print("achivment unlocked:",610,10)
				l.print(self.name,610,25)
			end
		end

		self.draw = function(x,y)
			if x >= self.x * scaleX and x <= (self.x + self.width)*scaleX and y >= (self.y - scrollY)*scaleY and y <= (self.y - scrollY + self.hight)*scaleY then 
				l.setColor(0, 0, 0)
				l.rectangle( "fill", self.x - 1, self.y - 1 - scrollY, self.width + 2, self.hight + 2)
			end
			if self.requ then
				l.setColor(r, g, b)
			else
				l.setColor(84, 84, 84)
			end
			l.rectangle( "fill", self.x, self.y - scrollY, self.width, self.hight)
			l.setColor(0, 0, 0)
			if self.requ then
				l.print(self.name,self.x + (self.width/2-25),self.y + (self.hight/2-5) - scrollY)
			else
				l.print(self.text,self.x + (self.width/2-25),self.y + (self.hight/2-5) - scrollY)
			end
		end

		self.update = function(x,y)
			self.requ = acivList[id]
			if x >= self.x * scaleX and x <= (self.x + self.width)*scaleX and y >= (self.y - scrollY)*scaleY and y <= (self.y - scrollY + self.hight)*scaleY and  love.mouse.isDown("l") then
				if self.requ then
					color[0] = self.color[0]
					color[1] = self.color[1]
					color[2] = self.color[2]
				end
			end
		end

		return self
	end
	--statList
	statList = {}
	--statList[1] = seting.new(100,40,"night mode",1,90,30)
	--statList[2] = seting.new(200,40,"hard reset",2,90,30)
	statList[3] = seting.new(300,40,"full screen",3,90,30)
	--statList[4] = seting.new(400,40,"save",4,90,30)
	statList[5] = seting.new(500,40,"quit",5,90,30)

	optList = {}
	optList[1] = "love.event.quit()"
	optList[2] = "love.event.quit()"
	optList[3] = "setFullscreen = true"
	optList[4] = "love.event.quit()"
	optList[5] = "love.event.quit()"
	--acivments
	acivUnlock = {}

	acivList = {}
	acivList[0] = Highscore >= 0 or score >= 0
	acivList[1] = Highscore > 275 or score >= 275
	acivList[2] = Highscore >= 270 or score >= 270
	acivList[3] = Highscore >= 3000 or score >= 3000
	acivList[4] = Highscore >= 6000 or score >= 6000
	acivList[5] = Highscore >= 9000 or score >= 9000
	acivList[6] = jumpCunte >= 30000
	acivList[7] = jumpCunte >= 60000
	acivList[8] = jumpCunte >= 90000

	charList = {}
	charList[0] = achivment.new(0,"just for playing"," ",0,0,255)
	charList[1] = achivment.new(1,"You jumped","just play",0,153,0)
	charList[2] = achivment.new(2,"DIE!!!!","die",255,0,0)
	charList[3] = achivment.new(3,"earn your wings","get to over 3000",205,127,50)
	charList[4] = achivment.new(4,"second is the best","get to over 6000",192,192,192)
	charList[5] = achivment.new(5,"OVER 9000!!!!!","get to over 9000",255,215,0)
	charList[6] = achivment.new(6,"JUMP","jump 30000 times",111,215,0)
	charList[7] = achivment.new(7,"this is jumpa","jump 60000 times",0,0,0)
	charList[8] = achivment.new(8,"jump to the MAX","jump 90000 times",255,255,255)
end

function statDraw()
	l.print("#",50,110)
	l.print("name",90,110)
	l.print("score",200,110)
	for i = 1,#WorldScore/2 do
		l.print(tostring(i),50,110 + i * 20)
		l.print(WorldScore[i*2-1],90,110 + i * 20)
		l.print(WorldScore[i*2],200,110 + i * 20)
	end
	l.setColor(100, 100, 100)
	l.rectangle( "fill", 0, 0,800, 100)
	l.rectangle( "fill", 0, 560,800, 40)
	l.rectangle( "fill", 760, 0,40, 800)
	l.rectangle( "fill", 0, 0,40,600)
	l.setColor(0, 0, 0)
	l.print("name: "..WorldScore[textId], 10, 10)
	if score > Highscore and alive == false then
		l.print("Highscore: "..score, 200, 10)
	else
		l.print("Highscore: "..Highscore, 200, 10)
	end
	l.print("Jump count: "..jumpCunte, 400, 10)
	for i = 1,#statList do
		statList[i].draw(love.mouse.getPosition())
	end
end

function statUpdate()
	if setFullscreen and not love.mouse.isDown("l") then
		setFullscreen = false
		if love.window.getFullscreen() then
		   	love.window.setFullscreen(false)
		   	scaleY = 1
	     	scaleX = 1
		else
	   		love.window.setFullscreen(true)
	 		scaleX = love.window.getWidth()/800
	  		scaleY = love.window.getHeight()/600
	    end
	end
	for i = 1,#statList do
		statList[i].update(love.mouse.getPosition())
	end
end

function charDraw()
	for i = 0,#charList do
		charList[i].draw(love.mouse.getPosition())
	end
end

function achivmentUnlock()
	acivUnlock[0] = false
	acivUnlock[1] = score > 275 and score <= 575 and Highscore < 275
	acivUnlock[2] = Highscore == 0 and alive == false
	acivUnlock[3] = score >= 3000 and score <= 3300 and Highscore < 3000
	acivUnlock[4] = score >= 6000 and score <= 6400 and Highscore < 6000
	acivUnlock[5] = score >= 9000 and score <= 9500 and Highscore < 9000
	acivUnlock[6] = jumpCunte >= 30000 and jumpCunte <= 30005
	acivUnlock[7] = jumpCunte >= 60000 and jumpCunte <= 60005
	acivUnlock[8] = jumpCunte >= 90000 and jumpCunte <= 90005
end

function love.textinput(t)
	if #WorldScore[textId] <= 9 and window == "statistics" and timeout == 200 then
    	WorldScore[textId] = WorldScore[textId] .. t
    	WorldScore[textId] = WorldScore[textId]:gsub("%s+", "")
    end
end

function charUpdate()
	acivList[0] = Highscore >= 0 or score >= 0
	acivList[1] = Highscore > 275 or score >= 275
	acivList[2] = Highscore >= 270
	acivList[3] = Highscore >= 3000 or score >= 3000
	acivList[4] = Highscore >= 6000 or score >= 6000
	acivList[5] = Highscore >= 9000 or score >= 9000
	acivList[6] = jumpCunte >= 30000
	acivList[7] = jumpCunte >= 60000
	acivList[8] = jumpCunte >= 90000
	for i = 1,#charList do
		charList[i].update(love.mouse.getPosition())
	end
end

function love.mousepressed(x, y, button)
	--scroll
	if window == "character" then
	   if button == "wu" then
			if scrollY > 11 and scrollY <= #charList*100 + 40 then
				scrollY = scrollY - 200
			end
		elseif button == "wd" then
			if scrollY > 0 and scrollY < (#charList*100)/2 then
				scrollY = scrollY + 20
			end
		end
	end
end