module GameOfLife
using Plots

mutable struct Life
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function step!(state::Life)
    curr = state.current_frame
    next = state.next_frame
    n, m = size(curr)  
    for y in 1:n
        for x in 1:m
            neighbors = 0
            for yS in (y-1):(y+1)
                for xS in (x-1):(x+1)
                    if !(yS == y && xS == x)  
                        neighbors += curr[mod1(yS, n), mod1(xS, m)]
                    end
                end
            end
            if curr[y, x] == 1
                next[y, x] = (neighbors == 2 || neighbors == 3) ? 1 : 0
            else
                next[y, x] = (neighbors == 3) ? 1 : 0
            end
        end
    end
    state.current_frame .= state.next_frame

    return nothing
end


function (@main)(ARGS)
    n = 30
    m = 30
    init = rand(0:1, n, m)

    game = Life(init, zeros(n, m))

    anim = @animate for time = 1:100
        step!(game)
        cr = game.current_frame
        heatmap(cr)
    end
    gif(anim, "life.gif", fps = 10)
end

export main

end

using .GameOfLife
GameOfLife.main("")


