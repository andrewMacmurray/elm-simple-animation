module Examples.Animations.Sequence exposing (examples)

import Element exposing (..)
import Examples.Animations.Sunflowers.Butterfly as Butterfly
import Examples.Animations.Sunflowers.Sunflower as Sunflower
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Utils.Animated as Animated
import Utils.UI exposing (..)


examples : Element msg -> Element msg
examples =
    groups
        [ group "Sunflowers" sunflowers_
        ]


sunflowers_ : Element msg
sunflowers_ =
    row [ width (fill |> maximum 600) ]
        [ el [ width fill, moveDown 50, moveRight 50 ]
            (sunflower
                { delay = 200
                , restingButterfly = { x = 115, y = 85 }
                , hoveringButterfly = { x = 35, y = 50 }
                }
            )
        , el [ width fill ]
            (sunflower
                { delay = 0
                , restingButterfly = { x = 10, y = 80 }
                , hoveringButterfly = { x = 120, y = 25 }
                }
            )
        , el [ width fill, moveDown 50, moveLeft 50 ]
            (sunflower
                { delay = 400
                , restingButterfly = { x = 110, y = 105 }
                , hoveringButterfly = { x = 50, y = 20 }
                }
            )
        ]


type alias Options =
    { delay : Animation.Millis
    , restingButterfly : { x : Float, y : Float }
    , hoveringButterfly : { x : Float, y : Float }
    }


sunflower : Options -> Element msg
sunflower options =
    el
        [ width fill
        , inFront (butterflies options)
        ]
        (Sunflower.sunflower options.delay)


butterflies : Options -> Element msg
butterflies { delay, restingButterfly, hoveringButterfly } =
    row
        [ centerX
        , width fill
        , height fill
        ]
        [ Animated.el fadeInButterfly
            [ width (px 20)
            , alignLeft
            , alignTop
            , moveRight hoveringButterfly.x
            , moveDown hoveringButterfly.y
            ]
            (Butterfly.hovering delay)
        , Animated.el fadeInButterfly
            [ width (px 20)
            , alignLeft
            , alignTop
            , moveRight restingButterfly.x
            , moveDown restingButterfly.y
            ]
            (Butterfly.resting delay)
        ]


fadeInButterfly : Animation
fadeInButterfly =
    Animation.fromTo
        { duration = 1000
        , options = [ Animation.delay (Sunflower.duration + 500) ]
        }
        [ P.opacity 0 ]
        [ P.opacity 1 ]
