module Utils.UI exposing
    ( group
    , groups
    , large
    , medium
    , small
    )

import Element exposing (..)



-- Group


groups : List (Element msg) -> Element msg -> Element msg
groups els controls =
    column
        [ centerX
        , width (fill |> maximum 800)
        , spacing large
        ]
        (controls :: els)


group : String -> Element msg -> Element msg
group label x =
    column [ spacing medium ] [ text label, x ]



-- Spacing


small : number
small =
    14


medium : number
medium =
    24


large : number
large =
    48
