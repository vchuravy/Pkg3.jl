module Pkg3

const DEPOTS = [joinpath(homedir(), ".julia")]
depots() = DEPOTS

# load snapshotted dependencies
include("../ext/TOML/src/TOML.jl")
include("../ext/TerminalMenus/src/TerminalMenus.jl")

include("Types.jl")
include("Display.jl")
include("Operations.jl")
include("REPLMode.jl")

function __init__()
    push!(empty!(LOAD_PATH), dirname(dirname(@__DIR__)))
    isdefined(Base, :active_repl) && REPLMode.repl_init(Base.active_repl)
end

function Base.julia_cmd(julia::AbstractString)
    cmd = invoke(Base.julia_cmd, Tuple{Any}, julia)
    push!(cmd.exec, "-L$(abspath(@__DIR__, "require.jl"))")
    return cmd
end

function find_package(name::String)
    endswith(name, ".jl") && (name = name[1:end-3])
    env = Pkg3.Types.EnvCache()
    if haskey(env.manifest, name)
        infos = env.manifest[name]
        if length(infos) < 1
            return nothing
        elseif length(infos) == 1
            info = infos[1]
        else
            
        end
    end
    return nothing
end

if VERSION < v"0.6"
    error("Julia $VERSION not supported, at least version 0.6 is required.")
elseif VERSION < v"0.7-"
    # hook into old find_in_path API, which is very weird and broken:
    Base.find_in_path(name::String, ::Void) = find_package(name)
    Base.find_in_path(name::String) = nothing
else
    error("Julia $VERSION not yet supported.")
end

end # module
