module Simple.Animation exposing
    ( Animation, Millis, fromTo, steps, empty
    , Step, step, set, wait, waitTillComplete
    , Option, loop, count, delay
    , linear, easeIn, easeOut, easeInOut, cubic
    , easeInSine, easeOutSine, easeInOutSine, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic, easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint, easeOutQuint, easeInOutQuint, easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc, easeInBack, easeOutBack, easeInOutBack
    , duration
    )

{-| Build an Animation for rendering on the page


# Create an Animation

@docs Animation, Millis, fromTo, steps


# Steps

Build up a multi step animation

@docs Step, step, set, wait, waitTillComplete

# Empty

Build an Animation that does nothing.

@docs empty


# Options

Customise the feel and behaviour of an animation

@docs Option, loop, count, delay


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
import Internal.Ease as Ease
import Internal.Unit as Unit
import Simple.Animation.Property exposing (Property)


{-| Animation to be rendered with `Simple.Animation.Animated` functions
-}
type alias Animation =
    Internal.Animation


{-| Time unit for all Animations
-}
type alias Millis =
    Unit.Millis


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


{-| -}
type Step
    = Step Millis (List Property)
    | Wait Millis
    | WaitTillComplete Animation



-- From To Animation


{-| Create an animation with `start` and `end` properties:

    import Simple.Animation as Animation exposing (Animation)
    import Simple.Animation.Property as P

    fadeOut : Animation
    fadeOut =
        Animation.fromTo
            { duration = 1000
            , options = []
            }
            [ P.opacity 1 ]
            [ P.opacity 0 ]

-}
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


{-| Create an animation with multiple steps:

    import Simple.Animation as Animation exposing (Animation)
    import Simple.Animation.Property as P

    backAndForth : Animation
    backAndForth =
        Animation.steps
            { startAt = [ P.x 0 ]
            , options = []
            }
            [ Animation.step 1000 [ P.x 100 ]
            , Animation.step 1000 [ P.x 0 ]
            ]

-}
steps : { startAt : List Property, options : List Option } -> List Step -> Animation
steps { options, startAt } steps_ =
    toAnimation
        (Stepped
            { options = options
            , startAt = startAt
            , steps = steps_
            }
        )

{-| Create an empty animation:
    emptyAnimation : Animation
    enptyAnimation =
        Animation.empty
-}
empty : Animation
empty =
    toAnimation
        (Stepped
            { options = []
            , startAt = []
            , steps   = []
            }
        )

-- Step


{-| Animate to a list of properties for a given number of `milliseconds`:

    Animation.step 1000 [ P.opacity 1 ]

-}
step : Millis -> List Property -> Step
step =
    Step


{-| Set a list of properties immediately in an animation (This is equivalent to `step 1`):

    Animation.set [ P.opacity 0 ]

-}
set : List Property -> Step
set =
    Step 1


{-| Wait for a given number of `milliseconds` before animating the next properties:

    Animation.wait 1000

-}
wait : Millis -> Step
wait =
    Wait


{-| Wait for another animation to complete before animating the next properties:

This animation will `wait` for `1500` milliseconds before animating to the next step

    import Simple.Animation as Animation exposing (Animation)
    import Simple.Animation.Property as P

    finishAfterFadeOut : Animation
    finishAfterFadeOut =
        Animation.steps
            { startAt = [ P.x 0 ]
            , options = []
            }
            [ Animation.step 500 [ P.x 20 ]
            , Animation.waitTillComplete fadeOut
            , Animation.step 500 [ P.x 60 ]
            ]

    fadeOut : Animation
    fadeOut =
        Animation.fromTo
            { duration = 2000
            , options = []
            }
            [ P.opacity 1 ]
            [ P.opacity 2 ]

-}
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


{-| Repeat an animation forever
-}
loop : Option
loop =
    Iteration Loop


{-| Play an animation a given number of times
-}
count : Int -> Option
count =
    Iteration << Count


{-| Delay the start of an animation (repeats like `loop` or `count` are not affected by this)
-}
delay : Millis -> Option
delay =
    Delay



-- Standard Eases


{-| -}
linear : Option
linear =
    Ease Ease.Linear


{-| -}
easeIn : Option
easeIn =
    Ease Ease.EaseIn


{-| -}
easeOut : Option
easeOut =
    Ease Ease.EaseOut


{-| -}
easeInOut : Option
easeInOut =
    Ease Ease.EaseInOut


{-| -}
cubic : Float -> Float -> Float -> Float -> Option
cubic a b c d =
    Ease (Ease.Cubic a b c d)



-- Extended Eases


{-| -}
easeInSine : Option
easeInSine =
    Ease Ease.easeInSine


{-| -}
easeOutSine : Option
easeOutSine =
    Ease Ease.easeOutSine


{-| -}
easeInOutSine : Option
easeInOutSine =
    Ease Ease.easeInOutSine


{-| -}
easeInQuad : Option
easeInQuad =
    Ease Ease.easeInQuad


{-| -}
easeOutQuad : Option
easeOutQuad =
    Ease Ease.easeOutQuad


{-| -}
easeInOutQuad : Option
easeInOutQuad =
    Ease Ease.easeInOutQuad


{-| -}
easeInCubic : Option
easeInCubic =
    Ease Ease.easeInCubic


{-| -}
easeOutCubic : Option
easeOutCubic =
    Ease Ease.easeOutCubic


{-| -}
easeInOutCubic : Option
easeInOutCubic =
    Ease Ease.easeInOutCubic


{-| -}
easeInQuart : Option
easeInQuart =
    Ease Ease.easeInQuart


{-| -}
easeOutQuart : Option
easeOutQuart =
    Ease Ease.easeOutQuart


{-| -}
easeInOutQuart : Option
easeInOutQuart =
    Ease Ease.easeInOutQuart


{-| -}
easeInQuint : Option
easeInQuint =
    Ease Ease.easeInQuint


{-| -}
easeOutQuint : Option
easeOutQuint =
    Ease Ease.easeOutQuint


{-| -}
easeInOutQuint : Option
easeInOutQuint =
    Ease Ease.easeInOutQuint


{-| -}
easeInExpo : Option
easeInExpo =
    Ease Ease.easeInExpo


{-| -}
easeOutExpo : Option
easeOutExpo =
    Ease Ease.easeOutExpo


{-| -}
easeInOutExpo : Option
easeInOutExpo =
    Ease Ease.easeInOutExpo


{-| -}
easeInCirc : Option
easeInCirc =
    Ease Ease.easeInCirc


{-| -}
easeOutCirc : Option
easeOutCirc =
    Ease Ease.easeOutCirc


{-| -}
easeInOutCirc : Option
easeInOutCirc =
    Ease Ease.easeInOutCirc


{-| -}
easeInBack : Option
easeInBack =
    Ease Ease.easeInBack


{-| -}
easeOutBack : Option
easeOutBack =
    Ease Ease.easeOutBack


{-| -}
easeInOutBack : Option
easeInOutBack =
    Ease Ease.easeInOutBack



-- Other


{-| Get the duration of an animation
-}
duration : Animation -> Millis
duration =
    Internal.duration_
