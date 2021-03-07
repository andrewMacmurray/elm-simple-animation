module Utils.UI exposing
    ( activeButton
    , black
    , blue
    , gold
    , group
    , groups
    , large
    , medium
    , regularButton
    , small
    , white
    )

import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font



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



-- Buttons


activeButton : List (Attribute msg) -> String -> Element msg
activeButton attrs label =
    el
        (List.append attrs
            [ pointer
            , Font.color blue
            ]
        )
        (text label)


regularButton : List (Attribute msg) -> msg -> String -> Element msg
regularButton attrs msg label =
    el
        (List.append attrs
            [ onClick msg
            , pointer
            , Font.color black
            ]
        )
        (text label)



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
