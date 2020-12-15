module Utils.Svg exposing (..)

import Svg
import Svg.Attributes exposing (viewBox)


height_ : Float -> String
height_ n =
    "height: " ++ px n


width_ : Float -> String
width_ n =
    "width: " ++ px n


transformOrigin_ : Float -> Float -> String
transformOrigin_ x y =
    "transform-origin: " ++ px x ++ " " ++ px y


viewBox_ : Int -> Int -> Int -> Int -> Svg.Attribute msg
viewBox_ a b c d =
    [ a, b, c, d ]
        |> List.map String.fromInt
        |> String.join " "
        |> viewBox


px : Float -> String
px n =
    String.fromFloat n ++ "px"
