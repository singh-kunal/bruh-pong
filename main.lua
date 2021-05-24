push = require "push"
Class = require "class"
require "Ball"
require "Paddle"


window_width = 1280
window_height = 720

virtual_width = 432
virtual_height = 243

paddlespeed = 200

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle("Bruh Pong")

	math.randomseed(os.time())

	smallfont = love.graphics.newFont("font.ttf", 8)

	scorefont = love.graphics.newFont("font.ttf", 32)

	love.graphics.setFont(smallfont)

	push:setupScreen(virtual_width, virtual_height, window_width, window_height, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})

	player1score = 0
	player2score = 0

	player1 = Paddle(5, 30, 5, 20)
	player2 = Paddle(virtual_width - 10, virtual_height - 30, 5, 20)

	ball = Ball(virtual_width/2 - 2, virtual_height/2 - 2, 4, 4)

	gamestate = "start"

	playerserve = math.random(2)

	
end

function love.update(dt)

	if gamestate == "serve" then 
		
		if playerserve == 1 then
			if ball.dx < 0 then
				ball.dx = -ball.dx
			end
		else
			if ball.dx > 0 then 
				ball.dx = -ball.dx
			end

		end



	elseif gamestate == "play" then
    	
    	--BALL collision
    	if ball:collides(player1) then 
    		ball.dx = -ball.dx * 1.05
    		ball.x = player1.x +5

    		if ball.dy < 0 then 
    			ball.dy = -math.random(10, 150)
    		else
    			ball.dy = math.random(10, 150)
    		end
    	end


    	if ball:collides(player2) then 
    		ball.dx = -ball.dx * 1.05
    		ball.x = player2.x - 4

    		if ball.dy < 0 then 
    			ball.dy = -math.random(10, 150)
    		else
    			ball.dy = math.random(10, 150)
    		end
    	end

    	-- Wall boundary

    	if ball.y <= 0 then 
    		ball.y = 0
    		ball.dy = -ball.dy
    	end

    	if ball.y >= virtual_height - 4 then 
    		ball.y = virtual_height - 4
    		ball.dy = -ball.dy
    	end

    	-- player 1
		if love.keyboard.isDown('w') then
			player1.dy = -paddlespeed
		elseif love.keyboard.isDown('s') then
			player1.dy = paddlespeed
		else
			player1.dy = 0
		end

		--player 2
		if love.keyboard.isDown("up") then 
			player2.dy = -paddlespeed 
		elseif love.keyboard.isDown("down") then 
			player2.dy = paddlespeed
		else
			player2.dy = 0
		end

		--score reset
		if ball.x < 0 then 
			player2score = player2score + 1
			playerserve = 1
			gamestate = "serve"
			ball:reset()
		elseif ball.x > virtual_width then 
			player1score = player1score + 1
			playerserve = 2
			gamestate = "serve"
			ball:reset()
    	end

    	if player1score == 10 or player2score == 10 then 
    		gamestate = "finish"
    	end

    	ball:update(dt)

    	player1:update(dt)
    	player2:update(dt)
    end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()

	elseif key == "enter" or key == "return" then
		if gamestate == "start" then
			player1score = 0
			player2score = 0

			gamestate = "serve"
		elseif gamestate == "serve" then 
			gamestate = "play"
		elseif gamestate == "finish" then
			gamestate = "start"
			
			ball:reset()
		else 
			gamestate = "start"
			
			ball:reset()
		end
		
		
	end
end

function love.draw()
	push:apply("start")

	love.graphics.clear(40/255,40/255,40/255,255/255)

	love.graphics.setFont(smallfont)
	if gamestate == "start" then 
		love.graphics.printf("Bruh Pong! START", 0, 20, virtual_width, "center")
	elseif gamestate == "serve" then 
		love.graphics.printf("Bruh Pong! SERVE", 0, 20, virtual_width, "center")
		if playerserve == 1 then 
			love.graphics.printf("Player 1 SERVE", 0, 30, virtual_width, "center")
		else
			love.graphics.printf("Player 2 SERVE", 0, 30, virtual_width, "center")
		end
	elseif gamestate == "play" then
		love.graphics.printf("Bruh Pong! PLAY", 0, 20, virtual_width, "center")
	elseif gamestate == "finish" then 
		love.graphics.clear(40/255,45/255,40/255,255/255)
		love.graphics.printf("Bruh Pong! Finished!", 0, 20, virtual_width, "center")
		if player1score == 10 then 
			love.graphics.printf("Player 1 WINS", 0, 40, virtual_width, "center")
		else
			love.graphics.printf("Player 2 WINS", 0, 40, virtual_width, "center")
		end
 

	end

	love.graphics.setFont(scorefont)

	love.graphics.print(tostring(player1score), virtual_width/2 - 50, virtual_height/3)
	love.graphics.print(tostring(player2score), virtual_width/2 + 30, virtual_height/3)

	player1:render()
	player2:render()

	ball:render()

	displayfps()

	

	push:apply("end")
end

function displayfps()
	love.graphics.setFont(smallfont)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 10, 10)
end