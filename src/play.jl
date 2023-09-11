using CSV, DataFrames, CategoricalArrays
using BrowseTables, StatsPlots
import StatsBase: mean, std, sem, quantile
##
experiment = "DRN_Opto_again" #DRN_Nac_Sert_ChR2
pokes = CSV.read(joinpath(@__DIR__,"data","pokes" * experiment * ".csv"),DataFrame, missingstring=["NA", "NAN", "NULL"])
bouts = CSV.read(joinpath(@__DIR__,"data","bouts" * experiment * ".csv"),DataFrame, missingstring=["NA", "NAN", "NULL"])
streaks = CSV.read(joinpath(@__DIR__,"data","streaks" * experiment * ".csv"),DataFrame, missingstring=["NA", "NAN", "NULL"])
fibre_location = CSV.read(joinpath(@__DIR__,"data","FiberLocation.csv"),DataFrame, missingstring=["NA", "NAN", "NULL"])
##
open_html_table(streaks[1:100,:])

df = combine(groupby(streaks,[:Day]), :Protocol => x-> [unique(x)], :Wall => x-> [unique(x)])
open_html_table(df)

extrema(skipmissing(streaks.Streak_within_Block))

for df in [pokes, bouts, streaks]
    df[!, :Protocol] = levels!(categorical(df.Protocol), ["90/90","90/30","45/15","30/30"])
end
ismissing(missing)
for df in [bouts, streaks]
    filter!(r-> r.Protocol_Day >=3 &&
    r.Day >= 20190104 &&
    (ismissing(r.Pre_Interpoke) ? true : r.Pre_Interpoke < 3) &&
    r.Protocol in ["90/90","90/30","30/30"] &&
    r.Correct_start &&
    3 < r.Streak_within_Block <15,
    df
    )
end


AL_streaks_m = combine(groupby(streaks,[:Protocol,:Wall,:Gen, :MouseID]), 
    :AfterLast => mean => :AfterLast)
AL_streaks_g = combine(groupby(streaks,[:Protocol,:Wall,:Gen]), 
    :AfterLast => mean => :m_AfterLast,
    :AfterLast => sem => :e_AfterLast,
)
@df AL_streaks_g groupedbar(:Protocol, :m_AfterLast, 
    yerror = :e_AfterLast,  group = (:Gen,:Wall))

unique(streaks.MouseID)
df1 = combine(groupby(streaks, :MouseID), :Gen => union)
open_html_table(df1)
df2 = combine(groupby(df1,:Gen_union), nrow)