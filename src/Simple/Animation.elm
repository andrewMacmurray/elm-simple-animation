module Simple.Animation exposing
    ( Animation, Millis, fromTo, steps
    , step, set, wait, waitTillComplete
    , Option, loop, delay
    , linear, zippy, cubic
    , duration, zippy2
    )

{-|


# Create an Animation

@docs Animation, Millis, fromTo, steps


# Steps

@docs step, set, wait, waitTillComplete


# Options

@docs Option, loop, delay


# Eases

@docs linear, zippy, cubic

-}

import Internal.Animation as Internal
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
    = Stepped (List Option) (List Property) (List Step)


type Step
    = Step Millis (List Property)
    | Wait Millis
    | WaitTillComplete Millis



-- From To Animation


{-| -}
fromTo : { duration : Millis, options : List Option } -> List Property -> List Property -> Animation
fromTo o from_ to_ =
    Stepped o.options from_ [ step o.duration to_ ] |> toAnimation



-- Steps


{-| -}
steps : { startAt : List Property, options : List Option } -> List Step -> Animation
steps { options, startAt } steps_ =
    Stepped options startAt steps_ |> toAnimation



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
    Internal.duration_ >> WaitTillComplete


toAnimation : Stepped -> Animation
toAnimation (Stepped opts firstFrame nextFrames) =
    Internal.animation (totalDuration nextFrames) opts (toFrames firstFrame nextFrames)


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

        WaitTillComplete d ->
            adjustCompleteWait d curr


adjustCompleteWait : number -> number -> number
adjustCompleteWait dur curr =
    if dur - curr >= 1 then
        curr + (dur - curr)

    else
        curr + 1


toFrames : List Property -> List Step -> List Internal.Frame
toFrames firstFrame fx =
    let
        percentPerMs =
            100 / toFloat (totalDuration fx)

        getFrame f ( n, xs, cur ) =
            case f of
                Step d props ->
                    ( n + d, xs ++ [ cur ], Internal.frame (percentPerMs * toFloat (n + d)) props )

                Wait d ->
                    ( n + d, xs ++ [ cur ], Internal.frame (percentPerMs * toFloat (n + d)) (frameProps cur) )

                WaitTillComplete d ->
                    let
                        dur =
                            adjustCompleteWait d n
                    in
                    ( dur, xs ++ [ cur ], Internal.frame (percentPerMs * toFloat dur) (frameProps cur) )
    in
    List.foldl getFrame ( 0, [], Internal.frame 0 firstFrame ) fx
        |> (\( _, xs, curr ) -> xs ++ [ curr ])


frameProps : Internal.Frame -> List Property
frameProps =
    Internal.frameProperties


{-| -}
loop : Option
loop =
    Internal.loop


{-| -}
delay : Millis -> Option
delay =
    Internal.delay



-- Eases


{-| -}
linear : Option
linear =
    Internal.linear


{-| -}
zippy : Option
zippy =
    cubic 0.3 0.66 0 1.18


zippy2 : Option
zippy2 =
    cubic 0.38 0.57 0 1.5


{-| -}
cubic : Float -> Float -> Float -> Float -> Option
cubic =
    Internal.cubic



-- Other


{-| -}
duration : Animation -> Millis
duration =
    Internal.duration_
