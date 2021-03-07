module Internal.Animation exposing
    ( Animation(..)
    , Frame(..)
    , Iteration(..)
    , Option(..)
    , classDefinition_
    , duration_
    , keyframes_
    , name_
    , renderOption
    , stylesheet_
    )

import Internal.Animation.Property as P exposing (Property)
import Internal.Ease as Ease exposing (Ease)
import Internal.Unit as Unit



-- Animation


type Animation
    = Animation Millis (List Option) (List Frame)


type Option
    = Iteration Iteration
    | Delay Millis
    | Ease Ease


type Frame
    = Frame Percent (List Property)


type Iteration
    = Loop
    | Count Int


type alias Percent =
    Float


type alias Millis =
    Unit.Millis



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
    Unit.pc percent ++ "{" ++ P.render properties ++ ";}"


renderOptions : Animation -> List String
renderOptions =
    options_ >> List.concatMap renderOption


animationDuration : Animation -> String
animationDuration anim =
    Unit.ms (duration_ anim)


renderOption : Option -> List String
renderOption o =
    case o of
        Delay n ->
            [ "animation-delay: " ++ Unit.ms n ]

        Ease e ->
            [ "animation-timing-function: " ++ Ease.toString e ]

        Iteration i ->
            [ "animation-iteration-count: " ++ renderIteration i ]


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
            P.escape (Ease.toString ease)

        Iteration i ->
            iterationName i


frameName : Frame -> String
frameName (Frame dur props) =
    "f" ++ String.fromInt (round dur) ++ joinWith P.name props


joinWith : (a -> String) -> List a -> String
joinWith f =
    List.map f >> String.concat


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
