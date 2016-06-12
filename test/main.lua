x = 200
y = 200
angle = math.pi
w = 60
h = 60
cheak = false

function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

function love.draw()
	love.graphics.print(tostring(cheak).." "..(mx or 0).." "..(my or 0).." "..(x2 or 0).." "..(y2 or 0).." "..(x3 or 0).." "..(y3 or 0).." ")
	love.graphics.translate(x,y)
	love.graphics.rotate(angle)
	love.graphics.rectangle("fill",-w/2,-h/2,w,h,10,10)
end

function love.update()
	-- cheak = (love.mouse.getX() >= x - w/2 and love.mouse.getX() <= x + w/2) and (love.mouse.getY() >= y - h/2 and love.mouse.getY() <= y + h/2) if sqare is streat
	mx = x - love.mouse.getX()
 	my = y - love.mouse.getY()

	x2 = (x-w/2) * math.cos(angle) - (y-h/2) * math.sin(angle)
	y2 = (x-w/2) * math.sin(angle) + (y-h/2) * math.cos(angle)

	x3 = (x-w/2) * math.cos(angle) - (y-h/2) * math.sin(angle)
	y3 = (x-w/2) * math.sin(angle) + (y+h/2) * math.cos(angle)

	cheak = math.sign( (x3-x2) * (my-y2) - (y3-y2) * (mx - x2) ) * -1
end

