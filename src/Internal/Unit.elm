module Internal.Unit exposing
    ( Millis
    , ms
    , pc
    )


type alias Millis =
    Int


ms : Int -> String
ms n =
    String.fromInt n ++ "ms"


pc : Float -> String
pc n =
    String.fromFloat n ++ "%"
