module Boids
using Plots
using Random

mutable struct WorldState
    boids::Vector{Tuple{Float64, Float64}}
    height::Float64
    width::Float64
    function WorldState(n_boids, width, height)
        n_boids=40
        boids = [(rand() * width, rand() * height) for _ in 1:n_boids]  
        new(boids, width, height)
    end
end

function update!(state::WorldState)
    for i in eachindex(state.boids)
        state.boids[i] = (state.boids[i][1] + 0.1,  
                          state.boids[i][2] + 0.1)  
    end
    # TODO: реализация уравнения движения птичек

    return nothing
end

function (@main)(ARGS)
    w = 30
    h = 30
    n_boids = 10

    state = WorldState(n_boids, w, h)

    anim = @animate for time = 1:100
        update!(state)
        x = [b[1] for b in state.boids]
        y = [b[2] for b in state.boids]
        scatter(x,y, xlim = (0, state.width), ylim = (0, state.height))
    end
    gif(anim, "boids.gif", fps = 10)
end

export main

end

using .Boids
Boids.main("")
