module Boids

using Plots
using Random
using LinearAlgebra

mutable struct Boid
    position::Tuple{Float64, Float64}
    velocity::Tuple{Float64, Float64}
    acceleration::Tuple{Float64, Float64}
    vision_radius::Float64
end

function create_boid(width, height)
    position = (rand() * width, rand() * height)
    velocity = (rand(-1.0:1.0), rand(-1.0:1.0))
    acceleration = (0.0, 0.0)
    vision_radius = rand(1:30)
    return Boid(position, velocity, acceleration, vision_radius)
end

mutable struct WorldState
    boids::Vector{Boid}
    height::Float64
    width::Float64
    function WorldState(n_boids, width, height)
        boids = [create_boid(width, height) for _ in 1:n_boids]
        return new(boids, height, width)
    end
end

function alignment_force(boid::Boid, boids::Vector{Boid})
    avg_velocity = [0.0, 0.0]
    total = 0
    for other in boids
        if other !== boid
            dx = other.position[1] - boid.position[1]
            dy = other.position[2] - boid.position[2]
            dist = sqrt(dx^2 + dy^2)
            if dist < boid.vision_radius
                avg_velocity .+= [other.velocity[1], other.velocity[2]]
                total += 1
            end
        end
    end

    if total > 0
        avg_velocity ./= total
        force = (avg_velocity .- [boid.velocity[1], boid.velocity[2]]) ./ total
        return (force[1], force[2])
    else
        return (0.0, 0.0)
    end
end

function cohesion_force(boid::Boid, boids::Vector{Boid})
    avg_position = [0.0, 0.0]
    total = 0
    for other in boids
        if other !== boid
            dx = other.position[1] - boid.position[1]
            dy = other.position[2] - boid.position[2]
            dist = sqrt(dx^2 + dy^2)
            if dist < boid.vision_radius
                avg_position .+= [other.position[1], other.position[2]]
                total += 1
            end
        end
    end

    if total > 0
        avg_position ./= total 
        force = ((avg_position[1] - boid.position[1]) / total, 
                 (avg_position[2] - boid.position[2]) / total)
        return force
    else
        return (0.0, 0.0)
    end
end

function separation_force(boid::Boid, boids::Vector{Boid})
    separation_vector = [0.0, 0.0]
    total = 0
    for other in boids
        if other !== boid
            dx = boid.position[1] - other.position[1]
            dy = boid.position[2] - other.position[2]
            dist = sqrt(dx^2 + dy^2)
            if dist < boid.vision_radius
                separation_vector .+= [dx, dy] / dist 
                total += 1
            end
        end
    end

    if total > 0
        separation_vector ./= total  
        return separation_vector
    else
        return (0.0, 0.0)
    end
end


function update!(state::WorldState)
    for boid in state.boids
        force_separation = separation_force(boid, state.boids)
        force = alignment_force(boid, state.boids)
        force_cohesion = cohesion_force(boid, state.boids)

        new_velocity = (boid.velocity[1] + boid.acceleration[1] + force[1] + force_cohesion[1] + force_separation[1],
                        boid.velocity[2] + boid.acceleration[2] + force[2] + force_cohesion[2] + force_separation[2])

        if boid.position[1] <= 0 || boid.position[1] >= state.width
            new_velocity = (-new_velocity[1], new_velocity[2])
        end
        if boid.position[2] <= 0 || boid.position[2] >= state.height
            new_velocity = (new_velocity[1], -new_velocity[2])
        end

        new_position = (boid.position[1] + new_velocity[1],
            boid.position[2] + new_velocity[2])

        new_position = (clamp(new_position[1], 0, state.width),
            clamp(new_position[2], 0, state.height))

        boid.velocity = new_velocity
        boid.position = new_position
    end
end

function (@main)(ARGS)
    w = 100
    h = 100
    n_boids = 30

    state = WorldState(n_boids, w, h)

    anim = @animate for time = 1:100
        update!(state)
        x = [b.position[1] for b in state.boids]
        y = [b.position[2] for b in state.boids]
        scatter(x, y, xlim=(0, state.width), ylim=(0, state.height))
    end

    gif(anim, "boids.gif", fps = 10)
end

export main

end

using .Boids
Boids.main("")
