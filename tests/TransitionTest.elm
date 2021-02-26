module TransitionTest exposing (suite)

import Expect
import Internal.Transition as Transition
import Simple.Animation as Animation
import Simple.Transition exposing (color, opacity)
import Test exposing (..)


suite : Test
suite =
    describe "Transition"
        [ test "all" <|
            \_ ->
                Transition.all
                    { duration = 500
                    , options = [ Animation.delay 200 ]
                    }
                    [ opacity
                    , color
                    ]
                    |> Transition.render
                    |> Expect.equal "opacity 500ms ease 200ms, color 500ms ease 200ms"
        ]
