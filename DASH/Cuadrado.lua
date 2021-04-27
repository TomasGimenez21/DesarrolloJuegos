Cuadrado = Class{}
local yBarra = 0
local gravedad = 20
local piso = false
local piso1=false

function Cuadrado:init()
    self.image=love.graphics.newImage('cuadrado.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.y=VIRTUAL_HEIGHT - self.height-16
    self.x = 30
    self.dy=0
    self.scored=false
    self.sobrePrecipicio=false
    self.timer=0
    self.sobrePuaChica=0
    yBarra=VIRTUAL_HEIGHT - self.height-16 
    --  piso=VIRTUAL_HEIGHT - self.height-16
end

function Cuadrado:collidesPrecipicio(precipicio)
    if (self.x >= precipicio.x ) and (self.x+self.width) <= (precipicio.x + precipicio.width) and (self.y>245)then
        self.x=self.x-5
        return true
    else
        self.x = 30
        return false
    end
end

function Cuadrado:collidesPuasC(pua)
--    if (self.x >= precipicio.x ) and (self.x+self.width) <= (precipicio.x + precipicio.width) and ((self.y==puas.y+puas.height/2 or (self.y<=puas.y)) or (self.y>=puas.y+puas.height/2))
    if (self.x+self.width >= pua.x) and (self.x<pua.x+pua.width) and (self.y>pua.y+pua.height/2 and self.y<=pua.y+pua.height) then --colision con la parte de abajo
        --que lo tire para abajo, arreglar para que se vea mejor, que no tiemble
        --self.sobrePuaChica = 1
        self.y=pua.y+pua.height+3
        self.dy=0
        self.y=self.y+self.dy
        return 1
    elseif (self.x+self.width-self.width/3 >= pua.x) and (self.x<pua.x+pua.width) and (self.y<=pua.y+pua.height/2 and self.y>pua.y) then--colision parte de arriba(sin pua)
        --que lo mantenga sobre la barra
        --self.sobrePuaChica = 2
        if self.x+self.width >= pua.x+27 and  (self.x<pua.x+43) then
            sounds['explosion']:play()
            return 4
        else
            self.dy=0
            self.y=(pua.y+pua.height/2)-self.height
            yBarra=(pua.y+pua.height/2)-self.height
            piso1=true
            return 2
        end
    else
        --self.sobrePuaChica = 0
        return 0
    end

end

function Cuadrado:collidesCoin(coin)
    if (self.x+self.width >= coin.x) and (self.x<coin.x+coin.width) and (self.y+self.height >= coin.y) and (self.y < coin.y+coin.height) then
        coin.scored=true
        sounds['score']:play()
        return true
    else
        return false
    end
end

function Cuadrado:update(dt)--anda pero si estas muy cerca del Virtual Height no te deja saltar, es un quilombo porque esta todo parcheado  
    if self.timer > 0.7 then--PARCHE2 PARA QUE FUNCIONE EL 1
        if piso then
            piso=false
        end
        if piso1 then
           piso1=false
           yBarra=0
        end
        self.timer=0
    else
        self.timer=self.timer+dt
    end
    if piso1==true then 
        if (love.keyboard.wasPressed('space') or love.mouse.wasPressed(1)) then
            if self.dy==0  then
                self.dy = -8
                --self.y = self.y + self.dy
                sounds['jump']:play()
            end
        else
            self.y=yBarra
        end
    elseif (self.sobrePrecipicio==true or (self.y < 252)) then 
        if self.sobrePrecipicio then 
            self.dy=self.dy+ 250 * dt
        else
            self.dy= self.dy + gravedad *dt
        end
     
    elseif self.y>=252 then
        self.dy=0
    end
    --SALTO    
    if (love.keyboard.wasPressed('space') or love.mouse.wasPressed(1)) and piso1==false then
        if self.dy==0  then
            self.dy = -8
            sounds['jump']:play()

        end
    end
    
    self.y = self.y + self.dy

    if self.y > 252 and self.sobrePrecipicio==false then--PARCHE1 PARA QUE NO SE PASE DEL PISO
        if piso==false then
            self.y=252
        end
    elseif self.sobrePrecipicio==true then 
        piso=true
    end

end

function Cuadrado:render()
    love.graphics.draw(self.image, 30, self.y)--puse 30 para que cuando caiga al precipicio no haya tantos errores, probar si no lo rompe a largo plazo

end
