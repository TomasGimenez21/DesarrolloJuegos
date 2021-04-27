Coin = Class{}

function Coin:init(y)
    self.y=y
    self.x=VIRTUAL_WIDTH + 32
    self.image=love.graphics.newImage('coin.png')
    self.width=self.image:getWidth()
    self.height=self.image:getHeight()
    self.scored=false
    self.removed=false
end
function Coin:update(dt)
    if self.x > -self.width then
        self.x = self.x - precipicioSpeed * dt
    else
        self.remove = true
    end  
end
function Coin:render()
    love.graphics.draw(self.image, self.x, self.y)
end