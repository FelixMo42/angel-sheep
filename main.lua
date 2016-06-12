function loadscores(name)
	acivFile = love.filesystem.read(name)
	words = string.gmatch(acivFile, "%S+")
	filelist = {}
	i = 0
	for word in words do 
		filelist[i] = word
		i = i + 1
	end
	if #filelist ~= 5 then
		def = {}
		def[0] = 0
		def[1] = 0
		def[2] = 0
		def[3] = 255
		def[4] = 0
		def[5] = "user42"
		for i=0,5 do
			if not filelist[i] then
				filelist[i] = def[i]
			end
		end
		love.filesystem.write(name,  filelist[0].." "..filelist[1].." "..filelist[2].." "..filelist[3].." "..filelist[4].." "..filelist[5])
		loadscores(name)
	end
	text = filelist[5]
	jumpCunte = filelist[4]
	jumpCunte = tonumber(jumpCunte)
	Highscore = filelist[0]
	Highscore = tonumber(Highscore)
	color = {}
	color[0] = filelist[1]
	color[1] = filelist[2]
	color[2] = filelist[3]
end

function networking()
	if text ~= "user42" then
		for i = #WorldScore/2,1,-1 do
			if WorldScore[i*2-1] ~= text and WorldScore[i*2] > Highscore then
				for x = #WorldScore/2,1,-1 do
					if WorldScore[x*2-1] == text then
						table.remove(WorldScore,x*2-1)
						table.remove(WorldScore,x*2-1)
					end
				end
				table.insert(WorldScore, i*2+1, text)
				table.insert(WorldScore, i*2+2, Highscore)
				break
			elseif i == 1 then
				table.insert(WorldScore, #WorldScore+1, text)
				table.insert(WorldScore, #WorldScore+1, Highscore)
			end
		end
		textId = 0
		for x = #WorldScore/2,1,-1 do
			if WorldScore[x*2-1] == text then
				textId = x*2-1
				break
			end
		end
	else
		textId = #WorldScore+1
		table.insert(WorldScore, #WorldScore+1, text)
	end
end

function love.load()
	l = love.graphics
	scaleX = 1
	scaleY = 1
	image = {}
	image[1] = l.newImage("images/angelsheepWalk1.png")
	image[2] = l.newImage("images/angelsheepWalk2.png")
	imgWidth = {}
	imgHeight = {}
	for i = 1,#image do
		imgWidth[i] = math.floor(image[i]:getWidth()/50)*10
		imgHeight[i] = math.floor(image[i]:getHeight()/50)*10
	end
	--filesystem
	filename = "score.lua"
	if not love.filesystem.isFile(filename) then
		love.filesystem.newFile(filename)
		love.filesystem.write(filename,  "0 0 0 255 0")
	end
	loadscores(filename)
	--networking
	http = require("socket.http")
	http.TIMOUT = 10
	data,timeout = http.request("http://tacocat.com/felix/angelsheep/data/scores")
	if timeout == 200 then
		WorldScore = {}
		words = string.gmatch(data, "%S+")
		i = 1
		for word in words do
			WorldScore[i] = word
			i = i + 1
		end
		for i=1,#WorldScore do
			WorldScore[i*2] = tonumber(WorldScore[i*2])
		end
		networking()
	else
		textId = 3
		WorldScore = {}
		WorldScore[1] = "offline mode"
		WorldScore[2] = ""
		WorldScore[3] = text
	end
	--setup
	love.graphics.setBackgroundColor(255,255,255)
	window = "back"
	game = require("game")
	char = require("char")
	gameLoad()
	charLoad()
	--objects
	button = {}
	button.new = function(x, y, text,width,hight)
		local self = {}
		self.x = x
		self.y = y
		self.text = text
		if hight then 
			self.hight = hight 
		else
			self.hight = 60
		end
		if width then 
			self.width = width 
		else
			self.width = 120
		end

		self.draw = function(x,y)
			if x >= self.x * scaleX and x <= (self.x + self.width) * scaleX and y >= self.y * scaleY and y <= (self.y + self.hight) * scaleY then 
				l.setColor(0, 0, 0)
				l.rectangle( "fill", self.x - 1, self.y - 1, self.width + 2, self.hight + 2)
			end
			l.setColor(color[0], color[1], color[2])
			l.rectangle( "fill", self.x, self.y, self.width, self.hight)
			l.setColor(0, 0, 0)
			l.printf(self.text,self.x,self.y+(self.hight/2-5),self.width,"center")
		end

		self.update = function(x,y)
			if x >= self.x * scaleX and x <= (self.x + self.width) * scaleX and y >= self.y * scaleY and y <= (self.y + self.hight) * scaleY and  love.mouse.isDown(1) then 
				window = self.text
			end
		end

		return self
	end
	objlist = {}
	objlist[0] = button.new(50,50,"back")
	objlist[1] = button.new(10,40,"back",70,30)
	objlist[2] = button.new(340,100,"play")
	objlist[3] = button.new(340,200,"statistics")
	objlist[4] = button.new(340,300,"character")
end

function setwindow(set)
	window = set
end

function love.draw()
	l.scale(love.graphics.getWidth()/800, love.graphics.getHeight()/600)
	if window == "back" then
		for i = 2,#objlist do
			if objlist[i] ~= "llamas" then
				objlist[i].draw(love.mouse.getPosition())
			end
		end
	elseif window == "play" then
		achivmentUnlock()
		for i = 0,#charList do
			charList[i].unlock()
		end
		gameDraw()
		if not playing then
			objlist[0].draw(love.mouse.getPosition())
		end
	elseif window == "character" then
		charDraw()
		objlist[0].draw(love.mouse.getPosition())
	elseif window == "statistics" then
		statDraw()
		objlist[1].draw(love.mouse.getPosition())
	end
end

function love.update(dt)
	--windows
	if window == "back" then
		for i = 1,#objlist do
			if objlist[i] ~= "llamas" then
				objlist[i].update(love.mouse.getPosition())
			end	
		end
	elseif window == "play" then
		if not playing then
			objlist[0].update(love.mouse.getPosition())
		end
		for i = 1,#objlist do
			objlist[i].draw(love.mouse.getPosition())
		end
		gameUpdate(dt)
	elseif window == "character" then
		objlist[0].update(love.mouse.getPosition())
		charUpdate()
	elseif window == "statistics" then
		objlist[1].update(love.mouse.getPosition())
		statUpdate()
	end 
end

function love.keypressed(key,isrepeat)
	if window == "play" then
		gameKeypressed()
	end
   	if key == "escape" then
      love.event.quit()
   	end
   	if window ~= "statistics" then
   		love.keyboard.setKeyRepeat(false)
	   	if key == "f" and not love.mouse.isDown("l") then
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
    else
    	love.keyboard.setKeyRepeat(true)
    	if key == "backspace" and timeout == 200 then
    		WorldScore[textId] = WorldScore[textId]:sub(1, -2)
   		end
    end
end

function love.quit()
	love.filesystem.write(filename, Highscore.." "..color[0].." "..color[1].." "..color[2].." "..jumpCunte.." "..WorldScore[textId])

	if WorldScore[textId] ~= "user42" and timeout == 200 then
		if text == "user42" then
			table.remove(WorldScore,textId)
		end
		dataToWrite = ""
		for i = 1,#WorldScore do
			dataToWrite = dataToWrite.." "..tostring(WorldScore[i])
		end
		http.request {
			method = "PUT",
			url = "http://tacocat.com/felix/angelsheep/data/upload",
		    source = ltn12.source.string(dataToWrite),
		    headers = { 
		    	["content-type"] = "text/plain",
	        	["content-length"] = string.len(dataToWrite)
	    	}
	    }
		
	end
end