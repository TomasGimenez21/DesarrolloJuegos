push = require 'push'

Class = require 'class'

require 'StateMachine'

require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'Cuadrado'
require 'Precipicio'
require 'BarraPuasChica'
require 'Coin'


--PARA ARREGLAR LOS PROBLEMAS EN LOS QUE TUVE QUE USAR PARCHES Y EL DELAY DE SALTO 
--PROBAR USANDO math.floor() AGARRA EL VALOR EN ENTERO, EN MARIO MIN 19' EXPLICA
--QUE SIN ESO EL JUGADOR VA A VIBRAR, LO QUE PASA CON EL MIO


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

groundImage = love.graphics.newImage('Ground.png')
groundScroll = 0
groundScrollSpeed = 100

pausa=love.graphics.newImage('p1.png')

local backgroundImage = love.graphics.newImage('Background1.png')
backgroundScroll = 0
local backgroundScrollSpeed = 50

function love.load() 
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    --cambiarlas, son de prueba
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    --cuadrado = Cuadrado()

    math.randomseed(os.time())

    love.window.setTitle('DASH')

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static')
}
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')
    --ver si se van
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end


function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + backgroundScrollSpeed * dt) % 438
        groundScroll = (groundScroll + groundScrollSpeed * dt) % 479
    end
     
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end
--ver si las saco o no
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    push:start()
        love.graphics.draw(backgroundImage, -backgroundScroll, 0)
        love.graphics.draw(groundImage, -groundScroll, VIRTUAL_HEIGHT - 16)
        gStateMachine:render()
    push:finish()
end