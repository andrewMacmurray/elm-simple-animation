module DirectionTest exposing (suite)

import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Test exposing (..)
import Utils.Expect as Expect


suite : Test
suite =
    describe "Direction"
        [ test "applies reverse" <|
            \_ ->
                animation [ Animation.reverse ]
                    |> Expect.classProperties
                        [ "animation-direction: reverse"
                        ]
        , test "Adds a 2 count iteration for yoyo with no iteration specified" <|
            \_ ->
                animation [ Animation.yoyo ]
                    |> Expect.classProperties
                        [ "animation-direction: alternate"
                        , "animation-iteration-count: 2"
                        ]
        , test "Doubles actual iteration count if specified with yoyo" <|
            \_ ->
                animation [ Animation.yoyo, Animation.count 2 ]
                    |> Expect.classProperties
                        [ "animation-direction: alternate"
                        , "animation-iteration-count: 4"
                        ]
        , test "Combines yoyo and loop" <|
            \_ ->
                animation [ Animation.yoyo, Animation.loop ]
                    |> Expect.classProperties
                        [ "animation-direction: alternate"
                        , "animation-iteration-count: infinite"
                        ]
        , test "Combines yoyo and reverse into single property" <|
            \_ ->
                animation [ Animation.yoyo, Animation.reverse, Animation.loop ]
                    |> Expect.classProperties
                        [ "animation-direction: alternate-reverse"
                        , "animation-iteration-count: infinite"
                        ]
        ]


animation : List Animation.Option -> Animation
animation options =
    Animation.fromTo
        { duration = 1000
        , options = options
        }
        [ P.opacity 0 ]
        [ P.opacity 1 ]
