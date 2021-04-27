--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}
scrolling =true
local x=false
function PlayState:init()
    self.cuadrado = Cuadrado()
    self.precipicio = {}
    self.timer = 0
    self.timer2 = 0
    self.timer3=0
    self.score = 0
    self.puasChicas = {}
    self.coins = {}
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    --self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
        if scrolling then
            if love.keyboard.wasPressed('p') then
                scrolling=false
            end
        self.timer = self.timer + dt --timerPrecipicio
        self.timer2 = self.timer2 + dt --timerPua
        self.timer3 = self.timer3 + dt --timerCoin
        self.score = self.score + 1
        if self.timer == 0.5 then
            self.score = self.score +1
        end
        if self.timer > math.random(3, 20) then
            table.insert(self.precipicio, Precipicio())
            self.timer=0
        end
        if self.timer2 > math.random(1.25, 15) then
            table.insert(self.puasChicas, BarraPuasChica(math.random(150, 200)))
            self.timer2=0
        end
        -- coin
        if self.timer3 >= math.random(4, 60) then
            table.insert(self.coins, Coin(math.random(20, 250)))
            self.timer3=0
        end
        --precipicio
        for k, pair in pairs(self.precipicio) do
            if pair.scored == false then
                if pair.x + pair.width < self.cuadrado.x then
                    pair.scored = true
                end
            end
            pair:update(dt)
        end
        for k, pair in pairs(self.precipicio) do
            if pair.remove then
                table.remove(self.precipicio, k)
            end
        end
        --puasChicas
        for k, pair in pairs(self.puasChicas) do
            if pair.scored == false then
                if pair.x + pair.width < self.cuadrado.x then
                    pair.scored = true
                end
            end
            pair:update(dt)
        end
        for k, pair in pairs(self.puasChicas) do
            if pair.remove then
                table.remove(self.puasChicas, k)
            end
        end
        --coin
        for k, pair in pairs(self.coins) do
            pair:update(dt)
        end
        for k, pair in pairs(self.coins) do
            if pair.remove or pair.scored then
                table.remove(self.coins, k)
            end
        end

        --colision VIRTUAL HEIGHT
        if self.cuadrado.y > VIRTUAL_HEIGHT then
            sounds['explosion']:play()
            gStateMachine:change('score', {
                score = self.score
            })
        end 
        --colision precipicio
        for k, pair in pairs(self.precipicio) do
            if self.cuadrado:collidesPrecipicio(pair) then
                self.cuadrado.sobrePrecipicio = true
                self.cuadrado:update(dt)
            else 
                self.cuadrado.sobrePrecipicio = false
            end
        end
        --colision puaChica
        for k, pair in pairs(self.puasChicas) do
            self.cuadrado.sobrePuaChica=self.cuadrado:collidesPuasC(pair)
            if self.cuadrado.sobrePuaChica==4 then 
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end   
        --colision coin
        for k, pair in pairs(self.coins) do
            if self.cuadrado:collidesCoin(pair) then
                self.score=self.score+2000
                table.remove(self.coins, k)
            end
        end
        
        self.cuadrado:update(dt)
    else
        if love.keyboard.wasPressed('p') then
            scrolling=true
        end
    end    
end

function PlayState:render()
    for k, pair in pairs(self.coins) do
        pair:render()
    end
    for k, pair in pairs(self.precipicio) do
        pair:render()
    end
    for k, pair in pairs(self.puasChicas) do
        pair:render()
    end
    
    self.cuadrado:render()
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8) 
    if scrolling==false then
        love.graphics.draw(pausa, VIRTUAL_WIDTH/2-pausa:getWidth()/2, VIRTUAL_HEIGHT/2-pausa:getHeight()/2)
    end
    displayFPS()
end
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH-70, 10)
end
--    Called when this state is transitioned to from another state.

function PlayState:enter()
  
end


 --   Called when this state changes to another state.

function PlayState:exit()
    
end
--hacer colisiones de las puas, arreglar el renderizado. Se crean puas o precipicios pero no ambos ¿Por qué? Se superponen las Puas ¿Por qué?