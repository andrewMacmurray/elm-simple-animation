module TransitionTest exposing (suite)

import Expect
import Internal.Transition as Transition
import Simple.Animation as Animation
import Simple.Transition exposing (color, opacity)
import Test exposing (..)


suite : Test
suite =
    describe "Transition"
        [ test "all options" <|
            \_ ->
                Transition.all
                    { duration = 500
                    , options = [ Animation.delay 200, Animation.linear ]
                    }
                    [ opacity
                    ]
                    |> Transition.render
                    |> Expect.equal "opacity 500ms linear 200ms"
        , test "multiple properties" <|
            \_ ->
                Transition.all
                    { duration = 500
                    , options = [ Animation.delay 200, Animation.linear ]
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
