module Internal.Animation exposing
    ( Animation
    , Frame(..)
    , Iteration(..)
    , Option(..)
    , classDefinition_
    , duration_
    , keyframes_
    , name_
    , stylesheet_
    )

import Internal.Animation.Property as P exposing (Property)
import Internal.Ease as Ease exposing (Ease)
import Internal.Unit as Unit



-- Animation


type alias Animation =
    { duration : Millis
    , frames : List Frame
    , options : List Option
    }


type Option
    = Iteration Iteration
    | Delay Millis
    | Ease Ease
    | Yoyo
    | Reverse


type Frame
    = Frame Percent (List Property)


type Iteration
    = Loop
    | Count Int


type alias Percent =
    Float


type alias Millis =
    Unit.Millis


type alias Options =
    { delay : Maybe Millis
    , timingFunction : Maybe Ease
    , iteration : Maybe Iteration
    , isYoyo : Bool
    , reversed : Bool
    }


type Direction
    = Alternate_
    | Reverse_
    | AlternateReverse_



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
    options_ >> renderOptions_ >> List.filterMap identity


animationDuration : Animation -> String
animationDuration anim =
    Unit.ms (duration_ anim)


renderOptions_ : Options -> List (Maybe String)
renderOptions_ opts =
    [ renderOption "animation-delay" Unit.ms opts.delay
    , renderOption "animation-timing-function" Ease.toString opts.timingFunction
    , renderOption "animation-iteration-count" renderIteration opts.iteration
    , renderOption "animation-direction" renderDirection (toDirection opts)
    ]


toDirection : Options -> Maybe Direction
toDirection opts =
    if opts.isYoyo && opts.reversed then
        Just AlternateReverse_

    else if opts.reversed then
        Just Reverse_

    else if opts.isYoyo then
        Just Alternate_

    else
        Nothing


renderOption : String -> (a -> String) -> Maybe a -> Maybe String
renderOption name toProp =
    Maybe.map (\x -> name ++ ": " ++ toProp x)


renderDirection : Direction -> String
renderDirection d =
    case d of
        Alternate_ ->
            "alternate"

        Reverse_ ->
            "reverse"

        AlternateReverse_ ->
            "alternate-reverse"


renderIteration : Iteration -> String
renderIteration i =
    case i of
        Loop ->
            "infinite"

        Count count ->
            String.fromInt count



-- Name


name_ : Animation -> String
name_ anim =
    if isEmpty anim then
        "anim-empty"

    else
        "anim-"
            ++ String.fromInt (duration_ anim)
            ++ optionNames (rawOptions_ anim)
            ++ framesNames (frames_ anim)


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

        Yoyo ->
            "yoyo"

        Reverse ->
            "rev"


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


isEmpty : Animation -> Bool
isEmpty anim =
    duration_ anim == 0


options_ : Animation -> Options
options_ =
    rawOptions_
        >> List.foldl collectOption defaults
        >> normalise


normalise : Options -> Options
normalise opts =
    if opts.isYoyo then
        { opts | iteration = Just (iterationForYoyo opts) }

    else
        opts


iterationForYoyo : Options -> Iteration
iterationForYoyo opts =
    case opts.iteration of
        Just Loop ->
            Loop

        Just (Count n) ->
            Count (n * 2)

        Nothing ->
            Count 2


collectOption : Option -> Options -> Options
collectOption o opts =
    case o of
        Delay ms ->
            { opts | delay = Just ms }

        Iteration i ->
            { opts | iteration = Just i }

        Ease e ->
            { opts | timingFunction = Just e }

        Yoyo ->
            { opts | isYoyo = True }

        Reverse ->
            { opts | reversed = True }


defaults : Options
defaults =
    { delay = Nothing
    , timingFunction = Nothing
    , iteration = Nothing
    , isYoyo = False
    , reversed = False
    }


rawOptions_ : Animation -> List Option
rawOptions_ animation =
    animation.options


duration_ : Animation -> Millis
duration_ animation =
    animation.duration


frames_ : Animation -> List Frame
frames_ animation =
    animation.frames
