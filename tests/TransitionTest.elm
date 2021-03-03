module TransitionTest exposing (suite)

import Expect
import Internal.Transition as Transition
import Simple.Transition exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Transition"
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
