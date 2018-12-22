using Documenter, HTTPA

makedocs(
    modules = [HTTPA],
    sitename = "HTTPA.jl",
    pages = [
             "Home" => "index.md",
             "public_interface.md",
             "internal_architecture.md",
             "internal_interface.md",
             ],
)

deploydocs(
    repo = "github.com/JuliaWeb/HTTPA.jl.git",
)
