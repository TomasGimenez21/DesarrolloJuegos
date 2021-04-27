push = require 'push'

Class= require 'class'

require 'Barra'

require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("PONG")
    
    math.randomseed(os.time())


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    score=love.graphics.newFont('font.ttf', 32)
    pongScreen=love.graphics.newFont('font.ttf', 40)
    smallFont=love.graphics.newFont('font.ttf', 8)

    jugador1 = Barra(10, 30, 5, 40)
    jugador2 = Barra(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 40)
    
    jugadorCPU2=false
    jugadorCPU1=false

    pelota= Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4, 4)

    juegoEstado="Start"
    turnoJP=2

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if juegoEstado=="Start" or juegoEstado=="Serve" then
        pelota.dy = math.random(-50, 50)
        if turnoJP == 1 then 
            pelota.dx = math.random(140, 200)
        else
            pelota.dx = -math.random(140, 200)
        end
    elseif juegoEstado=="Play" then 
        if pelota:colisionBall(jugador1) then-- mirar un poco mejor para entenderlo bien
            pelota.dx = -pelota.dx * 1.03
            pelota.x = jugador1.x + 15
            sounds['paddle_hit']:play()
            if pelota.dy < 0 then
                pelota.dy = -math.random(10, 150)
            else
                pelota.dy = math.random(10, 150)
            end
        end
        if pelota:colisionBall(jugador2) then    
            pelota.dx = -pelota.dx * 1.03
            pelota.x = jugador2.x - 15
            sounds['paddle_hit']:play()
            if pelota.dy < 0 then
                pelota.dy = -math.random(10, 150)
            else
                pelota.dy = math.random(10, 150)
            end
        end

        if pelota.y <=0 then
            pelota.y=0
            pelota.dy=-pelota.dy
            sounds['wall_hit']:play()
        elseif pelota.y >= VIRTUAL_HEIGHT-4 then
            pelota.y=VIRTUAL_HEIGHT-4
            pelota.dy=-pelota.dy
            sounds['wall_hit']:play()
        end

        if pelota.x <= 0 then
            jugador2.puntaje= jugador2.puntaje + 1
            turnoJP=1
            sounds['score']:play()
            if jugador2.puntaje==10 then
                juegoEstado="Done"
            else
                juegoEstado="Serve"
                pelota:reset()
            end
        elseif pelota.x > VIRTUAL_WIDTH then
            jugador1.puntaje=jugador1.puntaje+1
            turnoJP=2
            sounds['score']:play()
            if jugador1.puntaje==10 then
                juegoEstado="Done"
            else
                juegoEstado="Serve"
                pelota:reset()
            end
    end    
    if jugadorCPU1 then
        jugador1.y=pelota.y
    else
        if love.keyboard.isDown("s") and jugador1.y<= VIRTUAL_HEIGHT-jugador1.height then
        jugador1.y= jugador1.y + jugador1.dy
        end
        if love.keyboard.isDown("w") and jugador1.y>= 0 then
            jugador1.y= jugador1.y - jugador1.dy
        end
    end
    if jugadorCPU2 then
            jugador2.y=pelota.y
    else
        if love.keyboard.isDown("down") and jugador2.y<= VIRTUAL_HEIGHT-jugador2.height then
            jugador2.y= jugador2.y + jugador2.dy
        end
        if love.keyboard.isDown("up") and jugador2.y>=0 then
            jugador2.y= jugador2.y - jugador2.dy
        end
    end
    if juegoEstado=="Play" then
        pelota:update(dt)
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if juegoEstado == 'Start' then
            juegoEstado = 'Serve'
        
        elseif juegoEstado == 'Serve' then
            juegoEstado = 'Play'
        
        elseif juegoEstado == 'Done' then
            juegoEstado = 'Serve'
            pelota:reset()
             if jugador1.puntaje == 10 then
                turnoJP = 1
            elseif jugador2.puntaje == 10 then
                turnoJP = 2
            end
            jugadorCPU=false
            jugador1.puntaje=0
            jugador2.puntaje=0
        end
    end
    if key=='space' and juegoEstado=="Start" then
        jugadorCPU2=true
    end
    if key=='x' and juegoEstado=="Start" then
        jugadorCPU1=true
    end
end


function love.draw()
    push:apply('start')
    if juegoEstado=='Done' then
        if turnoJP==1 then
            love.graphics.setFont(smallFont)
            love.graphics.printf("JP1 WINS", 0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("press enter to restart", 0, 200, VIRTUAL_WIDTH, 'center')

        else
            love.graphics.setFont(smallFont)
            love.graphics.printf("JP2 WINS", 0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("press enter to restart", 0, 200, VIRTUAL_WIDTH, 'center')

        end
    elseif juegoEstado=='Play' then
        
    elseif juegoEstado=='Start' or 'Serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("press enter to start or serve", 0, 200, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("press space bar to play vs CPU(J2) or x if you want to be J2", 0, 220, VIRTUAL_WIDTH, 'center')

    end
        displayPuntaje()

    jugador1:render()
    jugador2:render()
    
    pelota:render()
    love.graphics.setFont(pongScreen)
    love.graphics.printf('PONG', 0, 20, VIRTUAL_WIDTH, 'center')

    push:apply('end')
end

function displayPuntaje()
    love.graphics.setFont(score)--activa la fuente
    love.graphics.print(tostring(jugador1.puntaje), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 2 - 20)
    love.graphics.print(tostring(jugador2.puntaje), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 2 - 20)

end
end
-- terminar y hacer que no traspase la barra entre otras cosas