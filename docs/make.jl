using FLPAccumbensRaphe
using Documenter

DocMeta.setdocmeta!(FLPAccumbensRaphe, :DocTestSetup, :(using FLPAccumbensRaphe); recursive=true)

makedocs(;
    modules=[FLPAccumbensRaphe],
    authors="Dario",
    repo="https://github.com/DarioSarra/FLPAccumbensRaphe.jl/blob/{commit}{path}#{line}",
    sitename="FLPAccumbensRaphe.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://DarioSarra.github.io/FLPAccumbensRaphe.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/DarioSarra/FLPAccumbensRaphe.jl",
    devbranch="main",
)
