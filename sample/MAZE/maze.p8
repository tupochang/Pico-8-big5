pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ヘそとハなあヘよほハななハさせハぬ◆
maze_w = 15
maze_h = 15
playerspr=1
-- ハなあフゆたヘよほハななホ▥こハ☉❎
maze = {}
for y=1, maze_h do
    maze[y] = {}
    for x=1, maze_w do
        maze[y][x] = 1  -- ハ☉えハせ⬅️ハ😐∧ハ✽そホ⬇️そフ🐱むフ웃●ハこ▒
    end
end

time_left = 600

-- フ⬆️かヒ☉…ヘふほホめおハ★😐フふ🐱ホめお
start_x, start_y = 2, 2  -- ヘふほホめおハむせヒそ▥
goal_x, goal_y = maze_w-1, maze_h-1  -- フふ🐱ホめおハむせヒそ▥

-- ノやよフ⬆️そホ▒おヘよひハ☉●ハ웃のヒはˇフ⬆️かヒ☉…ホあそヒたかヘよほハなな
function generate_maze(x, y)
    maze[y][x] = 0  -- ヘそとハなあフˇへハ웃♪ノや♪フやなフ🐱むホ▒⧗ヘほに
    local directions = {{1,0},{-1,0},{0,1},{0,-1}}
    for i=1,4 do
        local r = flr(rnd(4)) + 1
        directions[i], directions[r] = directions[r], directions[i]
    end
    for i=1,4 do
        local dx, dy = directions[i][1], directions[i][2]
        local nx, ny = x + dx*2, y + dy*2
        if nx > 0 and ny > 0 and nx <= maze_w and ny <= maze_h and maze[ny][nx] == 1 then
            maze[y+dy][x+dx] = 0
            generate_maze(nx, ny)
        end
    end
end

function reset_level()
    for y=1, maze_h do
        for x=1, maze_w do
            maze[y][x] = 1
        end
    end
    generate_maze(start_x, start_y)
    player_x, player_y = start_x, start_y
    goal_x, goal_y = maze_w-1, maze_h-1
end

reset_level() 

-- フ🅾️たハなへノや♪フやな
player_x, player_y = start_x, start_y

-- フみちヘこやヘよほハなな
function draw_maze()
    for y=1, maze_h do
        for x=1, maze_w do
            if maze[y][x] == 1 then
               	spr(3,x*8,y*8)
                --rectfill(x*8, y*8, x*8+7, y*8+7, 7)  -- フみちヘこやフ웃●ハこ▒
            end
        end
    end
    spr(2,goal_x*8, goal_y*8)
    --rectfill(goal_x*8, goal_y*8, goal_x*8+7, goal_y*8+7, 11)  -- フみちヘこやフふ🐱ホめおフへきヘ웃のハ♪█ハく⌂
end

-- ヒいひヒ∧ぬフ🅾️たハなへフせめハ⬅️ˇ
function update_player()
    local new_x, new_y = player_x, player_y
    if btnp(0) then new_x -= 1 end  -- ハほす
    if btnp(1) then new_x += 1 end  -- ハ◆は
    if btnp(2) then new_y -= 1 end  -- ノま⌂
    if btnp(3) then new_y += 1 end  -- ノま⬅️
    
    -- ヒちけヒかしフけぬヒ★お
    if new_x > 0 and new_x <= maze_w and new_y > 0 and new_y <= maze_h and maze[new_y][new_x] == 0 then
        player_x, player_y = new_x, new_y
    end
    
   	    -- ヒちけヒかしヒ▤にハ…すハ☉ぬホ▒⬆️フふ🐱ホめお
    if player_x == goal_x and player_y == goal_y then
        time_left += 300  -- ハけおハ⌂き300フせ★
        reset_level()  -- ホ█のハ✽しノま⬅️ノま█ハ█⬅️ヘよほハなな
    end
end


function update_timer()
    if time_left > 0 then
        time_left -= 1
    else
        -- ヒ▥🐱ホ∧⧗ハ☉ぬヤも😐ホ▒⌂ヒ☉のフふ…ヒえか
        game_over = true
    end
end

-- ノまめヒいひヒ∧ぬハ♥やヒˇま
function _update()
    if not game_over then
        update_player()
        update_timer()
    end
end

-- ノまめフみちヘこやハ♥やヒˇま
function _draw()
    cls()
    draw_maze()
    spr(playerspr,player_x*8, player_y*8)
    --rectfill(player_x*8, player_y*8, player_x*8+7, player_y*8+7, 8)  -- フみちヘこやフひ✽ヘ웃のハ♪█ハく⌂ノやうフ🐱むフ🅾️たハなへノや♪フやな
				print("time: "..time_left, 0, 0, 7)

			 if game_over then
        print("game over", 50, 64, 8)
    end
end

__gfx__
00000000700660000444444000b3b3000606060a000ddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000070ff6000449459440b3b33306000569500dddd0d00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700700560004964569433b383b3800677a90dddd70d00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000f6cc60564664566433333b8b806555a90067d70000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700050066c6746645664b33333b3057577a40777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000006605646a456643b8b333306a77a907007700700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666004664566403b333b009aa99500777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c6006804444444400333b0005945000ee7007ee00000000000000000000000000000000000000000000000000000000000000000000000000000000
