module Internal.Animation exposing
    ( Animation(..)
    , Ease(..)
    , Frame(..)
    , Iteration(..)
    , Millis
    , Option(..)
    , classDefinition_
    , duration_
    , findDelayOption
    , findEaseOption
    , keyframes_
    , ms
    , name_
    , renderOption
    , renderOptionShorthand
    , stylesheet_
    )

import Internal.Property as P exposing (Property)



-- Animation


type Animation
    = Animation Millis (List Option) (List Frame)


type Option
    = Iteration Iteration
    | Delay Millis
    | Ease Ease


type Frame
    = Frame Percent (List Property)


type Ease
    = Cubic Float Float Float Float
    | Linear
    | EaseIn
    | EaseOut
    | EaseInOut
    | Default


type Iteration
    = Loop
    | Count Int


type alias Percent =
    Float


type alias Millis =
    Int



-- Render


stylesheet_ : Animation -> String
stylesheet_ anim =
    keyframesAnimation_ anim ++ "\n" ++ classDefinition_ anim


keyframesAnimation_ : Animation -> String
keyframesAnimation_ anim =
    "@keyframes " ++ name_ anim ++ "{" ++ keyframes_ anim ++ "}"


classDefinition_ : Animation -> String
classDefinition_ anim =
    "." ++ name_ anim ++ "{\n" ++ classProperties anim ++ "\n};"


classProperties : Animation -> String
classProperties anim =
    String.join ";\n"
        (List.append
            [ "animation-name: " ++ name_ anim
            , "animation-duration: " ++ animationDuration anim
            , "animation-fill-mode: both"
            ]
            (renderOptions anim)
        )


keyframes_ : Animation -> String
keyframes_ =
    frames_
        >> List.map renderFrame
        >> String.join "\n"


renderFrame : Frame -> String
renderFrame (Frame percent properties) =
    pc percent ++ "{" ++ P.render properties ++ ";}"


renderOptions : Animation -> List String
renderOptions =
    options_ >> List.concatMap renderOption


animationDuration : Animation -> String
animationDuration anim =
    ms (duration_ anim)


ms : Int -> String
ms n =
    String.fromInt n ++ "ms"


pc : Float -> String
pc n =
    String.fromFloat n ++ "%"


renderOption : Option -> List String
renderOption o =
    case o of
        Delay n ->
            [ "animation-delay: " ++ ms n ]

        Ease e ->
            [ "animation-timing-function: " ++ renderEase e ]

        Iteration i ->
            [ "animation-iteration-count: " ++ renderIteration i ]


renderOptionShorthand : Option -> String
renderOptionShorthand o =
    case o of
        Delay n ->
            ms n

        Ease e ->
            renderEase e

        Iteration i ->
            renderIteration i


findDelayOption : List Option -> Option
findDelayOption =
    List.foldl
        (\o acc ->
            case o of
                Delay _ ->
                    o

                _ ->
                    acc
        )
        (Delay 0)


findEaseOption : List Option -> Option
findEaseOption =
    List.foldl
        (\o acc ->
            case o of
                Ease _ ->
                    o

                _ ->
                    acc
        )
        (Ease Default)


renderEase : Ease -> String
renderEase e =
    case e of
        Cubic a b c d ->
            "cubic-bezier("
                ++ String.join ","
                    [ String.fromFloat a
                    , String.fromFloat b
                    , String.fromFloat c
                    , String.fromFloat d
                    ]
                ++ ")"

        Linear ->
            "linear"

        EaseIn ->
            "ease-in"

        EaseOut ->
            "ease-out"

        EaseInOut ->
            "ease-in-out"

        Default ->
            "ease"


renderIteration : Iteration -> String
renderIteration i =
    case i of
        Loop ->
            "infinite"

        Count count ->
            String.fromInt count



-- Name


name_ : Animation -> String
name_ (Animation d options frames) =
    "anim-" ++ String.fromInt d ++ optionNames options ++ framesNames frames


optionNames : List Option -> String
optionNames =
    joinWith optionName


framesNames : List Frame -> String
framesNames =
    joinWith frameName


optionName : Option -> String
optionName o =
    case o of
        Delay n ->
            "d" ++ String.fromInt n

        Ease ease ->
            easeName ease

        Iteration i ->
            iterationName i


frameName : Frame -> String
frameName (Frame dur props) =
    "f" ++ String.fromInt (round dur) ++ joinWith P.name props


joinWith : (a -> String) -> List a -> String
joinWith f =
    List.map f >> String.concat


easeName : Ease -> String
easeName e =
    case e of
        Cubic a b c d ->
            "cubic" ++ String.fromInt (round (a + b + c + d))

        Linear ->
            "linear"

        EaseIn ->
            "ease-in"

        EaseOut ->
            "ease-out"

        EaseInOut ->
            "ease-in-out"

        Default ->
            "ease"


iterationName : Iteration -> String
iterationName i =
    case i of
        Loop ->
            "infinite"

        Count count ->
            "count-" ++ String.fromInt count



-- Helpers


options_ : Animation -> List Option
options_ (Animation _ o _) =
    o


duration_ : Animation -> Millis
duration_ (Animation d _ _) =
    d


frames_ : Animation -> List Frame
frames_ (Animation _ _ f) =
    f
