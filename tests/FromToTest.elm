module FromToTest exposing (suite)

import Simple.Animation as Animation exposing (Animation)
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
                        [ "0% { opacity: 1; transform: translateX(50px); }"
                        , "100% { opacity: 0.5; transform: translateX(100px); }"
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
        ]
