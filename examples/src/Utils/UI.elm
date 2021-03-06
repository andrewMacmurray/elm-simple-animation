module Utils.UI exposing
    ( black
    , blue
    , gold
    , group
    , groups
    , large
    , medium
    , small
    , white
    )

import Element exposing (..)



-- Color


blue : Color
blue =
    rgb255 36 107 238


black : Color
black =
    rgb255 24 24 24


gold : Color
gold =
    rgb255 255 221 46


white : Color
white =
    rgb255 255 255 255



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
    column [ spacing medium, width fill ] [ text label, x ]



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
