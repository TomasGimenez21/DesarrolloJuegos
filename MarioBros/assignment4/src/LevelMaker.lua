--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}
llaveGlobal = false
function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local abierto = false

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(1,20)
    local topperset = math.random(1,20)

    local lockPos = math.random(width-32)
    local keyPos = math.random(1, width-40)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end
        if x==1 then
            llaveGlobal=false
        end
        -- chance to just be emptiness
        local z =math.random(7)
        if z == 1 and x ~= 1 and lockPos~=z then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 and keyPos~=x then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 and keyPos~=x then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            if x==keyPos then
                local key = GameObject {
                    texture = 'keys_and_locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight + 1) * TILE_SIZE - 4,
                    width = 16,
                    height = 16,
                    frame = math.random(4),
                    collidable = true,
                    consumable = true,
                    solid = false,

                    -- gem has its own function to add to the player's score
                    onConsume = function(player, object)
                        gSounds['pickup']:play()
                        player.llave=true
                        llaveGlobal = true
                    end
                }
                table.insert(objects, key)
            end
            if lockPos == x then 
                local lock = GameObject {
                        texture = 'keys_and_locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(5, 8),
                        collidable = true,
                        hit = false,
                        solid = true,
                        -- collision function takes itself
                        onCollide = function(obj)
                            if llaveGlobal then
                                obj.hit=true
                                gSounds['pickup']:play()  
                                obj.open=true
                                abierto = true 
                                local bandera = GameObject{
                                    texture = 'Banderita',
                                    x =(width - 1) * TILE_SIZE,
                                    y = 5 * TILE_SIZE,
                                    width = 16,
                                    height = 10,
                                    frame = 8,
                                    collidable = true,
                                    hit = false,
                                    solid = false,
                                    consumable = true,
                                    onConsume = function(obj)
                                        gStateMachine:change('play'--[[, {score = player.score+2000, lastLevelWidth = width}]])
                                    end
                                }
                                local poste = GameObject{
                                    texture = 'poste',
                                    x = (width - 1) * TILE_SIZE,
                                    y = 3 * TILE_SIZE,
                                    width = 8,
                                    height = 48,
                                    frame = 3,
                                    collidable = true,
                                    hit = false,
                                    solid = false,
                                    onCollide = function(obj)
                                        Timer.tween(2,{[bandera] = {y=(blockHeight-4)*TILE_SIZE+4}})
                                    end
                                }
                                table.insert(objects, bandera)
                                table.insert(objects, poste)
                            end
                        end
                    }
                table.insert(objects, lock
                )
            end
            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end

    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end
