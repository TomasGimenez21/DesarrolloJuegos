Precipicio = Class{}

precipicioSpeed = 100

function Precipicio:init()
    self.image=love.graphics.newImage('precipicio.png')
    self.width=self.image:getWidth()
    self.height = self.image:getHeight()
    self.y=VIRTUAL_HEIGHT - self.height
    self.x=VIRTUAL_WIDTH + 32
    self.remove=false
    self.scored=false 
end
function Precipicio:update(dt)
    if self.x > -self.width then--revisar porque se borra antes de tiempo
        self.x = self.x - precipicioSpeed * dt
    else
        self.remove = true
    end    
end
function Precipicio:render()
    
    love.graphics.draw(self.image, self.x, self.y)

end
