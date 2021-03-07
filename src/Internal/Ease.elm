module Internal.Ease exposing
    ( Ease(..)
    , easeInBack
    , easeInCirc
    , easeInCubic
    , easeInExpo
    , easeInOutBack
    , easeInOutCirc
    , easeInOutCubic
    , easeInOutExpo
    , easeInOutQuad
    , easeInOutQuart
    , easeInOutQuint
    , easeInOutSine
    , easeInQuad
    , easeInQuart
    , easeInQuint
    , easeInSine
    , easeOutBack
    , easeOutCirc
    , easeOutCubic
    , easeOutExpo
    , easeOutQuad
    , easeOutQuart
    , easeOutQuint
    , easeOutSine
    , toString
    )

-- Ease


type Ease
    = Cubic Float Float Float Float
    | Linear
    | Ease
    | EaseIn
    | EaseOut
    | EaseInOut



-- Extended Eases


easeInSine : Ease
easeInSine =
    Cubic 0.12 0 0.39 0


easeOutSine : Ease
easeOutSine =
    Cubic 0.61 1 0.88 1


easeInOutSine : Ease
easeInOutSine =
    Cubic 0.37 0 0.63 1


easeInQuad : Ease
easeInQuad =
    Cubic 0.11 0 0.5 0


easeOutQuad : Ease
easeOutQuad =
    Cubic 0.5 1 0.89 1


easeInOutQuad : Ease
easeInOutQuad =
    Cubic 0.45 0 0.55 1


easeInCubic : Ease
easeInCubic =
    Cubic 0.32 0 0.67 0


easeOutCubic : Ease
easeOutCubic =
    Cubic 0.33 1 0.68 1


easeInOutCubic : Ease
easeInOutCubic =
    Cubic 0.65 0 0.35 1


easeInQuart : Ease
easeInQuart =
    Cubic 0.5 0 0.75 0


easeOutQuart : Ease
easeOutQuart =
    Cubic 0.25 1 0.5 1


easeInOutQuart : Ease
easeInOutQuart =
    Cubic 0.76 0 0.24 1


easeInQuint : Ease
easeInQuint =
    Cubic 0.64 0 0.78 0


easeOutQuint : Ease
easeOutQuint =
    Cubic 0.22 1 0.36 1


easeInOutQuint : Ease
easeInOutQuint =
    Cubic 0.83 0 0.17 1


easeInExpo : Ease
easeInExpo =
    Cubic 0.7 0 0.84 0


easeOutExpo : Ease
easeOutExpo =
    Cubic 0.16 1 0.3 1


easeInOutExpo : Ease
easeInOutExpo =
    Cubic 0.87 0 0.13 1


easeInCirc : Ease
easeInCirc =
    Cubic 0.55 0 1 0.45


easeOutCirc : Ease
easeOutCirc =
    Cubic 0 0.55 0.45 1


easeInOutCirc : Ease
easeInOutCirc =
    Cubic 0.85 0 0.15 1


easeInBack : Ease
easeInBack =
    Cubic 0.36 0 0.66 -0.56


easeOutBack : Ease
easeOutBack =
    Cubic 0.34 1.56 0.64 1


easeInOutBack : Ease
easeInOutBack =
    Cubic 0.68 -0.6 0.32 1.6



-- To String


toString : Ease -> String
toString e =
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

        Ease ->
            "ease"

        EaseIn ->
            "ease-in"

        EaseOut ->
            "ease-out"

        EaseInOut ->
            "ease-in-out"
