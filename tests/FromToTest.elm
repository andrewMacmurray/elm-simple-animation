module FromToTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz
import Internal.Animation as Internal
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Test exposing (..)


suite : Test
suite =
    describe "Animation"
        [ fromToSuite
        , stepsSuite
        ]


fromToSuite : Test
fromToSuite =
    describe "FromTo"
        [ test "keyframes" <|
            \_ ->
                Animation.fromTo
                    { duration = 1000
                    , options = []
                    }
                    [ P.opacity 0 ]
                    [ P.opacity 1 ]
                    |> expectKeyframes
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
                    |> expectKeyframes
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
                    |> expectClassProperties
                        [ "animation-fill-mode: both"
                        , "animation-iteration-count: infinite"
                        , "animation-duration: 1000ms"
                        , "animation-timing-function: linear"
                        ]
        ]


stepsSuite : Test
stepsSuite =
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
                    |> expectKeyframes
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
                    |> expectKeyframes
                        [ frame 0 "{ opacity: 0; }"
                        , frame 50 "{ opacity: 0; }"
                        , frame 100 "{ opacity: 1; }"
                        ]
        ]


frame : Float -> String -> String
frame n f =
    String.fromFloat n ++ "%" ++ f


testWithDurations =
    Test.fuzz3 dur dur dur


dur =
    Fuzz.intRange 1 100


expectKeyframes : List String -> Internal.Animation -> Expectation
expectKeyframes expected anim =
    Internal.keyframes_ anim
        |> format
        |> Expect.equal (format (String.concat expected))


expectClassProperties : List String -> Animation -> Expectation
expectClassProperties props anim =
    Internal.classDefinition_ anim
        |> (\def -> List.all (\prop -> String.contains prop def) props)
        |> Expect.true ("unexpected class properties in: \n" ++ Internal.classDefinition_ anim)


format : String -> String
format =
    String.filter (\c -> c /= ' ' && c /= '\n')
