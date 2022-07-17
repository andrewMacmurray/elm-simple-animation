module FromToTest exposing (suite)

import Expect
import Internal.Animation as Animation
import Simple.Animation as Animation exposing (Animation(..))
import Simple.Animation.Property as P
import Test exposing (..)
import Utils.Expect as Expect


suite : Test
suite =
    describe "FromTo"
        [ test "keyframes" <|
            \_ ->
                Animation.fromTo
                    { duration = 1000
                    , options = []
                    }
                    [ P.opacity 0 ]
                    [ P.opacity 1 ]
                    |> Expect.keyframes
                        [ "0% { opacity: 0 ; }"
                        , "100% { opacity: 1; }"
                        ]
        , test "keyframes with multiple properties" <|
            \_ ->
                Animation.fromTo
                    { duration = 1000
                    , options = []
                    }
                    [ P.opacity 1, P.x 50 ]
                    [ P.opacity 0.5, P.x 100 ]
                    |> Expect.keyframes
                        [ "0% { opacity: 1; transform: translate3d(50px,0,0); }"
                        , "100% { opacity: 0.5; transform: translate3d(100px,0,0); }"
                        ]
        , test "rendering class properties" <|
            \_ ->
                Animation.fromTo
                    { duration = 1000
                    , options = [ Animation.loop, Animation.linear ]
                    }
                    [ P.opacity 0 ]
                    [ P.opacity 1 ]
                    |> Expect.classProperties
                        [ "animation-fill-mode: both"
                        , "animation-iteration-count: infinite"
                        , "animation-duration: 1000ms"
                        , "animation-timing-function: linear"
                        ]
        , test "Empty Animations have formatted name" <|
            \_ ->
                [ Animation.empty
                , Animation.fromTo { duration = 0, options = [] } [] []
                , Animation.steps { startAt = [], options = [] } []
                ]
                    |> List.map (\(Animation anim) -> Animation.name_ anim)
                    |> Expect.equal (List.repeat 3 "anim-empty")
        ]
