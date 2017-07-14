module Components.Bulma exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Form exposing (Form)
import Form.Field as Field
import Form.Input as Input
import Form.Error exposing (Error, ErrorValue)


type alias FieldGroup a =
    String -> Form.FieldState String a -> Html Form.Msg


classField =
    "flex flex-column flex-row-ns items-center-ns"


classLabel =
    "w-100 tl mv2 w5-ns mr3-ns tr-ns"


classControl =
    "flex flex-column w-100"


classInput =
    "input-reset input-focus pa2 ba bt b-black-40 br2 bg-transparent f4 flex-auto"


baseInput : String -> FieldGroup String
baseInput type_ labelText field =
    div [ class classField ]
        [ label [ class classLabel ] [ text labelText ]
        , p [ class classControl ]
            [ Input.baseInput type_
                Field.String
                Form.Text
                field
                [ class <| String.join " " [ classInput, errorClass field.liveError ]
                , value (Maybe.withDefault "" field.value)
                , placeholder labelText
                ]
            , errorMessage field.liveError
            ]
        ]


textInput : FieldGroup String
textInput =
    baseInput "text"


emailInput : FieldGroup String
emailInput =
    baseInput "email"


telInput : FieldGroup String
telInput =
    baseInput "tel"


radioInput : List ( String, String ) -> FieldGroup String
radioInput options labelText field =
    let
        optionNode ( v, l ) =
            label []
                [ Input.radioInput v field [ class "dn" ]
                , span [ class "radio" ] [ text l ]
                ]
    in
        div [ class classField ]
            [ label [ class classLabel ] [ text labelText ]
            , p [ class "flex flex-row w-100" ]
                (List.map optionNode options)
            , errorMessage field.liveError
            ]


textAreaInput : FieldGroup String
textAreaInput labelText field =
    div [ class classField ]
        [ label [ class classLabel ] [ text labelText ]
        , p [ class classControl ]
            [ Input.textArea field
                [ class <| String.join " " [ classInput, errorClass field.liveError ]
                , placeholder "内容を入力"
                , value (Maybe.withDefault "" field.value)
                ]
            , errorMessage field.liveError
            ]
        ]


errorClass : Maybe error -> String
errorClass maybeError =
    Maybe.map (\_ -> "is-danger") maybeError |> Maybe.withDefault ""


errorMessage : Maybe (ErrorValue String) -> Html Form.Msg
errorMessage maybeError =
    case maybeError of
        Just error ->
            p [ class "help is-danger" ] [ text (errorToString error) ]

        Nothing ->
            text ""


errorToString : ErrorValue String -> String
errorToString error =
    case error of
        Form.Error.InvalidString ->
            "不正な文字が含まれています"

        Form.Error.InvalidEmail ->
            "メアドが"

        Form.Error.Empty ->
            "入力をお願いします"

        Form.Error.CustomError errorString ->
            errorString

        _ ->
            toString error


buttonFullWidthClass : String -> String
buttonFullWidthClass modifier =
    "f6 link dim br2 ba bw2 ph3 pv2 mb2 dib " ++ modifier


baseButton :
    String
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
baseButton c attr elem =
    div [ class "ph3" ]
        [ button ([ class <| buttonFullWidthClass c ] ++ attr) elem ]


primaryButton : List (Attribute msg) -> List (Html msg) -> Html msg
primaryButton attr elem =
    baseButton "blue" attr elem


infoButton : List (Attribute msg) -> List (Html msg) -> Html msg
infoButton attr elem =
    baseButton "light-silver" attr elem


dangerButton : List (Attribute msg) -> List (Html msg) -> Html msg
dangerButton attr elem =
    baseButton "dark-red" attr elem


warningButton : List (Attribute msg) -> List (Html msg) -> Html msg
warningButton attr elem =
    baseButton "yellow" attr elem
