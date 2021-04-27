Ball = Class{}


function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.dx = 0

end

function Ball:update(dt)
    self.x = self.x + self.dx * dt--se que hace no se muy biien para que 
    self.y = self.y + self.dy * dt
end

function Ball:colisionBall(barra)
    if self.x > barra.x + barra.width or barra.x > self.x + self.width then
        return false
    end

    if self.y > barra.y + barra.height or barra.y > self.y + self.height then
        return false
    end 

    return true
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2-- creo que hay que saber push pero esto hay que cambiarlo por virtual no window 
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end