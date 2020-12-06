module Simple.Animation exposing
    ( Animation, Millis, fromTo, steps
    , Option, loop, linear
    , step, wait
    )

{-| Create an Animation

@docs Animation, Millis, fromTo, steps


# Options

@docs Option, loop, linear

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


type Steps
    = Steps (List Option) (List Property) (List Step)


type Step
    = Step Millis (List Property)
    | Wait Millis
    | WaitTillComplete Millis



-- From To Animation


{-| -}
fromTo : Millis -> List Option -> List Property -> List Property -> Animation
fromTo duration options from_ to_ =
    Steps options from_ [ step duration to_ ] |> toAnimation



-- Steps


{-| -}
steps : List Option -> List Property -> List Step -> Animation
steps options firstFrame steps_ =
    Steps options firstFrame steps_ |> toAnimation



-- Step


step : Millis -> List Property -> Step
step =
    Step


wait : Millis -> Step
wait =
    Wait


waitTillComplete : Animation -> Step
waitTillComplete =
    Internal.duration_ >> WaitTillComplete


set : List Property -> Step
set =
    Step 1


toAnimation : Steps -> Animation
toAnimation (Steps opts firstFrame nextFrames) =
    Internal.animation (totalDuration nextFrames) (toStepFrames firstFrame nextFrames :: opts)


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


toStepFrames : List Property -> List Step -> Option
toStepFrames firstFrame nextFrames =
    Internal.frames (toFrames firstFrame nextFrames)


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
linear : Option
linear =
    Internal.linear
