module Internal.Ease exposing (Ease(..), name, render)


type Ease
    = Cubic Float Float Float Float
    | Linear
    | EaseIn
    | EaseOut
    | EaseInOut
    | Default


render : Ease -> String
render e =
    case e of
        Cubic a b c d ->
            "cubic-bezier("
                ++ String.join ","
                    [ String.fromFloat a
                    , String.fromFloat b
                    , String.fromFloat c
                    , String.fromFloat d
                    ]
                ++ ")"

        Linear ->
            "linear"

        EaseIn ->
            "ease-in"

        EaseOut ->
            "ease-out"

        EaseInOut ->
            "ease-in-out"

        Default ->
            "ease"


name : Ease -> String
name e =
    case e of
        Cubic a b c d ->
            "cubic" ++ String.fromInt (round (a + b + c + d))

        Linear ->
            "linear"

        EaseIn ->
            "ease-in"

        EaseOut ->
            "ease-out"

        EaseInOut ->
            "ease-in-out"

        Default ->
            "ease"
