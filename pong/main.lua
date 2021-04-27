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

    jugador1 = Barra(10, 20, 15, 100)
    jugador2 = Barra(WINDOW_WIDTH-25, WINDOW_HEIGHT-125, 15, 100)
  
    pelota= Ball(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8, 8)

    juegoEstado="Start"
    turnoJP=2

end

function love.update(dt)
    
    love.window.setTitle(juegoEstado)

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
            if pelota.dy < 0 then
                pelota.dy = -math.random(10, 150)
            else
                pelota.dy = math.random(10, 150)
            end
        end
        if pelota:colisionBall(jugador2) then
            pelota.dx = -pelota.dx * 1.03
            pelota.x = jugador2.x + 15
            if pelota.dy < 0 then
                pelota.dy = -math.random(10, 150)
            else
                pelota.dy = math.random(10, 150)
            end
        end

        if pelota.y <=0 then
            pelota.y=0
            pelota.dy=-pelota.dy
        elseif pelota.y >= 680 then-- cambiarlo
            pelota.y=680
            pelota.dy=-pelota.dy
        end

        if pelota.x <= 0 then
            jugador2.puntaje= jugador2.puntaje + 1
            turnoJP=1
            if jugador2.puntaje==10 then
                juegoEstado="Done"
                --winningplayer=2
            else
                juegoEstado="Serve"
                pelota:reset()
            end
        elseif pelota.x >= 1270 then --probar si esta bien, cambiarlo igualmente
            jugador1.puntaje=jugador1.puntaje+1
            turnoJP=2
            if jugador1.puntaje==10 then
                juegoEstado="Done"
                --winningplayer=1
            else
                juegoEstado="Serve"
                pelota:reset()
            end
    end    
    
    moverBarra(jugador1, "s", "w")--intentar crear una funcion y pasar por parametro jugador 1 y 2 para no tener que hacer 2 veces lo mismo
    moverBarra(jugador2, "down", "up")
    if love.keyboard.isDown("s") and jugador1.y<= (600) then
        jugador1.y= jugador1.y + jugador1.dy
    end
    if love.keyboard.isDown("w") and jugador1.y>= 0 then
        jugador1.y= jugador1.y - jugador1.dy
    end

    if love.keyboard.isDown("down") and jugador2.y<= (600)--[[hay que cambiarlo, fijarse en el ejemplo]] then
        jugador2.y= jugador2.y + jugador2.dy
    end
    if love.keyboard.isDown("up") and jugador2.y>=0 then
        jugador2.y= jugador2.y - jugador2.dy
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
            ball:reset()
             if jugador1.puntaje == 10 then
                turnoJP = 1
            elseif jugador2.puntaje == 10 then
                turnoJP = 2
            end
            jugador1.puntaje=0
            jugador2.puntaje=0
        end
    end
end

function moverBarra(barra, abajo, arriba)
    if love.keyboard.isDown("abajo") then
        barra.y= barra.y + barra.dy
    end
    if love.keyboard.isDown("arriba") then
        barra.y= barra.y - barra.dy
    end
end
function love.draw()
    jugador1:render()
    jugador2:render()
    display()
    --push:apply('end')--?

    pelota:render() 
end
function display()
    love.graphics.print('dy: ' .. tostring(pelota.dy), 10, 10)

end
end
-- terminar y hacer que no traspase la barra entre otras cosas