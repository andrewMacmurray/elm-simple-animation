module Simple.Animation exposing
    ( Animation, Millis, fromTo, steps
    , step, set, wait, waitTillComplete
    , Option, loop, delay
    , linear, easeIn, easeOut, easeInOut, cubic
    , easeInSine, easeOutSine, easeInOutSine, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic, easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint, easeOutQuint, easeInOutQuint, easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc, easeInBack, easeOutBack, easeInOutBack
    , duration
    )

{-|


# Create an Animation

@docs Animation, Millis, fromTo, steps


# Steps

@docs step, set, wait, waitTillComplete


# Options

@docs Option, loop, delay


# Standard Eases

Standard CSS eases

@docs linear, easeIn, easeOut, easeInOut, cubic


# Extended Eases

See what these eases look and feel like: <https://easings.net>

@docs easeInSine, easeOutSine, easeInOutSine, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic, easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint, easeOutQuint, easeInOutQuint, easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc, easeInBack, easeOutBack, easeInOutBack


# Duration

@docs duration

-}

import Internal.Animation as Internal exposing (..)
import Simple.Animation.Property exposing (Property)


{-| -}
type alias Animation =
    Internal.Animation


{-| -}
type alias Millis =
    Int


{-| -}
type alias Option =
    Internal.Option



-- Stepped Animation


type Stepped
    = Stepped
        { options : List Option
        , startAt : List Property
        , steps : List Step
        }


type Step
    = Step Millis (List Property)
    | Wait Millis
    | WaitTillComplete Animation



-- From To Animation


{-| -}
fromTo : { duration : Millis, options : List Option } -> List Property -> List Property -> Animation
fromTo o from_ to_ =
    toAnimation
        (Stepped
            { options = o.options
            , startAt = from_
            , steps = [ step o.duration to_ ]
            }
        )



-- Steps


{-| -}
steps : { startAt : List Property, options : List Option } -> List Step -> Animation
steps { options, startAt } steps_ =
    toAnimation
        (Stepped
            { options = options
            , startAt = startAt
            , steps = steps_
            }
        )



-- Step


{-| -}
step : Millis -> List Property -> Step
step =
    Step


{-| -}
set : List Property -> Step
set =
    Step 1


{-| -}
wait : Millis -> Step
wait =
    Wait


{-| -}
waitTillComplete : Animation -> Step
waitTillComplete =
    WaitTillComplete


toAnimation : Stepped -> Animation
toAnimation (Stepped s) =
    Animation (totalDuration s.steps) s.options (toFrames s.startAt s.steps)


totalDuration : List Step -> Millis
totalDuration =
    List.foldl accumDuration 0


accumDuration : Step -> Millis -> Millis
accumDuration step_ curr =
    case step_ of
        Step d _ ->
            d + curr

        Wait d ->
            d + curr

        WaitTillComplete anim ->
            adjustCompleteWait anim curr


adjustCompleteWait : Animation -> Millis -> Millis
adjustCompleteWait anim timePassed =
    let
        duration_ =
            duration anim
    in
    if duration_ - timePassed >= 1 then
        duration_

    else
        timePassed + 1


toFrames : List Property -> List Step -> List Internal.Frame
toFrames firstFrame steps_ =
    let
        percentPerMs =
            100 / toFloat (totalDuration steps_)

        getFrame f ( n, xs, cur ) =
            case f of
                Step d props ->
                    ( n + d
                    , xs ++ [ cur ]
                    , Frame (percentPerMs * toFloat (n + d)) props
                    )

                Wait d ->
                    ( n + d
                    , xs ++ [ cur ]
                    , Frame (percentPerMs * toFloat (n + d)) (frameProps cur)
                    )

                WaitTillComplete d ->
                    let
                        dur =
                            adjustCompleteWait d n
                    in
                    ( dur
                    , xs ++ [ cur ]
                    , Frame (percentPerMs * toFloat dur) (frameProps cur)
                    )
    in
    List.foldl getFrame ( 0, [], Frame 0 firstFrame ) steps_
        |> (\( _, xs, curr ) -> xs ++ [ curr ])


frameProps : Frame -> List Property
frameProps (Frame _ props) =
    props


{-| -}
loop : Option
loop =
    Iteration Loop


{-| -}
delay : Millis -> Option
delay =
    Delay



-- Standard Eases


{-| -}
linear : Option
linear =
    Ease Linear


{-| -}
easeIn : Option
easeIn =
    Ease EaseIn


{-| -}
easeOut : Option
easeOut =
    Ease EaseOut


{-| -}
easeInOut : Option
easeInOut =
    Ease EaseInOut


{-| -}
cubic : Float -> Float -> Float -> Float -> Option
cubic a b c d =
    Ease (Cubic a b c d)



-- Extended Eases


{-| -}
easeInSine : Option
easeInSine =
    cubic 0.12 0 0.39 0


{-| -}
easeOutSine : Option
easeOutSine =
    cubic 0.61 1 0.88 1


{-| -}
easeInOutSine : Option
easeInOutSine =
    cubic 0.37 0 0.63 1


{-| -}
easeInQuad : Option
easeInQuad =
    cubic 0.11 0 0.5 0


{-| -}
easeOutQuad : Option
easeOutQuad =
    cubic 0.5 1 0.89 1


{-| -}
easeInOutQuad : Option
easeInOutQuad =
    cubic 0.45 0 0.55 1


{-| -}
easeInCubic : Option
easeInCubic =
    cubic 0.32 0 0.67 0


{-| -}
easeOutCubic : Option
easeOutCubic =
    cubic 0.33 1 0.68 1


{-| -}
easeInOutCubic : Option
easeInOutCubic =
    cubic 0.65 0 0.35 1


{-| -}
easeInQuart : Option
easeInQuart =
    cubic 0.5 0 0.75 0


{-| -}
easeOutQuart : Option
easeOutQuart =
    cubic 0.25 1 0.5 1


{-| -}
easeInOutQuart : Option
easeInOutQuart =
    cubic 0.76 0 0.24 1


{-| -}
easeInQuint : Option
easeInQuint =
    cubic 0.64 0 0.78 0


{-| -}
easeOutQuint : Option
easeOutQuint =
    cubic 0.22 1 0.36 1


{-| -}
easeInOutQuint : Option
easeInOutQuint =
    cubic 0.83 0 0.17 1


{-| -}
easeInExpo : Option
easeInExpo =
    cubic 0.7 0 0.84 0


{-| -}
easeOutExpo : Option
easeOutExpo =
    cubic 0.16 1 0.3 1


{-| -}
easeInOutExpo : Option
easeInOutExpo =
    cubic 0.87 0 0.13 1


{-| -}
easeInCirc : Option
easeInCirc =
    cubic 0.55 0 1 0.45


{-| -}
easeOutCirc : Option
easeOutCirc =
    cubic 0 0.55 0.45 1


{-| -}
easeInOutCirc : Option
easeInOutCirc =
    cubic 0.85 0 0.15 1


{-| -}
easeInBack : Option
easeInBack =
    cubic 0.36 0 0.66 -0.56


{-| -}
easeOutBack : Option
easeOutBack =
    cubic 0.34 1.56 0.64 1


{-| -}
easeInOutBack : Option
easeInOutBack =
    cubic 0.68 -0.6 0.32 1.6



-- Other


{-| -}
duration : Animation -> Millis
duration =
    Internal.duration_
