module TransformTest exposing (suite)

import Expect
import Internal.Transform as Transform
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Transforms"
        [ test "Transforms are ordered by `translate`, `scale`, `rotate`" <|
            \_ ->
                [ Transform.scale 5
                , Transform.x 5
                , Transform.y 5
                , Transform.rotate 5
                ]
                    |> Transform.toString
                    |> Expect.equal "translate3d(5px,0,0) translate3d(0,5px,0) scale3d(5,5,1) rotate3d(0,0,1,5deg)"
        , test "The last property wins if duplicated" <|
            \_ ->
                [ Transform.rotate 5
                , Transform.x 5
                , Transform.rotate 12
                , Transform.x 10
                ]
                    |> Transform.toString
                    |> Expect.equal "translate3d(10px,0,0) rotate3d(0,0,1,12deg)"
        ]
