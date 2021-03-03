module TransitionTest exposing (suite)

import Expect
import Internal.Transition as Transition
import Simple.Transition exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Transition"
        [ describe "all"
            [ test "all options" <|
                \_ ->
                    Transition.all
                        { duration = 500
                        , options = [ delay 200, linear ]
                        }
                        [ opacity
                        ]
                        |> Transition.render
                        |> Expect.equal "opacity 500ms linear 200ms"
            , test "multiple properties" <|
                \_ ->
                    Transition.all
                        { duration = 500
                        , options = [ delay 200, linear ]
                        }
                        [ opacity
                        , color
                        ]
                        |> Transition.render
                        |> Expect.equal "opacity 500ms linear 200ms, color 500ms linear 200ms"
            , test "using defaults" <|
                \_ ->
                    Transition.all
                        { duration = 500
                        , options = []
                        }
                        [ opacity
                        ]
                        |> Transition.render
                        |> Expect.equal "opacity 500ms ease 0ms"
            ]
        , describe "properties"
            [ test "multiple properties" <|
                \_ ->
                    Transition.properties
                        [ opacity 200 [ delay 100 ]
                        , color 500 [ easeInOut ]
                        ]
                        |> Transition.render
                        |> Expect.equal "opacity 200ms ease 100ms, color 500ms ease-in-out 0ms"
            , test "single property" <|
                \_ ->
                    Transition.properties
                        [ opacity 200 []
                        ]
                        |> Transition.render
                        |> Expect.equal "opacity 200ms ease 0ms"
            ]
        ]
