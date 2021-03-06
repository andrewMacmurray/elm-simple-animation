module StepsTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz
import Internal.Animation as Internal
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Test exposing (..)
import Utils.Expect as Expect


suite : Test
suite =
    describe "Steps"
        [ testWithDurations "Steps add up to the total duration" <|
            \d1 d2 d3 ->
                Animation.steps
                    { options = []
                    , startAt = [ P.opacity 0 ]
                    }
                    [ Animation.step d1 [ P.opacity 1 ]
                    , Animation.step d2 [ P.opacity 0 ]
                    , Animation.step d3 [ P.opacity 1 ]
                    ]
                    |> Internal.duration_
                    |> Expect.equal (d1 + d2 + d3)
        , test "Calculates percentages for each step" <|
            \_ ->
                let
                    d1 =
                        1000

                    d2 =
                        2000

                    d3 =
                        1000

                    totalDuration =
                        d1 + d2 + d3

                    percent n =
                        n * 100
                in
                Animation.steps
                    { options = []
                    , startAt = [ P.opacity 0 ]
                    }
                    [ Animation.step d1 [ P.opacity 1 ]
                    , Animation.step d2 [ P.opacity 0 ]
                    , Animation.step d3 [ P.opacity 1 ]
                    ]
                    |> Expect.keyframes
                        [ frame 0 "{ opacity: 0; }"
                        , frame (percent (d1 / totalDuration)) "{ opacity: 1; }"
                        , frame (percent ((d1 + d2) / totalDuration)) "{ opacity: 0; }"
                        , frame (percent ((d1 + d2 + d3) / totalDuration)) "{ opacity: 1; }"
                        ]
        , test "wait repeats the previous frame + duration" <|
            \_ ->
                Animation.steps
                    { options = []
                    , startAt = [ P.opacity 0 ]
                    }
                    [ Animation.wait 500
                    , Animation.step 500 [ P.opacity 1 ]
                    ]
                    |> Expect.keyframes
                        [ frame 0 "{ opacity: 0; }"
                        , frame 50 "{ opacity: 0; }"
                        , frame 100 "{ opacity: 1; }"
                        ]
        , describe "waitUntilComplete"
            [ test "ensures given animation's duration has passed until the next step" <|
                \_ ->
                    steps
                        [ Animation.step 500 []
                        , Animation.waitTillComplete (fromToWithDuration 2000)
                        ]
                        |> Animation.duration
                        |> Expect.equal 2000
            , test "adds a wait step with remaining duration" <|
                \_ ->
                    steps
                        [ Animation.step 500 [ P.opacity 1 ]
                        , Animation.waitTillComplete (fromToWithDuration 2000)
                        ]
                        |> Expect.keyframes
                            [ frame 0 "{ opacity: 0; }"
                            , frame 25 "{ opacity: 1; }"
                            , frame 100 "{ opacity: 1; }"
                            ]
            , test "adds a single ms step if duration has already passed" <|
                \_ ->
                    steps
                        [ Animation.step 2000 []
                        , Animation.waitTillComplete (fromToWithDuration 2000)
                        , Animation.step 500 []
                        ]
                        |> Animation.duration
                        |> Expect.equal 2501
            ]
        ]


steps : List Animation.Step -> Animation
steps =
    Animation.steps
        { options = []
        , startAt = [ P.opacity 0 ]
        }


fromToWithDuration : Animation.Millis -> Animation
fromToWithDuration ms =
    Animation.fromTo
        { duration = ms
        , options = []
        }
        [ P.opacity 0 ]
        [ P.opacity 1 ]


frame : Float -> String -> String
frame n f =
    String.fromFloat n ++ "%" ++ f


testWithDurations : String -> (Int -> Int -> Int -> Expectation) -> Test
testWithDurations =
    Test.fuzz3 duration duration duration


duration : Fuzz.Fuzzer Int
duration =
    Fuzz.intRange 1 100000
