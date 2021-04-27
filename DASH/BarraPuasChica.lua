BarraPuasChica = Class{}

function BarraPuasChica:init(y)
    self.image=love.graphics.newImage('BarraPuasChicaTurqueza.png')
    self.width=self.image:getWidth()
    self.height = self.image:getHeight()
    self.y=y
    self.x=VIRTUAL_WIDTH + 32
    self.remove=false
    self.scored=false 
end
function BarraPuasChica:update(dt)
    if self.x > -self.width then
        self.x = self.x - precipicioSpeed * dt
    else
        self.remove = true
    end    
end
function BarraPuasChica:render()
    
    love.graphics.draw(self.image, self.x, self.y)

end