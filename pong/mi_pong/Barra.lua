Barra = Class{}

function Barra:init(x, y, width, height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height
    self.dy=10
    self.puntaje=0
end

function Barra:update(dt)
    --[[if self.y >= 0 then
        
    else if self.y > 
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
    --]]
end

function Barra:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

